
/*
 * Grammar for generating a domain load test.
 *
 * Should allow pick of a yum template, kickstart template, or an interactive
 * template.  The interactive template will need an expect script to automate
 * the load.
 */

test :
    "#!/bin/bash\n"
    "# DUT      : " DUT "\n"
    "# domain   : " domain=DOMAIN_NAME "\n"
    "# template : " template-uuid=TEMPLATE_UUID "\n"
    "RESPONSE=/tmp/resp$$\n"
    "HARNESS=$HOME/lib/harness\n"
    load-domain
    wait-for-domain-ready
;

load-domain :
    "# load domain\n"
    "code=$(curl --silent --output $RESPONSE --write-out '%{http_code}' " request " " domain-uri ")\n"
    "case $code in\n"
    "200) echo Domain load accepted ;;\n"
    "409) echo Resource conflict for load command \n"
    "     exit 1 ;;\n"
    "500) echo Spine bug during load command \n"
    "     xsltproc $HARNESS/stack.xslt $RESPONSE\n"
    "     exit 1 ;;\n"
    "*) echo Error $code loading domain... \n"
    "     exit 1 ;;\n"
    "esac\n"
    "rm -f $RESPONSE\n"
;
wait-for-domain-ready :
    "# Wait for domain to be loaded -- look for template/running\n"
;

domain-uri : "http://" DUT ":8999/domains/name/" $domain "/" ;
request : "--data \"" load-xml "\"" ;
load-xml : element("load" template) ;
template : ref("template" $template-uuid "") ;

element(tag value) : "<" tag ">" value "</" tag ">" ; 
ref(tag id attributes) : "<" tag " ref='" id  "' " attributes "/>" ; 

/*
 * vim:autoindent
 * vim:expandtab
 */
