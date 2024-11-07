"""A simple fake API server for development and testing.

This supports two modes:

1. Replay mode

This is the mode typically used during development and always used during testing. Any request matching by path a file
on the filesystem will simply return the file's contents.

Why not use the real API to start with?  We don't want behavior to change on us.  This would be too distracting,
and make testing difficult.  Only a very small, static, yet real (for fidelity) set of API data is scraped and stored.

Example:
  python FakeAPI/Main.py --mode replay --static-root FakeAPI/data/api.spoonacular.com


2. Proxy record mode

This mode is used to conveniently update the fake API's response files with the real response. Requests are forwarded
to a real API and responses (if succesful and JSON) are written back to the file system before being returned.

Example usage:
  python FakeAPI/Main.py --mode proxy-record --api https://api.spoonacular.com --static-root FakeAPI/data/api.spoonacular.com
"""

import argparse
import flask
import json
import os
import requests
import urllib.parse
import werkzeug.http

app = flask.Flask(__name__)

parser = argparse.ArgumentParser()
parser.add_argument("--port", type=int, default=3001)
parser.add_argument(
    "--mode", required=True, choices=["proxy-record", "replay"], default="replay"
)
parser.add_argument("--static-root", default="/tmp/API-Proxy-Static-Root")
parser.add_argument("--api")
args = parser.parse_args()
if args.mode == "proxy-record":
    if args.api is None:
        raise ValueError("You must specify --proxy-dest in proxy-record mode.")
    api = urllib.parse.urlsplit(args.api)


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def catch_all(path):
    orig_url = urllib.parse.urlsplit(flask.request.url)

    # The file we will either save to (when recording) or serve (when replaying).
    fpath = f"{args.static_root}/{orig_url.path}"
    if orig_url.query:
        fpath += f"?{orig_url.query}"

    if args.mode == "proxy-record":
        # Derive new URL from the provided URL and API configuration.
        new_url = orig_url._replace(scheme=api.scheme, netloc=api.netloc)
        if api.path:
            new_url = new_url._replace(path=f"{api.path}{orig_url.path}")
        print(urllib.parse.urlunsplit(new_url))

        # Determine the subset of request headers to forward.
        new_request_headers = {}
        for k, v in flask.request.headers:
            # Hop-by-hop headers should never be forwarded since relevant only to the client-proxy connection.
            # The host header is always wrong, since we rewrite the host portion of the URL.
            if not werkzeug.http.is_hop_by_hop_header(k) and k != "Host":
                new_request_headers[k] = v

        # Make the remote proxy request.
        response = requests.get(
            urllib.parse.urlunsplit(new_url), headers=new_request_headers
        )

        # Record the contents of successful JSON requests for future uses in non-proxy mode.
        if response.status_code == 200:
            try:
                response_json = response.json()
            except:
                pass
            else:  # We're actually dealing with JSON.
                os.makedirs(os.path.dirname(fpath), exist_ok=True)
                with open(fpath, "w") as f:
                    # We prefer to record our re-encoded response to enforce readable / pretty json on the filesystem.
                    f.write(json.dumps(response_json, indent=2))
                print(f"JSON for 200 response saved to {fpath}")

        # Determine the subset of response headers to forward.
        new_response_headers = {}
        for k, v in response.headers.items():
            # Same here, hop-by-hop headers should never be forwarded since relevant only to the proxy-destination connection.
            # Content encoding surprisingly isn't covered by werkzeug - discovered with the Python backend server (client of)
            # this server) running into non-gzipped content declared as gzipped. Hopefully we don't run into further such fragility.
            if not werkzeug.http.is_hop_by_hop_header(k) and k != "Content-Encoding":
                new_response_headers[k] = v

        return flask.Response(
            response=response.content,
            status=response.status_code,
            headers=new_response_headers,
        )

    if args.mode == "replay":
        # We're simply serving static json content in this mode.  JSON is assumed not to have
        # to support multiple content types.
        if not os.path.exists(fpath):
            return flask.Response(
                response=f"File {fpath} not found in fake.",
                status=404,
            )

        with open(fpath, "r") as f:
            return flask.Response(
                response=f.read(), status=200, mimetype="application/json"
            )


if __name__ == "__main__":
    app.run(debug=True, port=args.port)
