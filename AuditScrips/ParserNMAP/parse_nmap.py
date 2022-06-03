#!/usr/bin/python3

###########
# IMPORTS #
###########

import sys
import getopt
import re
from libnmap.parser import NmapParser

#############
# FUNCTIONS #
#############

def error(*objects):
    print("[!]", *objects, file=sys.stderr)


def info(*objects):
    print("[+]", *objects, file=sys.stdout)


def get_first(iterable, default=None):
    if iterable:
        for item in iterable:
            return item
    return default


def parse_to_csv(files):
    try:
        lines = set()
        for xml in files:
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                for service in host.services:
                    display = service.service
                    if not display:
                        display = 'unknown'
                    if service.tunnel:
                        display = service.tunnel + "/" + display
                    if service.state == "open":
                        lines.add('%s,%s,%s,%s,%s,%s,"%s"' %
                                  (host.address,
                                   get_first(host.hostnames, ''),
                                   service.port,
                                   service.protocol,
                                   service.service,
                                   display,
                                   service.banner))
        return sorted(lines)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


def parse_service(files, regex):
    try:
        hosts = set()
        for xml in files:
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                for service in host.services:
                    display = service.service
                    if not display:
                        display = 'unknown'
                    if service.tunnel:
                        display = service.tunnel + "/" + display
                    if service.state == "open":
                        if re.search("^" + regex + "$", display, re.IGNORECASE):
                            hosts.add(host.address + ":" + str(service.port))
        return sorted(hosts)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


def parse_ports_for_address(files, address):
    try:
        ports = set()
        for xml in files:
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                if not address == host.address:
                    continue
                for service in host.services:
                    if service.state == "open":
                        ports.add(str(service.port) + "/" +
                                  str(service.protocol))
        return sorted(ports)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


def parse_unique_services(files):
    try:
        services = set()
        for xml in files:
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                for service in host.services:
                    display = service.service
                    if service.tunnel:
                        display = service.tunnel + "/" + display
                    if service.state == "open":
                        services.add(display)
        return sorted(services)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


def parse_hosts(files, check_ports=False):
    try:
        hosts = set()
        for xml in files:
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                if host.is_up():
                    if not check_ports:
                        hosts.add(host.address)
                    else:
                        if len(host.get_open_ports()) > 0:
                            hosts.add(host.address)
        return sorted(hosts)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


def parse_web_servers(files):
    try:
        servers = set()
        for xml in files:
            #print ("Got an XML")
            parsed = NmapParser.parse_fromfile(xml)
            for host in parsed.hosts:
                #print ("Found a host")
                for service in host.services:
                    if not service.state == "open":
                        continue
                    #print ("Found an open service")
                    if service.service == 'http' and service.tunnel != 'ssl':
                        if service.port == 80:
                            servers.add("http://{0}".format(host.address))
                        else:
                            servers.add("http://{0}:{1}".format(host.address, service.port))
                    elif service.service == 'https' or (service.tunnel == 'ssl' and service.service == 'http'):
                        if service.port == 443:
                            servers.add("https://{0}".format(host.address))
                        else:
                            servers.add("https://{0}:{1}".format(host.address, service.port))
        return sorted(servers)
    except Exception as e:
        error("Error parsing xml file! %s" % e)
        exit()


########
# MAIN #
########
def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('parsenmap.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('extract_web_servers.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
    #print ('Input file is ', inputfile)
    #print ('Output file is ', outputfile)
    web_servers = parse_web_servers([inputfile])
    #print (web_servers)
    for url in web_servers:
        with open((outputfile+'_urls.lst'), 'w') as file_urls:
            file_urls.write(url+'\n')
            #print (url)
    results = parse_to_csv([inputfile])
    for line in results:
        with open((outputfile+'_services.csv'), 'w') as file_results:
            file_results.write(line+'\n')
            #print (line)




    
if __name__ == "__main__":
    main(sys.argv[1:])
