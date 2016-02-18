Installation
============
## <a name="overview"></a>Overview
Overall view of X-Road system and components
![](/images/xroad_overview.jpg)

#### Clients
Client can be service consumer or service provider.

Service consumer is an institution or organization that uses services provided by service providers.

Service provider is a database/information system that is providing predefined web services through
x-road infrastructure

#### Security server
Security Servers is a component of X-Road which should be installed, hosted, and managed in the service provider network. As an alternative, Security Server can be provided as a managed access service to X-Road.

* Security Servers implement a security gateways for web-services. All web-service requests and responses are digitally signed, timestamped, encrypted and archived by security servers.
* Security Servers implement organizational level access control for web-services.
* Security Servers encapsulate all of the complexity of highly available PKI-based infrastructures and provide developers with transparently secured inter-organizational web services.
* Security Servers provide meta-services for discovering the structure of the infrastructure, including organizations and services

#### Central server / X-road centre
X-Road Centre is an organization that creates and maintains an X-Road infrastructure instance and offers services to end-users

* trusted third party services: certification of security servers, management of secure directory    infrastructure,
* tamper-proof log service for security servers
* monitoring service – health monitoring of security servers, provides warnings to system administrators in case of error conditions
* e-service usage monitoring – for statistical purposes
usage monitoring for detection of suspicious activities (such as unwarranted queries to collect confidential information)

#### Certification Authority / PKI services
Certification Authority offers standard certifications services:

* Issues certificates for digital signature and for web servers
* Offers certificate validity checking service using OCSP protocol
* Offers time-stamping service using RFC 3161 protocol

## <a name="install"></a>Security Server installation
In order to join X-Road network as a service provider or/and client you need to
install, host and manage security server. Follow country specific guidelines how to proceed
with this installation.

* [Joining X-tee v6 development environment (In Estonia)](https://www.ria.ee/ee/liitumine-xtee-arendus.html)
* [Joining palveluväylä development environment (In Finland)](https://confluence.csc.fi/pages/viewpage.action?pageId=50177427)

Once you've completed the installation you can hop onto [examples](examples) to
see how to write client / provider component.

### Documents and links
* [Security Server user guide](https://confluence.csc.fi/download/attachments/47583200/x-road_v6_security_server_user_guide_2.pdf?version=1&modificationDate=1444021857473&api=v2)
* [Security server installation using ansible tool into vagrant or ec2](https://github.com/kakoni/xroad_vagrant_ansible)
