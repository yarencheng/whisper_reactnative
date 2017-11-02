FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl tar software-properties-common debconf-utils unzip vim lib32stdc++6 lib32z1 make wget

#
# Install NodeJs
#
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN add-apt-repository  ppa:webupd8team/java
RUN apt-get install -y nodejs

#
# Install react native
#
EXPOSE 8081/TCP
RUN npm install -g create-react-native-app
RUN npm install -g react-native-cli
RUN npm install -g nuclide

#
# Install Java
#
RUN add-apt-repository  ppa:webupd8team/java
RUN apt-get update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

#
# Download Android SDK
#
RUN curl https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o /android_sdk.zip && \
    unzip -d /android_sdk -q /android_sdk.zip && \
    rm /android_sdk.zip
RUN echo y | /android_sdk/tools/bin/sdkmanager "add-ons;addon-google_apis-google-23"
RUN echo y | /android_sdk/tools/bin/sdkmanager "platforms;android-23"
RUN echo y | /android_sdk/tools/bin/sdkmanager "system-images;android-23;default;x86"
RUN echo y | /android_sdk/tools/bin/sdkmanager "system-images;android-23;google_apis;x86"
RUN echo y | /android_sdk/tools/bin/sdkmanager "platform-tools"
RUN echo y | /android_sdk/tools/bin/sdkmanager "build-tools;23.0.1"
ENV ANDROID_HOME "/android_sdk"
ENV PATH "${PATH}:${ANDROID_HOME}/tools"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"

#
# Download ANdroid NDK
#
RUN curl http://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip -o /android_ndk.zip && \
    unzip -d /android_ndk -q /android_ndk.zip && \
    rm /android_ndk.zip
ENV ANDROID_NDK "/android_ndk/android-ndk-r10e"

#
# Install git
#
RUN apt-get install -y git
RUN git config --global alias.co checkout
RUN git config --global alias.br branch
RUN git config --global alias.ci commit
RUN git config --global alias.st status

#
# Install watchman
#
RUN apt-get install -y libtool m4 automake pkg-config libssl-dev python-dev
RUN git clone https://github.com/facebook/watchman.git
RUN cd /watchman && git checkout v4.9.0
RUN cd /watchman && ./autogen.sh
RUN cd /watchman && ./configure
RUN cd /watchman && make -j`nproc`
RUN cd /watchman && make install -j`nproc`

#
# Install ssh server
#
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:aaaaaa' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22/TCP
ENTRYPOINT service ssh restart && bash
