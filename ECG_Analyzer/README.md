# ECG Analyzer

This project (work in progress) was created as part of one subject in the field of Biomedical Engineering. The project I found interesting, thus I decided to rewrite it by myself. As GUI of this project was created mostly by myself, I used the source code written by myself and refactored it. On this moment, this is the only part of this (still developing) application. Some screenshoots of the app can be seen inside [AppScreens](AppScreens) folder.

This application should serve the purpose of ECG Analyzing.

## Building and Deploying the project for Windows

Prerequisites:
- Windows
- Qt 5.15.2
- CMake and Ninja are NOT necessary (they are included in the Qt distribution)

Steps of building and deploying the project for Windows:
1. Open *Qt Command Prompt* (*Qt 5.15.2 (MinGW 8.1.0 64-bit)*). For that purpose *1_QtEnvironment.bat* file was written. Adjust paths for yourself in this batch file, change working directory of the cmd to the directory of this project and run this batch file.
1. Generate project files using *2_GenerateProjectFiles.bat*.
1. Build project using *3_Build.bat*.
1. You can run the application using *4_Run.bat*, but keep in mind, that this application is run in the Qt Envirionment. To run this application outside of the Qt Envirionment:
1. Deploy application using *5_Deploy.bat*. Application ready to run outside of the Qt Environment should be visible in the build folder of this project (*build/ECG_Analyzer.exe*).
