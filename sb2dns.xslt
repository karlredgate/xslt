<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://redgates.com/xslt/DNS'
                xmlns:IPv6='http://redgates.com/xslt/IPv6'
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <xsl:import href="utils.xslt"/>
  <xsl:import href="ipv6.xslt"/>
  <xsl:import href="dns.xslt"/>
  <xsl:output method="text"/>

  <dc:title>Generate DNS zone data from Storbitz host description</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Storbitz contains a set of xml descriptions of hosts in the Avance test environment.
Each description can be passed through this transformation and a set of DNS resource
records in the zone file format are sent to standard output.
  </dc:description>

  <xsl:template match='text()' />

<!-- ======================================================== -->
  <dc:description>
Add a CNAME record that points from a domain of console.DUT to the name of
the serial concentrator for this DUT.  We also need a SRV record for the
port number.
  </dc:description>
  <xsl:template match='serial'>
      <xsl:variable name='hostname' select='../interfaces/interface/dns/name' />

      <xsl:call-template name='DNS:CNAME'>
        <xsl:with-param name='hostname' select='concat("console.",$hostname)' />
        <xsl:with-param name='canonical' select='host' />
      </xsl:call-template>

      <xsl:call-template name='DNS:TXT'>
        <xsl:with-param name='hostname' select='concat("serial.",$hostname)' />
        <xsl:with-param name='text'>
          <xsl:choose>
            <xsl:when test='type'><xsl:value-of select='type' /></xsl:when>
            <xsl:otherwise>digi</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name='DNS:SRV'>
        <xsl:with-param name='service'>console</xsl:with-param>
        <xsl:with-param name='protocol'>tcp</xsl:with-param>
        <xsl:with-param name='hostname' select='$hostname' />

        <xsl:with-param name='port'>
          <xsl:choose>
            <xsl:when test='type = "IMS"'>
              <xsl:value-of select='2200 + port' />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='2000 + port' />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>

        <xsl:with-param name='target' select='host' />
      </xsl:call-template>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
Add a CNAME record that points from a domain of power.DUT to the name of
the power controller for this DUT.
  </dc:description>
  <xsl:template match='power'>
      <xsl:variable name='hostname' select='../interfaces/interface/dns/name' />

      <xsl:call-template name='DNS:CNAME'>
        <xsl:with-param name='hostname' select='concat("power.",$hostname)' />
        <xsl:with-param name='canonical' select='host' />
      </xsl:call-template>

      <xsl:for-each select='outlets/outlet'>
          <xsl:call-template name='DNS:SRV'>
            <xsl:with-param name='service'>power</xsl:with-param>
            <xsl:with-param name='protocol'>tcp</xsl:with-param>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='port' select='.' />
            <xsl:with-param name='target' select='../../host' />
          </xsl:call-template>
      </xsl:for-each>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
Add a CNAME record that points from a domain of power.DUT to the name of
the power controller for this DUT.
  </dc:description>
  <xsl:template match='diskInformation'>
      <xsl:variable name='hostname'>
          <xsl:text>disk.</xsl:text>
          <xsl:value-of select='../interfaces/interface/dns/name' />
      </xsl:variable>

      <xsl:call-template name='DNS:CNAME'>
        <xsl:with-param name='hostname' select='concat("power.",$hostname)' />
        <xsl:with-param name='canonical' select='host' />
      </xsl:call-template>

      <xsl:for-each select='outlets/outlet'>
          <xsl:call-template name='DNS:SRV'>
            <xsl:with-param name='service'>power</xsl:with-param>
            <xsl:with-param name='protocol'>tcp</xsl:with-param>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='port' select='number' />
            <xsl:with-param name='target' select='../../host' />
          </xsl:call-template>
      </xsl:for-each>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
