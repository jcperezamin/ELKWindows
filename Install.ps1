# Installing Elasticsearch, Logstash and Kibana (ELK) on Windows Server 2012 R2

# Pause
Function Pause {
Write-Host -NoNewLine "Press any key to continue... `n"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Write-Host " "
Write-Host "Make sure the Java SDK is installed and the JAVA_HOME system variable is configured prior to running this script!"
Write-Host " "
Write-Host "Download and unzip all of the packages to a common directory (ex c:\ELK-Stack)"

Pause

# Installing Elasticsearch
Write-Host " "
Write-Host "Installing Elasticsearch..."

# Install Elasticsearch as Windows Service
Write-Host "Installing Elasticsearch as Windows Service..."
Invoke-Expression -command "c:\ELK-Stack\elasticsearch\bin\service install"

# Open the Elasticsearch service properties
Write-Host " "
Write-Host "Opening the Elasticsearch service properties..."
Write-Host "Make sure to set the service to auto and start it."
Invoke-Expression -command "c:\ELK-Stack\elasticsearch\bin\service manager"

Pause

# Verify Elasticsearch is running
Write-Host "Verify the Elasticsearch service is running via Invoke-WebRequest..."
Invoke-WebRequest http://127.0.0.1:9200/

Pause

Write-Host "Verify the Elasticsearch service is running via Chrome."
start chrome http://127.0.0.1:9200/

Pause

# Installing Logstash
Write-Host "Installing Logstash..."

# Download the config file and save it to the Logstash \bin directory
Write-Host "Downloading the logstash.json configuration file to the logstash\bin directory..."
Start-BitsTransfer -Source http://robwillis.info/data/ELK-Stack/Config-Files/logstash.json -Destination c:\ELK-Stack\logstash\bin\

# Use NSSM to create the Logstash service
Write-Host "Invoking NSSM to create the Logstash service..."

Write-Host " "
Write-Host "Set the following settings on the Application tab:"
Write-Host "Path: c:\ELK-Stack\logstash\bin\logstash.bat"
Write-Host "Startup directory: c:\ELK-Stack\logstash\bin"
Write-Host "Arguments: -f c:\ELK-Stack\logstash\bin\logstash.json"

Write-Host " "
Write-Host "On the Details tab, set the following:"
Write-Host "Display name: Logstash"
Write-Host "Description: Logstash Service"
Write-Host "Startup type: Automatic"

Write-Host " "
Write-Host "On the Dependencies tab, set the following:"
Write-Host "elasticsearch-service-x64"
Write-Host " "
Invoke-Expression –command “c:\ELK-Stack\nssm\win64\nssm install Logstash”
Write-Host " "

Write-Host "Installing Logstash beats input plugin..."
Invoke-Expression –command “c:\ELK-Stack\logstash\bin\logstash-plugin install logstash-input-beats”

Pause

# Installing Kibana

# Use NSSM to create the Kibana service
Write-Host "Invoking NSSM to create the Kibana service..."

Write-Host " "
Write-Host "Set the following settings on the Application tab:"
Write-Host "Path: c:\ELK-Stack\kibana\bin\kibana.bat"
Write-Host "Startup directory: c:\ELK-Stack\kibana\bin"

Write-Host " "
Write-Host "On the Details tab, set the following:"
Write-Host "Display name: Kibana"
Write-Host "Description: Kibana Service"
Write-Host "Startup type: Automatic"

Write-Host " "
Write-Host "On the Dependencies tab, set the following:"
Write-Host "elasticsearch-service-x64"
Write-Host "Logstash"
Write-Host " "
Invoke-Expression –command “c:\ELK-Stack\nssm\win64\nssm install Kibana”
Write-Host " "

Pause

# Verify all of the services are now running
Write-Host "Verify all of the services are now running and start them if not..."
services.msc

Pause

Write-Host "Verify Kibana is now running via Chrome."
start chrome http://localhost:5601

Pause

# Installing beats
Write-Host "Installing beats..."

Write-Host "Installing filebeat..."
PowerShell.exe -ExecutionPolicy UnRestricted -File c:\ELK-Stack\filebeat\.\install-service-filebeat.ps1

Write-Host "Installing topbeat..."
PowerShell.exe -ExecutionPolicy UnRestricted -File c:\ELK-Stack\topbeat\.\install-service-topbeat.ps1

# WinPcap Required for packetbeat
Write-Host "Installing WinPcap (Required for packetbeat)..."
c:\ELK-Stack\WinPcap_4_1_3.exe

Pause

Write-Host "Installing packetbeat..."
PowerShell.exe -ExecutionPolicy UnRestricted -File c:\ELK-Stack\packetbeat\.\install-service-packetbeat.ps1
Write-Host "Installing winlogbeat..."
PowerShell.exe -ExecutionPolicy UnRestricted -File c:\ELK-Stack\winlogbeat\.\install-service-winlogbeat.ps1

# Verify all of the services are now running
Write-Host "Verify all of the services are now running and start them if not..."
services.msc

Pause


Write-Host " "
Write-Host "Now go back into Kibana under Settings > Indices and configure the following in the “Index name or pattern” field:"
Write-Host "filebeat-*"
Write-Host "packetbeat-*"
Write-Host "topbeat-*"
Write-Host "winlogbeat-*"
Write-Host " "
Write-Host "Install complete."

Pause
