# ELKWindows
Installing Elasticsearch, Logstash and Kibana (ELK) on Windows Server 2012 R2

Elasticsearch, Logstash and Kibana (ELK) is the combination of 3 separate pieces of software from the same vendor, Elastic. The basic idea is that we will use Logstash to collect/parse/enrich our logs to be searched/analyzed using Elasticsearch. All of this information is easily accessed and visualized via Kibana which serves as the web based front end.

In my case I was looking for a free alternative to Splunk, which is fantastic but has some frustrating licensing limitations. I found that with around 10 lab VMs forwarding logs to the Splunk instance that I quickly went over the trial limit. Once the license limit is met for the day, it shuts off and can’t be used. Fed up with these limitations, I started looking into the ELK stack and I can honestly say I was not disappointed. The installation is a little bit trickier than Splunks but can easily be scripted once you are familiar with the packages and how they are installed.

So in this post I will demonstrating how to setup a basic ELK stack and start gathering logs from the Windows VM that ELK is running on. It is important to note that you do not want to expose this server to the internet for a few reasons but the most important being that there is no authentication on Kibanas interface.

My lab setup

For this lab I’ll be using a Windows 2012 R2 VM with 4 vCPUs, 4 Gb RAM and 50 Gb of HD space. The OS is just a base install of Server 2012 R2 Standard with all the latest updates and the Windows Firewall has been turned off.

You don’t need a huge server for this deployment but these applications can be a bit memory hungry and the faster the disk you can put this on the better. CPU usage varies but tends to be on the lighter side, you will see some spikes as new clients are brought on and mass logs are indexed on the way in.

I will be using the following software versions in this lab:
Elasticsearch 2.3.2
Logstash 2.3.2
Kibana 4.5.0
Filebeat 1.2.2
Packetbeat 1.2.2
Topbeat 1.2.2
Winlogbeat 1.2.2
NSSM 2.24
Java JDK 8u92 x64
WinPcap 4.1.3

Installs Needed on the ELK Server:

Elasticsearch (https://www.elastic.co/downloads)
Logstash (https://www.elastic.co/downloads)
Kibana (https://www.elastic.co/downloads)
The Non-Sucking Service Manager (NSSM) (https://nssm.cc)
Java (https://www.java.com/)
WinPcap (https://www.winpcap.org/)
Log Shippers/Agents for clients:

Filebeat (https://www.elastic.co/downloads)
Packetbeat (https://www.elastic.co/downloads)
Topbeat (https://www.elastic.co/downloads)
Winlogbeat (https://www.elastic.co/downloads)
