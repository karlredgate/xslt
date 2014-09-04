<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://svn.sn.stratus.com/storbitz/DNS'
                xmlns:IPv6='http://svn.sn.stratus.com/storbitz/IPv6'
                xmlns:util='http://svn.sn.stratus.com/storbitz/utils'
                version='1.0'>

  <dc:title>Determine shared network pairing for a DUT.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:key name='lan' match='/cluster/lans/lan' use='@id' />
  <xsl:key name='network' match='/cluster/networks/network' use='@id' />
  <xsl:key name='interface' match='/cluster/systems/system/networks/interface' use='@id' />

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster/networks/network'>
      <xsl:variable name='intf1' select='key("interface",networks/interface[1]/@ref)' />
      <xsl:variable name='intf2' select='key("interface",networks/interface[2]/@ref)' />

      <xsl:if test='$intf1/lan/@ref != $intf2/lan/@ref'>
          <xsl:value-of select='name' />
          <xsl:text> mis-wire </xsl:text>

          <xsl:value-of select='$intf1/../../name' /><!-- node -->
          <xsl:text>:</xsl:text>
          <xsl:value-of select='$intf1/name' />

          <xsl:text>-></xsl:text>
          <xsl:value-of select='$intf1/lan/@ref' />
          <xsl:text> != </xsl:text>

          <xsl:value-of select='$intf2/../../name' /><!-- node -->
          <xsl:text>:</xsl:text>
          <xsl:value-of select='$intf2/name' />

          <xsl:text>-></xsl:text>
          <xsl:value-of select='$intf2/lan/@ref' />
          <xsl:text>&#10;</xsl:text>
      </xsl:if>

      <xsl:if test='$intf1/bandwidth != $intf2/bandwidth'>
          <xsl:value-of select='name' />
          <xsl:text> poor speed match </xsl:text>

          <xsl:value-of select='$intf1/../../name' /><!-- node -->
          <xsl:text>:</xsl:text>
          <xsl:value-of select='$intf1/name' />
          <xsl:text> bw=</xsl:text>
          <xsl:value-of select='$intf1/bandwidth' />
          <xsl:text>  while  </xsl:text>

          <xsl:value-of select='$intf2/../../name' /><!-- node -->
          <xsl:text>:</xsl:text>
          <xsl:value-of select='$intf2/name' />
          <xsl:text> bw=</xsl:text>
          <xsl:value-of select='$intf2/bandwidth' />
          <xsl:text>&#10;</xsl:text>

          <xsl:text>&#10;</xsl:text>
      </xsl:if>

  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
