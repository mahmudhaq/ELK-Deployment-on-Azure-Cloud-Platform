# ELK-Deployment-on-Azure-Cloud-Platform

# Objective
The project envolves deploying ELK stack on Azure Platform leveraging the Docker Container. The objective of this deployment to demostrate the secure deployment of any workload including the ELK on the Azure Cloud Platform.

# Target Audience
- Solution Architect
- Technical Sales
- Technical Professional Service Engineers
- Operation Engineers
- Cloud Security Professionals
- CISO

# Project Resources
- The ELK Deployment on Azure Cloud.jpg in Network Diagram folder contains the arcitecure diagram of the deployment.
- In the Linux folder, an automation tool named User_administration which automates the  adding and deleting users.
- The Ansible folder contains all the necessary configuration files to configure the ELK deployment utilizing the Docker containers including the Ansible, ELK, filebeat and metricbeat containers. 

# Network Arcitecture overview:

- The ELK stack has been deployed on the Azure Cloud Platform. The network has been divided in two major sub networks:
  1. Web VMs (Web-01, Web-02, Web-03) have been deployed in a seperate VNET then ELK Stack.
  2. The Jump-Box allows the administrator to allow the access to the platform through only SSH.

## Network Elements
  
  1. Resocurce Group: The Resource group named USYD-Project-01 is the top most glue to build the network. 
  
  2. Regions: For the security and availibity reasons, the network has been built in two seperate regions in Australia:
      Australia East: 
            a. USYD-Project-01-NSG01
            b. USYD-Project-01-LB01
            c. Jump-Box VM
            d. Web VMs
  
      Australia Central:
            a. USYD-ELK-01-ELKNSG-01
            b. ELK VM
            
  3. Network Security Groups:
      a. USYD-Project-01-NSG01: The USYD-Project-01-NSG01 is a subnet level FW which only allows the SSH traffic to Jump-Box VM and HTTP traffic to the Load Balancer (USYD-       Project-01-LB01.
      b. USYD-ELK-01-ELKNSG-01: The USYD-ELK-01-ELKNSG-01 is also a subnet level FW which only allows the HTTP traffic to the ELK Stack. All the other ports are disabled.
      
 4. Load Balancer: 
      a. USYD-Project-01-LB01: The Load Balancer will distribute the HTTP traffic among the Web VMs for the DVWA.
      
 5. Virtual Machines:
      
      a. Jump-Box VM: The Jump-Box VM is to allow the administrator from outside to do necessary installation and configuration to all the VMs including ELK and Web VMs. The Ansible container has also configured on the Jump-Box VM to configure the other containers on the Web VMs and ELK VM. The configuration of the Jump-Box is:
              OS: Ubuntu 18.04.5 LTS
              IP Address: Private: 10.0.0.8/24. Public: 52.189.210.169
              Allowed Ports: SSH (22)
      b. Web VMs: The Web VMs pool has 3 VMs (Web-01, Web-02, Web-03) in a Availibility Set behind the Load Balancer (USYD-Project-01-LB01). The DVWA container is being installed on all the VMs. The HTTP traffic from LB is only allowed to these VMs and the internal SSH traffic that come from Jump-Box. The other traffic have been blocked. The filebeat and metricbeat have also been installed and configured to Web VMs through Ansible to collect logs for the ELK stack. The Web VMs represent the production workload of any organisation.
   
              Name: Web-01
              OS: Ubuntu 18.04.5 LTS
              IP Address: Private: 10.0.0.12/24
              Allowed Ports: SSH (22), HTTP (80)
              
              Name: Web-02
              OS: Ubuntu 18.04.5 LTS
              IP Address: Private: 10.0.0.10/24
              Allowed Ports: SSH (22), HTTP (80)
                          
              Name: Web-03
              OS: Ubuntu 18.04.5 LTS
              IP Address: Private: 10.0.0.11/24
              Allowed Ports: SSH (22), HTTP (80)
              
    c. ELK VM: The ELK VM deploys the ELK container. The ELK VM has been deployed in a seperate VNET coupled with the a second NSG (USYD-ELK-01-ELKNSG-01) to isolate the ELK traffic from actual production environment.
 
              Name: ELK
              OS: Ubuntu 18.04.5 LTS
              IP Address: Private: 10.2.0.4/24, Public: 53.74.09.24
              Allowed Ports: SSH (22), HTTP (80)
 
 6. Containers: The below 4 containers are deployed:
                 Ansible- Jump-Box VM
                 DVWA- Web-01, Web-02, Web-03
                 ELK- ELK
 
 7. Network and Subnet Address details:
    Virtual Network (VNET):
    - 10.0.0.0/16: Web VMs and Jump-Box
      Subnet: 10.0.0.0/24
    - 10.2.0.0/16: ELK VMs
      Subnet: 10.2.0.0/24

## Security and Hardening:

- The VMs are patched with latest updates.
- For Web VMs, rules being created to allow the LB as te source for the HTTP traffic and Jump-Box Private IP for the SSH traffic. All the other ports have been disabled.
- For the ELK VM, SSH traffic has been allowed from the Jump-Box and HTTP traffic from only the indivudal IP address from the user workstation. And other prots are disabled.
- Using two different NSGs will ensure the seperation of the actual WEb traffic and ELK traffic.
- All the containers are deployed through Ansible Container to ensure minimal access requirement to the actual VMs.

  
    
