pipeline {
    agent any
    options {
       parallelsAlwaysFailFast()
    }
    environment {
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
        DIR = 'EatRight'
        ANDROID_DIR = 'EatRight/android'
        DOCKER_COMPOSE_CMD = "docker compose --profile with-android -p ${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                sh 'git clone https://$GITHUB_TOKEN@github.com/nicbov/EatRight.git'
                // This (and the chown below) deals with the fact that the container uid is different from Jenkins'
                // uid, and both operate on the workspace filesystem state.  This is a known annoyance with Docker
                // and volumes.  Possible alternatives (but they are non-trivial and come with their own set of
                // issues today) are:
                //   1.  Make the uid in the image match that of our server.
                //       (Ugly since it tightly couples our source code with our Jenkins deployment.  More doable
                //       in a corporate environment.)
                //   2.  Create Jenkins uid and change file ownership on container startup.
                //       (Delay at startup for filesystem operations.)
                //   3.  Use a userspace ns to map the image uid to the host uid.
                //       (Not well supported by Docker yet.)
                sh 'chmod -R o+rwX EatRight'
            }
        }
        stage('Run') {
            parallel {
                stage('Environment') {
                    steps {
                        dir(DIR) {
                            script {
                                sh "${env.DOCKER_COMPOSE_CMD} build"
                                // NB: --abort-on-container-exit causes races with docker compose down, resulting in this command
                                // exiting with failure, which causes the build to fail.
                                sh "${env.DOCKER_COMPOSE_CMD} up --abort-on-container-failure --force-recreate --timestamps"
                            }
                        }
                    }
                }
                stage('Main') {
                    stages {
                        stage('Wait for Emulator') {
                            // We only need to wait for docker exec into the android emulator to succeed.  ADB
                            // finding the emulator is a small extra step that takes a few seconds and gives us
                            // some indication the emulator startup is healthy.
                            // (We also need the emulator to be fully ready by the time the test execute. That
                            // is not expressed in this config.  We simply expect the emulator to be ready by
                            // the time the tests are build.  This works in practice, i.e. it is not a source
                            // of flakiness.)
                            steps {
                                dir(DIR) {
                                    script {
                                        def timeout = 120
                                        def interval = 1

                                        for (int i = 0; i < timeout; i++) {
                                            try {
                                                def output = sh(script: "${env.DOCKER_COMPOSE_CMD} exec android adb devices", returnStdout: true)
                                                println "Output: $output"
                                                if (output.contains('emulator-5556')) {
                                                    println "Emulator found!"
                                                    return
                                                }
                                            } catch (Exception e) {
                                                println "Error executing command: ${e.message}"
                                            }
                                            println "Waiting for emulator..."
                                            sleep interval
                                        }
                                        error "Timeout waiting for emulator"
                                    }
                                }
                            }
                        }
                        stage('Build') {
                            // Build only first, b/c it is time-consuming and we don't want to waste recording video while nothing happens.
                           steps {
                                dir(ANDROID_DIR) {
                                    sh "${env.DOCKER_COMPOSE_CMD} exec android sh -c \"cd /EatRight/android && gradle assembleDebug\""
                                }
                            }
                        }
                        stage('Test') {
                            steps {
                                dir(ANDROID_DIR) {
                                    sh "${env.DOCKER_COMPOSE_CMD} exec android sh -c \"socat TCP-LISTEN:3000,fork TCP:backend:3000 & adb -s emulator-5556 shell screenrecord /sdcard/screen.mp4 & cd /EatRight/android && ANDROID_SERIAL=emulator-5556 gradle connectedAndroidTest\""
                                    sh "${env.DOCKER_COMPOSE_CMD} exec android sh -c \"cd /EatRight/android && adb -s emulator-5556 kill-server && adb -s emulator-5556 pull /sdcard/screen.mp4\""
                                    sh "${env.DOCKER_COMPOSE_CMD} exec android sudo find /EatRight/ -user circleci -print -exec chown \$(id -u):\$(id -g) {} \\;"
                                }
                            }
                        }
                        stage('Terminate other branches') {
                            steps  {
                                dir(DIR) {
                                    sh "${env.DOCKER_COMPOSE_CMD} down"
                                }
                            }
                        }
                    }
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'EatRight/android/app/build/reports/androidTests/connected/,EatRight/android/screen.mp4'
                    dir(DIR) {
                        sh "${env.DOCKER_COMPOSE_CMD} rm -fsv"
                    }
                    cleanWs()
                    discordSend(
                        webhookURL: "https://discord.com/api/webhooks/1308974200295391373/UbQUGXJKTkYhCIVhXSdzAPPeUixpUIBDP9QhJlMBnMFWUK-KcUZWhH3R3UYPcLPcQxeN",
                        description: "Build ID: ${env.BUILD_NUMBER}\nBuild Status: ${currentBuild.currentResult}\nBuild Duration: ${currentBuild.durationString.minus(' and counting')}",
                        footer: '',
                        image: '',
                        link: env.BUILD_URL,
                        result: currentBuild.currentResult,
                        scmWebUrl: 'https://github.com/nicbov/EatRight',
                        thumbnail: 'https://sebastienboving.com/eatright_logo.png',
                        title: JOB_NAME
                    )
                }
            }
        }
    }
}