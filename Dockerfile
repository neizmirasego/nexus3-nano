#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#
# This docker file will stand-up a Nexus artifact repository
#
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#### Build container
FROM mcr.microsoft.com/windows/nanoserver:sac2016 as installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\\nexus

RUN Write-Host "Downloading nexus..."; \
	Invoke-WebRequest "http://download.sonatype.com/nexus/3/latest-win64.zip" -OutFile 'C:\nexus\nexus.zip' -UseBasicParsing

RUN Expand-Archive 'nexus.zip' -DestinationPath 'C:\nexus'
RUN Remove-Item -Path 'C:\nexus\*.zip' -Filter '*.zip' -Force
RUN Get-ChildItem -Path 'C:\nexus' -Filter 'nexus-*' -Directory | Rename-Item -NewName 'nexus_root' -Force
#COPY start.ps1 . 
COPY nexus.vmoptions /nexus/nexus_root/bin

#### Runtime Container
FROM mcr.microsoft.com/windows/nanoserver:sac2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

EXPOSE 8081
WORKDIR C:\\nexus
ENTRYPOINT C:\nexus\nexus_root\bin\nexus.exe /run

RUN MKDIR c:\\data
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value "\??\C:\data" -Type String 

COPY --from=installer C:\\nexus . 
