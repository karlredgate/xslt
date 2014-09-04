#
# Generate a random topology
#

topology: header cluster ;

header: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" NL ;

cluster: "<cluster>" body "</cluster>" ;

body: prologue
    kits lans systems storage networks guests debug ;

# - - - - - - - - - - - - - - - - - - - -
# Prologue productions
#

prologue:
    "<name>" cluster-name "</name>"
    "<address family=\"ipv4\" prefix=\"" cluster-prefix "\">" cluster-address "</address>"
    "<netmask>"   cluster-netmask   "</netmask>"
    "<broadcast>" cluster-broadcast "</broadcast>"
    "<gateway family=\"ipv4\">" cluster-gateway "</gateway>"
;

cluster-name:      "brown.sn.stratus.com" ;
cluster-prefix:    "16" ;
cluster-address:   "10.83.60.17" ;
cluster-netmask:   "255.255.0.0" ;
cluster-broadcast: "10.83.255.255" ;
cluster-gateway:   "10.83.0.1" ;


# - - - - - - - - - - - - - - - - - - - -
# kit productions
#

kits: "" ;

lans: "" ;

systems: "" ;

storage: "" ;

networks: "" ;

guests: "" ;

debug: "" ;

NL: "\n" ;