If the nodes in this xml file have class "testhost" then they are all testhost
and we do not use the special node[1] template.
  </dc:description>
  <xsl:template match='nodes/node'>
      <xsl:variable name='hostname' select='interfaces/interface/dns/name' />
      <xsl:variable name='ip' select='interfaces/interface/ip' />
      <xsl:variable name='mac' select='interfaces/interface/mac' />

      <xsl:choose>
      <xsl:when test='/storbitz/classes/class = "testhost"'>
          <xsl:message>Adding testhost <xsl:value-of select="$hostname" /></xsl:message>
          <xsl:call-template name='DNS:SRV'>
            <xsl:with-param name='service'>slreportd</xsl:with-param>
            <xsl:with-param name='protocol'>udp</xsl:with-param>
            <xsl:with-param name='hostname'>sn.redgates.com.</xsl:with-param>
            <xsl:with-param name='priority'>1</xsl:with-param>
            <xsl:with-param name='weight'>1</xsl:with-param>
            <xsl:with-param name='port'>33044</xsl:with-param>
            <xsl:with-param name='target' select='interfaces/interface/dns/name' />
          </xsl:call-template>

          <xsl:call-template name='DNS:HINFO'>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='platform'>UNKNOWN</xsl:with-param>
            <xsl:with-param name='os'>Avance</xsl:with-param>
          </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
      </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates />

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
The first interface node found in the document is treated specially, since
it tells us which kind of node the host is.  This format does not work with
the build server xml.
  </dc:description>
  <xsl:template match='nodes/node[1]/interfaces/interface'>
      <xsl:variable name='hostname' select='dns/name' />
      <xsl:variable name='ip' select='ip' />
      <xsl:variable name='mac' select='mac' />

      <xsl:choose>
      <xsl:when test='/storbitz/class = "CLIENT"'>
          <xsl:message>Adding CLIENT <xsl:value-of select="$hostname" /></xsl:message>

          <xsl:call-template name='DNS:SRV'>
            <xsl:with-param name='service'>client</xsl:with-param>
            <xsl:with-param name='protocol'>tcp</xsl:with-param>
            <xsl:with-param name='hostname'>sn.redgates.com.</xsl:with-param>
            <xsl:with-param name='priority'>1</xsl:with-param>
            <xsl:with-param name='weight'>1</xsl:with-param>
            <xsl:with-param name='port'>80</xsl:with-param>
            <xsl:with-param name='target' select='dns/name' />
          </xsl:call-template>

          <xsl:call-template name='DNS:HINFO'>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='platform'>UNKNOWN</xsl:with-param>
            <xsl:with-param name='os'>Linux</xsl:with-param>
          </xsl:call-template>

      </xsl:when>

      <xsl:when test='/storbitz/class = "CLUSTERDUT"'>
          <xsl:message>Adding DUT <xsl:value-of select="$hostname" /></xsl:message>
          <xsl:call-template name='DNS:SRV'>
            <xsl:with-param name='service'>doh</xsl:with-param>
            <xsl:with-param name='protocol'>tcp</xsl:with-param>
            <xsl:with-param name='hostname'>sn.redgates.com.</xsl:with-param>
            <xsl:with-param name='priority'>1</xsl:with-param>
            <xsl:with-param name='weight'>1</xsl:with-param>
            <xsl:with-param name='port'>80</xsl:with-param>
            <xsl:with-param name='target' select='dns/name' />
          </xsl:call-template>

          <xsl:call-template name='DNS:HINFO'>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='platform'>UNKNOWN</xsl:with-param>
            <xsl:with-param name='os'>Avance</xsl:with-param>
          </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
      </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
      <xsl:when test='ipv6'>
        <xsl:call-template name='DNS:AAAA'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='address' select='ipv6' />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test='/storbitz/class = "CLUSTERDUT"'>
      </xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='DNS:AAAA'>
            <xsl:with-param name='hostname' select='$hostname' />
            <xsl:with-param name='address'>
               <xsl:call-template name='global-ipv6'>
                  <xsl:with-param name='v4addr' select='ip' />
                  <xsl:with-param name='mac' select='mac' />
               </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name='DNS:A'>
        <xsl:with-param name='hostname' select='$hostname' />
        <xsl:with-param name='address' select='ip' />
      </xsl:call-template>

      <!-- These SHOULD be CNAME records, but since we have set up our "virtual hosts"
           such that they REQUIRE the aliases to be direct addresses, they MUST be
           A records and AAAA records (grumble) -->
      <xsl:for-each select='dns/alias'>
        <xsl:if test='$hostname != .'>
          <xsl:call-template name='DNS:A'>
            <xsl:with-param name='hostname' select='.' />
            <xsl:with-param name='address' select='$ip' />
          </xsl:call-template>

          <xsl:choose>
          <xsl:when test='../../ipv6'>
            <xsl:call-template name='DNS:AAAA'>
              <xsl:with-param name='hostname' select='.' />
              <xsl:with-param name='address' select='../../ipv6' />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
              <xsl:call-template name='DNS:AAAA'>
                <xsl:with-param name='hostname' select='.' />
                <xsl:with-param name='address'>
                   <xsl:call-template name='global-ipv6'>
                      <xsl:with-param name='v4addr' select='$ip' />
                      <xsl:with-param name='mac' select='../../mac' />
                   </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
          </xsl:otherwise>
          </xsl:choose>

        </xsl:if>
      </xsl:for-each>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
