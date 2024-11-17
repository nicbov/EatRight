
FROM cimg/android:2024.11.1

RUN sdkmanager --list && \
    sdkmanager --verbose --install 'system-images;android-34;aosp_atd;x86_64' && \
    sdkmanager --verbose --install 'build-tools;34.0.0'

RUN avdmanager create avd -n fakephone -d pixel_3 -k "system-images;android-34;aosp_atd;x86_64"

RUN sudo groupadd -r kvm && sudo gpasswd -a root kvm

RUN echo hw.audioInput=no >> ~/.android/avd/pixel7pro_android35.ini && \
    echo hw.audioOutput=no >> ~/.android/avd/pixel7pro_android35.ini && \
    echo hw.GPS=no >> ~/.android/avd/pixel7pro_android35.ini
RUN sudo apt update && sudo apt install socat

# aosp_atd image's emulator output suggests they can benefit from these drivers.
RUN sudo apt install libvulkan1 mesa-vulkan-drivers

ENV USER=circleci
ENV HOME=/home/circleci
ENV GRADLE_HOME=/usr/local/gradle-8.10.2
ENV GRADDLE_USER_HOME=/home/circleci/.gradle
ENV PATH="$PATH:$GRADLE_HOME/bin"

ENTRYPOINT ["sh", "-c", "sudo chown $USER /dev/kvm && exec emulator -avd fakephone -no-snapshot -no-qt -no-metrics -no-boot-anim -no-audio -port 5556"]
