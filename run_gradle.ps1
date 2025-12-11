cd android
.\gradlew.bat assembleDebug --stacktrace --warning-mode all 2>&1 | Tee-Object -FilePath ..\gradle_error.log
