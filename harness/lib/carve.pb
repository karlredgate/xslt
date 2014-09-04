
/*
 * Grammar for generating a region carve request.
 *
 * Input includes a grammar for the list of storage devices on
 * this DUT.
 *
 * Output is a shell script that uses "curl" to send the carve request
 * to the DUT.  This shell script in watches for the region to become
 * available and then creates a grammar for the volumes that is included
 * in another grammar for creating the domain.
 */

test :
    "#!/bin/bash\n"
    "# DUT : " DUT "\n"
    "RESPONSE=/tmp/resp$$\n"
    create-storage
    wait-for-storage-ready
    "( echo 'boot-volume-uuid: \"'$volume'\" ;'\n"
    ") > volumes.pb\n"
;

#include "storage.pb"

create-storage :
    create-boot-region
;
create-boot-region :
    "# boot mirror is " boot-mirror=pick-mirror "\n"
    "curl --silent --request PUT --data \"" boot-region-xml "\" http://" DUT ":8999/storage/id/" $boot-mirror "/ --output $RESPONSE || {\n"
    "   echo failed to create domain\n"
    "   exit 1\n"
    "}\n"
    "volume=$(xsltproc volume_uuid.xslt $RESPONSE)\n"
    "rm -f $RESPONSE\n"
;
wait-for-storage-ready :
    "# Wait for storage to be ready\n"
    "state=$(curl --silent http://" DUT ":8999/storage/id/$volume/ | xsltproc carve_ready.xslt -)\n"
    "until [ $state = ready ]\n"
    "do\n"
    "    echo $volume not ready /$state/\n"
    "    state=$(curl --silent http://" DUT ":8999/storage/id/$volume/ | xsltproc carve_ready.xslt -)\n"
    "    sleep 2\n"
    "done\n"
;
pick-mirror : small-carvable ;

boot-region-xml : element("region" boot-region-config) ;
boot-region-config :
    element("name" boot-volume-name)
    ref("storage" $boot-mirror "")
    element("capacity" "4000")
;
boot-volume-name: DOMAIN_NAME "_vol0" ;

element(tag value) : "<" tag ">" value "</" tag ">" ; 
ref(tag id attributes) : "<" tag " ref='" id  "' " attributes "/>" ; 


DUT : "simpsons" ;

/*
 * vim:autoindent
 * vim:expandtab
 */