Each interface node is translated to a set of resource records.  The A
and AAAA records for its address, and HINFO record to tell us
about the machine itself.
We only add the AAAA records that are based on EUI64 addresses if there
is a <quote>mac</quote> element present.
  </dc:description>
  <!-- need to handle case when there is no IPv4 address -->
  <xsl:template match='interface'>
      <xsl:variable name='hostname' select='dns/name' />

      <xsl:if test='mac'>

        <xsl:call-template name='DNS:AAAA'>
          <xsl:with-param name='hostname'>
             <xsl:text>link.</xsl:text>
             <xsl:value-of select='$hostname' />
          </xsl:with-param>
          <xsl:with-param name='address'>
             <xsl:call-template name='IPv6:lladdr'>
                <xsl:with-param name='mac' select='mac' />
             </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name='DNS:AAAA'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='address'>
             <xsl:call-template name='global-ipv6'>
                <xsl:with-param name='v4addr' select='ip' />
                <xsl:with-param name='mac' select='mac' />
             </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname' select='mac' />
            <xsl:with-param name='canonical' select='$hostname' />
        </xsl:call-template>

        <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname'>
               <xsl:text>mac.</xsl:text>
               <xsl:value-of select='$hostname' />
            </xsl:with-param>
            <xsl:with-param name='canonical' select='mac' />
        </xsl:call-template>

      </xsl:if>

      <xsl:choose>
      <xsl:when test='../../pxeboot/mac'>
        <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname'>
               <xsl:text>pxemac.</xsl:text>
               <xsl:value-of select='$hostname' />
            </xsl:with-param>
            <xsl:with-param name='canonical' select='../../pxeboot/mac' />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test='mac'>
        <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname'>
               <xsl:text>pxemac.</xsl:text>
               <xsl:value-of select='$hostname' />
            </xsl:with-param>
            <xsl:with-param name='canonical' select='mac' />
        </xsl:call-template>
      </xsl:when>
      </xsl:choose>

      <xsl:call-template name='DNS:TXT'>
        <xsl:with-param name='hostname' select='concat("bootloader.",$hostname)' />
        <xsl:with-param name='text'>
          <xsl:choose>
            <xsl:when test='../../pxe/bootloader'><xsl:value-of select='../../pxe/bootloader' /></xsl:when>
            <xsl:otherwise>gPXE</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:if test='../../pxeboot/mac'>
        <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname' select='../../pxeboot/mac' />
            <xsl:with-param name='canonical' select='$hostname' />
        </xsl:call-template>
      </xsl:if>

      <xsl:if test='ipv6'>
        <xsl:call-template name='DNS:AAAA'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='address' select='ipv6' />
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name='DNS:A'>
        <xsl:with-param name='hostname' select='$hostname' />
        <xsl:with-param name='address' select='ip' />
      </xsl:call-template>

      <xsl:call-template name='DNS:HINFO'>
        <xsl:with-param name='hostname' select='$hostname' />
        <xsl:with-param name='platform'>UNKNOWN</xsl:with-param>
        <xsl:with-param name='os'>Avance</xsl:with-param>
      </xsl:call-template>

      <xsl:for-each select='dns/alias'>
        <xsl:if test='$hostname != .'>
          <xsl:call-template name='DNS:CNAME'>
            <xsl:with-param name='hostname' select='.' />
            <xsl:with-param name='canonical' select='$hostname' />
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='vms/expand[1]/interfaces/interface'>
      <xsl:variable name='hostname' select='../interface/dns/name' />
      <xsl:variable name='mac' select='mac' />
      <xsl:variable name='baseMAC' select='substring($mac,1,15)' />
      <xsl:variable name='startMACnybble' select='substring($mac,16,1)' />
      <xsl:variable name='baseIP' select='ip' />
      <xsl:variable name='octet1' select='substring-before($baseIP,".")' />
      <xsl:variable name='octet2' select='substring-before(substring-after($baseIP,"."),".")' />
      <xsl:variable name='octet3' select='substring-before(substring-after(substring-after($baseIP,"."),"."),".")' />
      <xsl:variable name='lastOctet' select='number(substring-after(substring-after(substring-after($baseIP,"."),"."),"."))' />
      <xsl:variable name='IPprefix'>
            <xsl:value-of select='$octet1' /><xsl:text>.</xsl:text>
            <xsl:value-of select='$octet2' /><xsl:text>.</xsl:text>
            <xsl:value-of select='$octet3' /><xsl:text>.</xsl:text>
      </xsl:variable>
      <xsl:variable name='startMAC'>
          <xsl:choose>
          <xsl:when test='$startMACnybble = "0"'>0</xsl:when>
          <xsl:when test='$startMACnybble = "1"'>0</xsl:when>
          <xsl:when test='$startMACnybble = "2"'>0</xsl:when>
          <xsl:when test='$startMACnybble = "3"'>0</xsl:when>
          <xsl:when test='$startMACnybble = "4"'>64</xsl:when>
          <xsl:when test='$startMACnybble = "5"'>64</xsl:when>
          <xsl:when test='$startMACnybble = "6"'>64</xsl:when>
          <xsl:when test='$startMACnybble = "7"'>64</xsl:when>
          <xsl:when test='$startMACnybble = "8"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "9"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "a"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "b"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "c"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "d"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "e"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "A"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "B"'>128</xsl:when>
          <xsl:when test='$startMACnybble = "C"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "D"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "E"'>192</xsl:when>
          <xsl:when test='$startMACnybble = "F"'>192</xsl:when>
          </xsl:choose>
      </xsl:variable>
      <xsl:variable name='vlan-name'>
          <xsl:choose>
          <xsl:when test='$octet2 = "80"'>NET-80-Blue</xsl:when>
          <xsl:when test='$octet2 = "81"'>NET-81-Red</xsl:when>
          <xsl:when test='$octet2 = "82"'>NET-82-Yellow</xsl:when>
          <xsl:when test='$octet2 = "83"'>NET-83-Green</xsl:when>
          <xsl:when test='$octet2 = "84"'>NET-84-Orange</xsl:when>
          <xsl:when test='$octet2 = "85"'>NET-85-Purple</xsl:when>
          <xsl:when test='$octet2 = "86"'>NET-86-Black</xsl:when>
          <xsl:when test='$octet2 = "87"'>NET-87-White</xsl:when>
          <xsl:when test='$octet2 = "88"'>NET-88-Brown</xsl:when>
          <xsl:when test='$octet2 = "89"'>NET-89-Grey</xsl:when>
          <xsl:when test='$octet2 = "90"'>NET-90-Tan</xsl:when>
          <xsl:when test='$octet2 = "91"'>NET-91-Aqua</xsl:when>
          <xsl:when test='$octet2 = "92"'>NET-92-Pink</xsl:when>
          <xsl:when test='$octet2 = "93"'>NET-93-Pearl</xsl:when>
          <xsl:when test='$octet2 = "94"'>NET-94-Peach</xsl:when>
          <xsl:when test='$octet2 = "95"'>NET-95</xsl:when>
          <xsl:otherwise>NET-24</xsl:otherwise>
          </xsl:choose>
      </xsl:variable>

      <xsl:if test='dns/name'>
      <xsl:call-template name='vm-v4-list'>
        <xsl:with-param name='count'     select='../../@total' />
        <xsl:with-param name='hostname'  select='$hostname' />
        <xsl:with-param name='vlan-name' select='$vlan-name' />
        <xsl:with-param name='IPprefix'  select='$IPprefix' />
        <xsl:with-param name='lastOctet' select='$lastOctet' />
      </xsl:call-template>
      </xsl:if>

      <xsl:call-template name='vm-mac-list'>
        <xsl:with-param name='count'     select='../../@total' />
        <xsl:with-param name='hostname'  select='$hostname' />
        <xsl:with-param name='vlan-name' select='$vlan-name' />
        <xsl:with-param name='baseMAC'   select='$baseMAC' />
        <xsl:with-param name='startMAC'  select='$startMAC' />
        <xsl:with-param name='IPprefix'  select='$IPprefix' />
        <xsl:with-param name='lastOctet' select='$lastOctet' />
      </xsl:call-template>

  </xsl:template>


