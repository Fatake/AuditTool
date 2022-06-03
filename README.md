# Audit Tool

## Function

Audit Tool are mainly bash scripts to automate repetitive tasks dunring a pentest.You could be able to make:

- Burp project
- A DNS analysis with tools like **dnsrecon**, **dig**, **subfinder**, **assetfinder** and **amass**
- A Nessus scan
- Transofrm hosts into IPv4 or IPv6 addresses
- Test security headers
- Scan ports and services with **Nmap**
- Take screenshots from a list of URLs with **GoWitness**

## Usage

All you need to do is:

```bash
sudo ./AuditTools.sh -i
```

For the first time, the script will create a directory called **pentest**, inside ther whill create other directory called **targets** where you will tipe all targets that yu need to audit:

- domains.txt
- ipaddresses.txt
- subdomains.txt
- urls.txt

And run the script with:

```bash
./AuditTool.sh -n [NameProject]
```
