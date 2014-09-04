#
# Create topology config for a connected lan segment.
#

config : init xml ;
xml: "<config>\n"
     lan "\n"
     "<node0>" card1 port1 interface1 "</node0>\n"
     "<node1>" card2 port2 interface2 "</node1>\n"
     "</config>\n" ;

init : { bandwidth=1000 }
;

lan : "<lan id=\"" lan-uuid=uuid "\">"
       "<address>normal</address>"
       "</lan>" ;

card-vendor : "Broadcom Corporation" | "Intel Corporation" | "Stratus Avance" ;
card-model : "Foo Gigabit Ethernet" ;

slotno : "1" | "2" | "3" | "4" | "5" | "6" | "7" ;

card1 : "<card id=\"" card1-uuid=uuid "\">"
       "<status>normal</status>"
       "<vendor>" card-vendor "</vendor>"
       "<model>" card-model "</model>"
       "</card>\n" ;

pick-slot : portSlotno=slotno
	{ port-portno="0" }
	{ port-device = "eth_s" + portSlotno + "_" + port-portno }
;

port1 : "<port id=\"" port1-uuid=uuid "\">"
        "<status>normal</status>"
        "<kind>network</kind>"
        "<mtu>1500</mtu>"
	"<slotno>" pick-slot "</slotno>"
	"<portno>" $port-portno "</portno>"
	"<device>" $port-device "</device>"
        "<bandwidth duplex=\"full\" unit=\"Mb/s\">" $bandwidth "</bandwidth>"
        "<card ref=\"" $card1-uuid "\"/>"
	"</port>\n"
;

interface1 : "<interface id=\"" interface1-uuid=uuid "\">"
        "<name>" $port-device "</name>"
        "<access>business</access>"
        "<bandwidth duplex=\"full\" unit=\"Mb/s\">" $bandwidth "</bandwidth>"
        "<connectivity>good</connectivity>"
        "<device ref=\"" $port1-uuid "\"/>"
        "<lan ref=\"" $lan-uuid "\"/>"
	"</interface>\n"
;

card2 : "<card id=\"" card2-uuid=uuid "\">"
       "<status>normal</status>"
       "<vendor>" card-vendor "</vendor>"
       "<model>" card-model "</model>"
       "</card>\n" ;

port2 : "<port id=\"" port2-uuid=uuid "\">"
        "<status>normal</status>"
        "<kind>network</kind>"
        "<mtu>1500</mtu>"
	"<slotno>" $portSlotno "</slotno>"
	"<portno>" $port-portno "</portno>"
	"<device>" $port-device "</device>"
        "<bandwidth duplex=\"full\" unit=\"Mb/s\">" $bandwidth "</bandwidth>"
        "<card ref=\"" $card2-uuid "\"/>"
	"</port>\n"
;

interface2 : "<interface id=\"" interface2-uuid=uuid "\">"
        "<name>" $port-device "</name>"
        "<access>business</access>"
        "<bandwidth duplex=\"full\" unit=\"Mb/s\">" $bandwidth "</bandwidth>"
        "<connectivity>good</connectivity>"
        "<device ref=\"" $port2-uuid "\"/>"
        "<lan ref=\"" $lan-uuid "\"/>"
	"</interface>\n"
;


uuid: random-uuid32 "-" random-uuid16 "-4" random-uuid12 "-" ["8"|"9"|"a"|"b"] random-uuid12 "-" random-uuid48 ;

random-uuid48: random-uuid32 random-uuid16 ;
random-uuid32: random-uuid16 random-uuid16 ;
random-uuid16: random-uuid12 random-uuid4 ;
random-uuid12: random-uuid4 random-uuid4 random-uuid4 ;

random-uuid4: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" |
              "a" | "b" | "c" | "d" | "e" | "f" ;
