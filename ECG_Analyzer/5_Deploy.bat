@echo off
echo Deploying project...
pushd build
windeployqt.exe --qmldir ..\ECG_Analyzer ECG_Analyzer.exe
popd
