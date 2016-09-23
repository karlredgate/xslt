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

  <xsl:output method="xml"/>

  <dc:title></dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='/html'>
      <list>
      <xsl:apply-templates />
      </list>
  </xsl:template>

  <xsl:template match='a[substring(@href,string-length(@href)-3,4) = ".xml"]'>
      <xsl:apply-templates select='document(concat("http://redgates.com/hostlist/",.))' />
  </xsl:template>

  <!-- need to handle case when there is no IPv4 address -->
  <xsl:template match='interface'>
      <domain class='host' reverse='true'>
          <name><xsl:value-of select='dns/name' /></name>
          <xsl:if test='mac'><mac><xsl:value-of select='mac' /></mac></xsl:if>
          <xsl:if test='../../pxeboot/mac'><pxeboot><xsl:value-of select='../../pxeboot/mac' /></pxeboot></xsl:if>
          <xsl:if test='../../pxe/loader'><pxe><loader><xsl:value-of select='../../pxe/loader' /></loader></pxe></xsl:if>
          <xsl:if test='../../pxe/bootloader'><bootloader><xsl:value-of select='../../pxe/bootloader' /></bootloader></xsl:if>
          <xsl:call-template name='split-address'>
              <xsl:with-param name='address' select='ip' />
          </xsl:call-template>
      </domain>
  </xsl:template>

  <xsl:template match='vms/expand/interfaces/interface'>
      <xsl:variable name='baseIP' select='ip' />
      <xsl:variable name='baseMAC' select='substring(mac,1,15)' />
      <xsl:variable name='baseOCTET'>
          <xsl:call-template name='extract-base-octet'>
              <xsl:with-param name='mac' select='mac' />
          </xsl:call-template>
      </xsl:variable>
      <xsl:variable name='octet1' select='substring-before($baseIP,".")' />
      <xsl:variable name='octet2' select='substring-before(substring-after($baseIP,"."),".")' />
      <xsl:variable name='octet3' select='substring-before(substring-after(substring-after($baseIP,"."),"."),".")' />
      <xsl:variable name='octet4' select='number(substring-after(substring-after(substring-after($baseIP,"."),"."),"."))' />

      <xsl:call-template name='vm-list'>
        <xsl:with-param name='count'     select='../../@total' />
        <xsl:with-param name='hostname'>
            <xsl:choose>
            <xsl:when test="dns/name"><xsl:value-of select='dns/name' /></xsl:when>
            <xsl:otherwise><xsl:value-of select='../interface/dns/name' />-a</xsl:otherwise>
            </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name='baseMAC'   select='$baseMAC' />
        <xsl:with-param name='baseOCTET' select='$baseOCTET' />
        <xsl:with-param name='subnet'>
            <xsl:element name='a'><xsl:value-of select='$octet1' /></xsl:element>
            <xsl:element name='b'><xsl:value-of select='$octet2' /></xsl:element>
            <xsl:element name='c'><xsl:value-of select='$octet3' /></xsl:element>
        </xsl:with-param>
        <xsl:with-param name='octet4'  select='$octet4' />
        <xsl:with-param name='reverse'>
            <xsl:choose>
            <xsl:when test="dns/name">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>

  </xsl:template>

  <xsl:template name='vm-list'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='baseMAC' />
      <xsl:param name='baseOCTET' />
      <xsl:param name='subnet' />
      <xsl:param name='octet4' />
      <xsl:param name='reverse' />

      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='vm-list'>
              <xsl:with-param name="count"     select='$count - 1' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='baseMAC'   select='$baseMAC' />
              <xsl:with-param name='baseOCTET' select='$baseOCTET' />
              <xsl:with-param name='subnet'    select='$subnet' />
              <xsl:with-param name='octet4'    select='$octet4' />
              <xsl:with-param name='reverse'   select='$reverse' />
          </xsl:call-template>
          <xsl:call-template name='vm'>
              <xsl:with-param name="count"     select='$count' />
              <xsl:with-param name='hostname'  select='$hostname' />
              <xsl:with-param name='baseMAC'   select='$baseMAC' />
              <xsl:with-param name='baseOCTET' select='$baseOCTET' />
              <xsl:with-param name='subnet'    select='$subnet' />
              <xsl:with-param name='octet4'    select='$octet4' />
              <xsl:with-param name='reverse'   select='$reverse' />
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name='vm'>
      <xsl:param name='count' />
      <xsl:param name='hostname' />
      <xsl:param name='baseMAC' />
      <xsl:param name='baseOCTET' />
      <xsl:param name='subnet' />
      <xsl:param name='octet4' />
      <xsl:param name='reverse' />

      <domain class='vm' reverse='{$reverse}'>
          <name><xsl:value-of select='$hostname' /><xsl:value-of select='string($count)' /></name>
          <xsl:element name='mac'>
             <xsl:value-of select='$baseMAC' />
             <xsl:call-template name='util:hex-byte'>
                <xsl:with-param name='value' select='($baseOCTET + $count) - 1' />
             </xsl:call-template>
          </xsl:element>

          <address>
            <xsl:copy-of select='$subnet' />
            <d><xsl:value-of select='$octet4 + $count - 1' /></d>
          </address>
      </domain>
  </xsl:template>

  <xsl:template name='split-address'>
      <xsl:param name='address' />
      <xsl:variable name='octet1' select='substring-before($address,".")' />
      <xsl:variable name='octet2' select='substring-before(substring-after($address,"."),".")' />
      <xsl:variable name='octet3' select='substring-before(substring-after(substring-after($address,"."),"."),".")' />
      <xsl:variable name='octet4' select='number(substring-after(substring-after(substring-after($address,"."),"."),"."))' />
      <address>
          <a><xsl:value-of select='$octet1' /></a>
          <b><xsl:value-of select='$octet2' /></b>
          <c><xsl:value-of select='$octet3' /></c>
          <d><xsl:value-of select='$octet4' /></d>
      </address>
  </xsl:template>

  <dc:description>