<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='vms/expand[position() > 1]/interfaces/interface'>
      <xsl:variable name='hostname' select='../interface/dns/name' />
      <xsl:variable name='mac' select='mac' />
      <xsl:variable name='baseMAC' select='substring($mac,1,15)' />
      <xsl:variable name='baseIP' select='ip' />
      <xsl:variable name='octet1' select='substring-before($baseIP,".")' />
      <xsl:variable name='octet2' select='substring-before(substring-after($baseIP,"."),".")' />
      <xsl:variable name='octet3' select='substring-before(substring-after(substring-after($baseIP,"."),"."),".")' />
      <xsl:variable name='lastOctet' select='number(substring-after(substring-after(substring-after($baseIP,"."),"."),"."))' />
      <xsl:variable name='IPprefix'>
            <xsl:value-of select='$octet1' /><xsl:text>.</xsl:text>
            <xsl:value-of select='$octet2' /><xsl:text>.</xsl:text>
            <xsl:value-of select='$octet3' /><xsl:text>.</xsl:text>
      </xsl:variable>
      <xsl:variable name='vlan-name'>
          <xsl:choose>
          <xsl:when test='$octet2 = "80"'>NET-80-Blue</xsl:when>
          <xsl:when test='$octet2 = "81"'>NET-81-Red</xsl:when>
          <xsl:when test='$octet2 = "82"'>NET-82-Yellow</xsl:when>
          <xsl:when test='$octet2 = "83"'>NET-83-Green</xsl:when>
          <xsl:when test='$octet2 = "84"'>NET-84-Orange</xsl:when>
          <xsl:when test='$octet2 = "85"'>NET-85-Purple</xsl:when>
          <xsl:when test='$octet2 = "86"'>NET-86-Black</xsl:when>
          <xsl:when test='$octet2 = "87"'>NET-87-White</xsl:when>
          <xsl:when test='$octet2 = "88"'>NET-88-Brown</xsl:when>
          <xsl:when test='$octet2 = "89"'>NET-89-Grey</xsl:when>
          <xsl:when test='$octet2 = "90"'>NET-90-Tan</xsl:when>
          <xsl:when test='$octet2 = "91"'>NET-91-Aqua</xsl:when>
          <xsl:when test='$octet2 = "92"'>NET-92-Pink</xsl:when>
          <xsl:when test='$octet2 = "93"'>NET-93-Pearl</xsl:when>
          <xsl:when test='$octet2 = "94"'>NET-94-Peach</xsl:when>
          <xsl:when test='$octet2 = "95"'>NET-95</xsl:when>
          <xsl:otherwise>NET-24</xsl:otherwise>
          </xsl:choose>
      </xsl:variable>

      <xsl:if test='dns/name'>
      <xsl:call-template name='vm-v4-list'>
        <xsl:with-param name='count'     select='../../@total' />
        <xsl:with-param name='hostname'  select='$hostname' />
        <xsl:with-param name='vlan-name' select='$vlan-name' />
        <xsl:with-param name='IPprefix'  select='$IPprefix' />
        <xsl:with-param name='lastOctet' select='$lastOctet' />
      </xsl:call-template>
      </xsl:if>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-mac-list'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='vlan-name' />
      <xsl:param name='baseMAC' />
      <xsl:param name='startMAC' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='vm-mac-list'>
              <xsl:with-param name="count" select='$count - 1' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='vlan-name' select='$vlan-name' />
              <xsl:with-param name='baseMAC'   select='$baseMAC' />
              <xsl:with-param name='startMAC'  select='$startMAC' />
              <xsl:with-param name='IPprefix'  select='$IPprefix' />
              <xsl:with-param name='lastOctet' select='$lastOctet' />
          </xsl:call-template>
          <xsl:call-template name='vm-mac'>
              <xsl:with-param name="count" select='$count' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='vlan-name' select='$vlan-name' />
              <xsl:with-param name='baseMAC'   select='$baseMAC' />
              <xsl:with-param name='startMAC'  select='$startMAC' />
              <xsl:with-param name='IPprefix'  select='$IPprefix' />
              <xsl:with-param name='lastOctet' select='$lastOctet' />
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-v4-list'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='vlan-name' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='vm-v4-list'>
              <xsl:with-param name="count" select='$count - 1' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='vlan-name' select='$vlan-name' />
              <xsl:with-param name='IPprefix'  select='$IPprefix' />
              <xsl:with-param name='lastOctet' select='$lastOctet' />
          </xsl:call-template>
          <xsl:call-template name='vm-v4'>
              <xsl:with-param name="count" select='$count' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='vlan-name' select='$vlan-name' />
              <xsl:with-param name='IPprefix'  select='$IPprefix' />
              <xsl:with-param name='lastOctet' select='$lastOctet' />
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-mac'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='vlan-name' />
      <xsl:param name='baseMAC' />
      <xsl:param name='startMAC' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:variable name='vmname' select='concat($hostname,string($count))' />

      <xsl:variable name='mac'>
         <xsl:value-of select='$baseMAC' />
         <xsl:call-template name='util:hex-byte'>
            <xsl:with-param name='value' select='$startMAC + $count - 1' />
         </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name='DNS:CNAME'>
          <xsl:with-param name='hostname' select='$mac' />
          <xsl:with-param name='canonical' select='$vmname' />
      </xsl:call-template>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-v4'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='vlan-name' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:variable name='vmname' select='concat($hostname,string($count))' />
      <xsl:variable name="v4addr">
            <xsl:value-of select='$IPprefix' />
            <xsl:value-of select='string($lastOctet + $count - 1)' />
      </xsl:variable>

      <xsl:call-template name='DNS:A'>
          <xsl:with-param name="hostname" select='$vmname' />
          <xsl:with-param name="address"  select='$v4addr' />
      </xsl:call-template>

      <xsl:call-template name='DNS:A'>
          <xsl:with-param name="hostname">
              <xsl:value-of select='$vlan-name' />
              <xsl:text>.</xsl:text>
              <xsl:value-of select='$vmname' />
          </xsl:with-param>
          <xsl:with-param name="address" select='$v4addr' />
      </xsl:call-template>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
