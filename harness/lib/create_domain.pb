/*
 * Grammar for generating a domain creation test.
 */

test :
    "#!/bin/bash\n"
    "# domain : " domain=domain " ("  uuid=@uuid($domain)  ")\n"
    "HARNESS=$HOME/lib/harness\n"
    "RESPONSE=/tmp/resp$$\n"
    create-domain
    "xsltproc domain_uuid.xslt $RESPONSE > domain_uuid.pb\n"
    "rm -f $RESPONSE\n"
;

#include "volumes.pb"

create-domain :
    "# create domain\n"
    "code=$(curl --silent --output $RESPONSE --write-out '%{http_code}' --request PUT --data \"" domain-xml "\" http://" DUT ":8999/domains/)\n"
    "case $code in\n"
    "201) echo Domain created ;;\n"
    "409) echo Resource conflict \n"
    "     exit 1 ;;\n"
    "500) echo '       Spine bug during create command' \n"
    "     xsltproc $HARNESS/stack.xslt $RESPONSE\n"
    "     exit 1 ;;\n"
    "*) echo Error $code creating domain... \n"
    "     exit 1 ;;\n"
    "esac\n"
;

domain-xml : element("domain" domain-config) ;
domain-config :
    element("name" DOMAIN_NAME)
    element("memory" memory) element("vcpus" vcpus)
    element("storage" storage)
;

memory : "256" ;
vcpus : "1" ;

storage : boot-volume data-volumes ;
boot-volume : volume(boot-volume-uuid "boot='true'") ;
data-volumes : "" ;
volume(id attributes) : ref("volume" id attributes) ;

uuid(domain) : "uuid-" domain ;

element(tag value) : "<" tag ">" value "</" tag ">" ; 
ref(tag id attributes) : "<" tag " ref='" id  "' " attributes "/>" ; 

/*
 * vim:autoindent
 * vim:expandtab
 */
