## How to Build - Android

1. Clone this project

   ```
   cd /workspace
   git clone git@github.com:yarencheng/whisper_reactnative.git
   cd /workspace/whisper_reactnative
   ```
2. Build and use docker container
   * Build docker image

      ```
      docker build --tag whisper_reactnative .
      ```
   * Run docker container
   
      ```
      docker run -idt --privileged \
         -w `pwd` -v `pwd`:`pwd` \
         --name whisper_reactnative \
         -p 8022:22 \
         -p 8081:8081 \
         -p 9099:9099 \
         whisper_reactnative
      ```
      
      * ```-p 8022:22``` set ```8022``` as SSH port
      
      * ```-p 8081:8081``` expose port ```8081``` which is used later by ```react-native start```
      
      * ```-p 9099:9099``` expose port ```9099``` which is used later by ```nuclide-start-server```

3. Unit Test

   ```
   cd android
   ./gradlew testDebugUnitTest
   ```

4. Build app-debug.apk

   * switch into docker container
   
      ```docker attach whisper_reactnative```
      
      press ``` ctrl + p ``` then ``` crtl + q ``` to detach
      
   * update npm modules(optional)
   
      ``` npm update ```
   
   * build
   
      ```
      cd android/
      ./gradlew assembleDebug
      ```
      
   * app-debug.apk is at
   
      ```android/app/build/outputs/apk/app-debug.apk```

## How to build - iOS

TBD

## Modify code

   * install [Atom](https://atom.io/)
   * install [nuclide](https://nuclide.io/docs/editor/setup/)
   * click ```Add Remote Project Folder```
      
      * Username: ```root```
      
      * Server: ```your_ip```
      
      * SSH port: ```8022```
      
      * Initail Directory: ```/workspace/whisper_reactnative```
      
      * Password: ```aaaaaa```
      
         defined in ```Dockerfile```
      
      * Remote Server Command: ```nuclide-start-server --port 9099 -k```