Translate the two most significant bits of the last octet of the MAC
address to a base octet decimal value that can be used as the base
value to calculate a VMs MAC address.
  </dc:description>
  <xsl:template name='extract-base-octet'>
      <xsl:param name='mac' />
      <xsl:variable name='nybble' select='substring($mac,16,1)' />
      <xsl:choose>
      <xsl:when test="$nybble = 0">0</xsl:when>
      <xsl:when test="$nybble = 1">0</xsl:when>
      <xsl:when test="$nybble = 2">0</xsl:when>
      <xsl:when test="$nybble = 3">0</xsl:when>
      <xsl:when test="$nybble = 4">64</xsl:when>
      <xsl:when test="$nybble = 5">64</xsl:when>
      <xsl:when test="$nybble = 6">64</xsl:when>
      <xsl:when test="$nybble = 7">64</xsl:when>
      <xsl:when test="$nybble = 8">128</xsl:when>
      <xsl:when test="$nybble = 9">128</xsl:when>
      <xsl:when test="$nybble = 'A'">128</xsl:when>
      <xsl:when test="$nybble = 'a'">128</xsl:when>
      <xsl:when test="$nybble = 'B'">128</xsl:when>
      <xsl:when test="$nybble = 'b'">128</xsl:when>
      <xsl:when test="$nybble = 'C'">192</xsl:when>
      <xsl:when test="$nybble = 'c'">192</xsl:when>
      <xsl:when test="$nybble = 'D'">192</xsl:when>
      <xsl:when test="$nybble = 'd'">192</xsl:when>
      <xsl:when test="$nybble = 'E'">192</xsl:when>
      <xsl:when test="$nybble = 'e'">192</xsl:when>
      <xsl:when test="$nybble = 'F'">192</xsl:when>
      <xsl:when test="$nybble = 'f'">192</xsl:when>
      <xsl:otherwise>
          <xsl:message>Invalid HEX digit '<xsl:value-of select="$nybble" />'</xsl:message>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
