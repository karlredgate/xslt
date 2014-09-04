
/*
 * \todo track times in a log file
 */

test :
    "#!/bin/bash\n"
    "# domain : " domain=steady-domains " ("  uuid=@uuid($domain)  ")\n"
    "# state  : " state=@$domain "\n"
    "# command: " command=@$state "\n"
    "# expect : " transition=@$command "/" target=@$transition "\n"
    check-for-steady-domains
    "RESPONSE=/tmp/resp$$\n"
    "echo -n '  ' Tell " $domain " to " $command "\n"
    "start=$(date +%s.%N)\n"
    "code=$(curl --silent --output $RESPONSE --write-out '%{http_code}' " @request($command) " --data \"" data "\" http://" DUT ":8998/domains/id/" $uuid "/) \n"
    "case $code in\n"
    "200) echo ' [Domain' " $command " 'accepted]' ;;\n"
    "400) echo ' === ' Bad request for " $command " command ;;\n"
    "409) echo ' === ' Resource conflict for " $command " command ;;\n"
    "413) echo ' === ' RequestEntityTooLarge for " $command " command \n"
    "     xsltproc $HARNESS/stack.xslt $RESPONSE\n"
    "     ;;\n"
    "500) echo ' === ' Spine bug during " $command " command \n"
    "     xsltproc $HARNESS/stack.xslt $RESPONSE\n"
    "     ;;\n"
    "*) echo ' === ' Error $code for " $command " command ... \n"
    "     ;;\n"
    "esac\n"
    "now=$(date +%s.%N)\n"
    "delta=$(dc -e \"$now $start - f\")\n"
    "echo " $command " $delta >> /tmp/spine_times.log\n"
    "echo Request took $delta seconds\n"
    "transition=$(xsltproc $HARNESS/result.xslt $RESPONSE)\n"
    "rm -f $RESPONSE\n"
    "echo Expect transition from " $state " to " $transition "\n"
    "[ \"$transition\" == " $transition " ] || {\n"
    "    echo failed to transition\n"
    "    exit 1\n"
    "}\n"
;

uuid(domain) : "uuid-" domain ;

#include "domains.pb"
#include "nodes.pb"

check-for-steady-domains:
#if STEADY==0
    "echo No domains to transition\n"
    "sleep 5\n"
    "create_domain " DUT "\n"
    "exit 1\n"
#else
    "echo " {=STEADY} " domains in a steady state\n"
#endif
;

/*
 * if this is a move command use --request MOVE --header "Location:..."
 * for most else just use a post
 */
request(command) : command "-request" ;
data : "<" $command "/>" ;

// Allowed state transitions
stopped: "boot" ;
running: "pause" | "move" | "shutdown" | "move" |
         "stop"  | "move" | "poweroff" | "move" ;
paused : "poweroff" | "resume" ;

// Disallowed state transitions
no-stopped: "pause" ;
no-running: "resume" ;
no-paused : "shutdown" ;

// Transitional states
boot     : "starting" ;
start    : "starting" ;
move     : "moving" ;
stop     : "stopping" ;
shutdown : "stopping" ;
pause    : "pausing" ;
resume   : "resuming" ;
poweroff : "stopping" ;

// Target states
starting : "running" ;
moving   : "running" ;
stopping : "stopped" ;
pausing  : "paused" ;
resuming : "running" ;

// requests
boot-request: "" ;
start-request: "" ;
stop-request: "" ;
shutdown-request: "" ;
pause-request: "" ;
resume-request: "" ;
poweroff-request: "" ;
move-request: "--request MOVE " destination ;

domain-primary: "primary-" $domain ;
primary: @domain-primary ;
destination: " --header 'Destination: http://" DUT ":8999/nodes/name/" primary>peer "/' " ;

/*
 * vim:autoindent
 * vim:expandtab
 */
