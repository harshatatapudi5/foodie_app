# Build and Sync script for Foodie JEE application
$ErrorActionPreference = "Stop"

Write-Host "Compiling Java sources..." -ForegroundColor Cyan

$tomcatLib = "D:/SOFTWARE/apache-tomcat-10.1.59-windows-x64/apache-tomcat-10.1.59/lib/*"
$webInfLib = "src/main/webapp/WEB-INF/lib/*"
$classpath = "$tomcatLib;$webInfLib"

$javaFiles = (Get-ChildItem -Recurse -Filter *.java src/main/java).FullName

if (-not (Test-Path "build/classes")) {
    New-Item -ItemType Directory -Force -Path "build/classes" | Out-Null
}

javac -encoding UTF-8 -cp $classpath -d build/classes $javaFiles

Write-Host "Copying classes to WEB-INF/classes..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "src/main/webapp/WEB-INF/classes" | Out-Null
Copy-Item -Recurse -Force "build/classes/*" -Destination "src/main/webapp/WEB-INF/classes/"

New-Item -ItemType Directory -Force -Path ".vscode/tomcat/webapp/JEE/WEB-INF/classes" | Out-Null
Copy-Item -Recurse -Force "build/classes/*" -Destination ".vscode/tomcat/webapp/JEE/WEB-INF/classes/"

Write-Host "Syncing webapp assets to Tomcat deploy folder..." -ForegroundColor Cyan
Copy-Item -Path "src/main/webapp/*" -Destination ".vscode/tomcat/webapp/JEE" -Recurse -Force

Write-Host "SUCCESS: Application build and Tomcat deployment updated!" -ForegroundColor Green
