# fqdn-aws-vagrant
This repository is an exercise to learn how to generate a valid certificate using [Let's Encrypt](https://letsencrypt.org/) and configure Nginx

## Instructions

### Prerequisites

- [X]  [Vagrant](https://www.vagrantup.com/docs/installation)
- [X]  [VirtualBox](https://www.virtualbox.org/)
- [X]  [AWS Account](https://aws.amazon.com/resources/create-account/)

## How to Use this Repo

- Clone this repository:
```shell
git clone git@github.com:dlavric/fqdn-aws-vagrant.git
```

- Go to the directory where the repo is stored
```shell
cd fqdn-aws-vagrant
```

- Create the VM with Vagrant
```shell
vagrant up
```


- Define a FQDN for yourself in your AWS Account UI with Route53 Dashboard and point the DNS to the IP of your VM
![Route53-1](https://github.com/dlavric/fqdn-aws-vagrant/blob/main/pictures/Screenshot1.png)

- Check that your FQDN is valid
```shell
dig nginxdani.bg.hashicorp-success.com

; <<>> DiG 9.10.6 <<>> nginxdani.bg.hashicorp-success.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13246
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;nginxdani.bg.hashicorp-success.com. IN A

;; ANSWER SECTION:
nginxdani.bg.hashicorp-success.com. 300 IN A    192.168.57.151

;; Query time: 89 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Mon Jan 16 16:31:54 CET 2023
;; MSG SIZE  rcvd: 79
```

- Create the valid certificate for the VM by installation `certbot`

```shell
certbot -d nginxdani.bg.hashicorp-success.com --manual --preferred-challenges dns certonly

Plugins selected: Authenticator manual, Installer None
Enter email address (used for urgent renewal and security notices) (Enter 'c' to
cancel): email@hostname.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must
agree in order to register with the ACME server at
https://acme-v02.api.letsencrypt.org/directory
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(A)gree/(C)ancel: A

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing to share your email address with the Electronic Frontier
Foundation, a founding partner of the Let's Encrypt project and the non-profit
organization that develops Certbot? We'd like to send you email about our work
encrypting the web, EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: N
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for nginxdani.bg.hashicorp-success.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.nginxdani.bg.hashicorp-success.com with the following value:

xKtNWhCliuxBjgy2tlpGDETRqh074VxSYIJUPr1EXuU

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

- Now create a TXT file in your Route53 Dashboard on AWS as follows
![Route53-2](https://github.com/dlavric/fqdn-aws-vagrant/blob/main/pictures/Screenshot2.png)

- To double check the new record is working for the DNS
```shell
dig TXT _acme-challenge.nginxdani.bg.hashicorp-success.com 

; <<>> DiG 9.10.6 <<>> TXT _acme-challenge.nginxdani.bg.hashicorp-success.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 17664
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;_acme-challenge.nginxdani.bg.hashicorp-success.com. IN TXT

;; ANSWER SECTION:
_acme-challenge.nginxdani.bg.hashicorp-success.com. 300 IN TXT "xKtNWhCliuxBjgy2tlpGDETRqh074VxSYIJUPr1EXuU"

;; Query time: 96 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Mon Jan 16 11:52:19 CET 2023
;; MSG SIZE  rcvd: 135
```

- Resume the process of creating the certificates with Certbot manually
```shell
Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/nginxdani.bg.hashicorp-success.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/nginxdani.bg.hashicorp-success.com/privkey.pem
   Your cert will expire on 2023-04-16. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

- Create a backup of these certificates on your local directory `/vagrant`
```shell
cp -apL /etc/letsencrypt/live/nginxdani.bg.hashicorp-success.com/fullchain.pem /vagrant

cp -apL /etc/letsencrypt/live/nginxdani.bg.hashicorp-success.com/privkey.pem /vagrant
```

- Install NGINX
```shell
apt-get install -y nginx
```

- Configure NGINX at the following path
```shell
vi /etc/nginx/sites-enabled/default 
```

- The file `/etc/nginx/sites-enabled/default` should have this content in the Default server configuration
![Nginx-1](https://github.com/dlavric/fqdn-aws-vagrant/blob/main/pictures/Screenshot4.png)

- Restart the NGINX service
```shell
service nginx restart
```

- Test the Webserver and the security of the certificate
![Nginx-2](https://github.com/dlavric/fqdn-aws-vagrant/blob/main/pictures/Screenshot3.png)

