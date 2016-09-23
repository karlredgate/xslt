<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
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
  </dc:description>
  <xsl:template match='storbitz'>
      <xsl:text>use DUT::SiteFile;&#10;</xsl:text>
      <xsl:text>{&#10;</xsl:text>
      <xsl:text>name => nameFromFile(__FILE__), # DEPRECATED&#10;</xsl:text>
      <xsl:apply-templates select='classes' />
      <xsl:text>maxVMs => 16,  # DEPRECATED&#10;</xsl:text>
      <xsl:text>type => '</xsl:text><xsl:value-of select='type' /><xsl:text>',&#10;</xsl:text>
      <xsl:text>cfg => {&#10;</xsl:text>
      <xsl:text>name => nameFromFile(__FILE__),&#10;</xsl:text>
      <xsl:text>maxVMs => 16,  # DEPRECATED&#10;</xsl:text>
      <xsl:apply-templates select='nodes' />
      <xsl:apply-templates select='vms/expand' />
      <xsl:text>};&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='classes'>
      <xsl:text>classes => { </xsl:text>
      <xsl:apply-templates />
      <xsl:text> }, # Scheduler classes&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='classes/class'>
      <xsl:text>'</xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>' => 1, </xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='type'>
      <xsl:text>type => '</xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>',&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='nodes'>
      <xsl:text>nodes => [&#10;</xsl:text>
      <xsl:apply-templates select='node[pxe]' />
      <xsl:text>],&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='node'>
      <xsl:text>{ # Node Description&#10;</xsl:text>
      <xsl:apply-templates select='interfaces/interface' />
      <xsl:text>priv0Port => undef,&#10;</xsl:text>
      <xsl:apply-templates select='serial' />
      <xsl:apply-templates select='power' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>},&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='interfaces/interface'>
      <xsl:text>name => getNameFromMac("</xsl:text>
      <xsl:value-of select='mac' />
      <xsl:text>"),&#10;</xsl:text>
      <xsl:text>address => getAddrFromMac("</xsl:text>
      <xsl:value-of select='mac' />
      <xsl:text>"),&#10;</xsl:text>
      <xsl:text>networkSwitch => undef,&#10;</xsl:text>
      <xsl:text>networkPort => </xsl:text>
      <xsl:value-of select='port' />
      <xsl:text>,&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='serial'>
      <xsl:variable name='hostname' select='../interfaces/interface/dns/name' />

      <xsl:text>serial => { host=>="</xsl:text>
      <xsl:value-of select='host' />
      <xsl:text>", port=></xsl:text>
      <xsl:value-of select='port' />
      <xsl:text> },&#10;</xsl:text>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='power'>
      <xsl:text>powerController => {&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>},&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='outlets/outlet'>
      <xsl:text> => { type=>'PowerController::APC', cfg=>{ address=>'</xsl:text>
      <xsl:value-of select='../../host' />
      <xsl:text>', outlet=></xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>, }, },&#10;</xsl:text>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template match='vms/expand'>
      <xsl:variable name='hostname' select='interfaces/interface/dns/name' />
      <xsl:variable name='mac' select='interfaces/interface/mac' />
      <xsl:variable name='baseMAC' select='substring($mac,1,15)' />
      <xsl:variable name='startMACnybble' select='substring($mac,16,1)' />
      <xsl:variable name='baseIP' select='interfaces/interface/ip' />
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

      <xsl:text>vms => [&#10;</xsl:text>
      <xsl:call-template name='vm-name-list'>
        <xsl:with-param name='count'     select='@total' />
        <xsl:with-param name='hostname'  select='$hostname' />
      </xsl:call-template>
      <xsl:text>],&#10;</xsl:text>

      <xsl:text>mac2ip => {&#10;</xsl:text>
      <xsl:call-template name='vm-address-list'>
        <xsl:with-param name='count'     select='@total' />
        <xsl:with-param name='baseMAC'   select='$baseMAC' />
        <xsl:with-param name='startMAC'  select='$startMAC' />
        <xsl:with-param name='IPprefix'  select='$IPprefix' />
        <xsl:with-param name='lastOctet' select='$lastOctet' />
      </xsl:call-template>
      <xsl:text>},&#10;</xsl:text>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-name-list'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />

      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='vm-name-list'>
              <xsl:with-param name="count" select='$count - 1' />
              <xsl:with-param name='hostname'  select='$hostname' />
          </xsl:call-template>
          <xsl:call-template name='vm-name'>
              <xsl:with-param name="count" select='$count' />
              <xsl:with-param name='hostname'  select='$hostname' />
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-address-list'>
      <xsl:param name='count' />
      <xsl:param name='baseMAC' />
      <xsl:param name='startMAC' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='vm-address-list'>
              <xsl:with-param name="count" select='$count - 1' />
              <xsl:with-param name='baseMAC'   select='$baseMAC' />
              <xsl:with-param name='startMAC'  select='$startMAC' />
              <xsl:with-param name='IPprefix'  select='$IPprefix' />
              <xsl:with-param name='lastOctet' select='$lastOctet' />
          </xsl:call-template>
          <xsl:call-template name='vm-address'>
              <xsl:with-param name="count" select='$count' />
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
  <xsl:template name='vm-name'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />

      <xsl:variable name='vmname' select='concat($hostname,string($count))' />

      <xsl:text>{ name => "</xsl:text>
      <xsl:value-of select='$vmname' />
      <xsl:text>" },&#10;</xsl:text>

  </xsl:template>

<!-- ======================================================== -->
  <dc:description>
  </dc:description>
  <xsl:template name='vm-address'>
      <xsl:param name='count' />
      <xsl:param name='baseMAC' />
      <xsl:param name='startMAC' />
      <xsl:param name='IPprefix' />
      <xsl:param name='lastOctet' />

      <xsl:variable name="v4addr">
            <xsl:value-of select='$IPprefix' />
            <xsl:value-of select='string($lastOctet + $count - 1)' />
      </xsl:variable>

      <xsl:variable name='mac'>
         <xsl:value-of select='$baseMAC' />
         <xsl:call-template name='util:hex-byte'>
            <xsl:with-param name='value' select='$startMAC + $count - 1' />
         </xsl:call-template>
      </xsl:variable>

      <xsl:text>  '</xsl:text>
      <xsl:value-of select='$mac' />
      <xsl:text>' => '</xsl:text>
      <xsl:value-of select='$v4addr' />
      <xsl:text>',&#10;</xsl:text>

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

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