Translate the IPv4 address into an IPv6 subnet number for the routable addresses.
All of the "134" addresses are treated as net24 since the 3rd octet could be 24, 25,
26, 27, 28, 29, 30, and 31; but are all in net24.  Other 134.111 addresses will be
forced into this network for the IPv6 addresses, but this is OK since they should
not be in this DNS server anyway.

The 10.XX addresses get translated to their top two octets, like "1080" and "1081".
  </dc:description>
  <xsl:template name='v6subnet'>
      <xsl:param name='ip' select='ip' />
      <xsl:variable name='octet1' select='substring-before($ip,".")' />
      <xsl:variable name='octet2' select='substring-before(substring-after($ip,"."),".")' />
      <xsl:variable name='octet3' select='substring-before(substring-after(substring-after($ip,"."),"."),".")' />

      <xsl:choose>
      <xsl:when test='$octet1 = "134"'>
          <xsl:text>24</xsl:text>
      </xsl:when>
      <xsl:when test='$octet1 = "10"'>
          <xsl:value-of select="$octet1" />
          <xsl:value-of select="$octet2" />
      </xsl:when>
      <xsl:otherwise>
          <xsl:text>CACA</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
Utility template to reduce the size of the other templates and localize
the addressing information.  This translates an IPv4 subnet and MAC
address to a global IPv6 address using EUI64 for the specific interface.
  </dc:description>
  <xsl:template name='global-ipv6'>
      <xsl:param name='v4addr' />
      <xsl:param name='mac' />

      <xsl:call-template name='IPv6:eui64-suffix'>
          <xsl:with-param name='net'>
              <xsl:text>3D00:FEED:FACE:</xsl:text>
              <xsl:call-template name='v6subnet'>
                  <xsl:with-param name='ip' select='$v4addr' />
              </xsl:call-template>
              <xsl:text>:</xsl:text>
          </xsl:with-param>
          <xsl:with-param name='mac' select='$mac' />
      </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  vim:syntax=plain
  -->
