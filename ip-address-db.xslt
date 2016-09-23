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

  <dc:title>Generate DHCP configuration files for each subnet</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Given a flat XML file for each host/IPv4 address combination, generate a CSV
file of the hostname, IPv4 address, and MAC address.
  </dc:description>

  <xsl:output method="text"/>

  <!-- replace the default transform for text elements to print nothing, since we
       want to only generate the exact output text we specify in these transforms. -->
  <xsl:template match='text()' />

  <xsl:template match='domain'>
      <xsl:value-of select='name' />
      <xsl:text>,</xsl:text>
      <xsl:value-of select='concat(address/a,".",address/b,".",address/c,".",address/d)' />
      <xsl:text>,</xsl:text>
      <xsl:value-of select='mac' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
