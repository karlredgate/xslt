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

  <xsl:output method='text'/>

  <dc:title>Generate Start of Authority record from Storbitz version</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
This transform generates a Start of Authority (SOA record) for a DNS zone file.
It is intended to be included in the Avance zone files right after the $TTL setting.
The SOA record contains information about how the zone is maintained between
different DNS servers.  The important part is the version number.  This version
number allows cooperating DNS servers to know when they need to do a zone
transfer to update their information.  In this transform we use the SVN version
number of the storbitz trunk area (<url>http://redgates.com/storbitz/trunk/</url>)
as the version number of the zone.  This was chosen so that not only changes in
the host xml files would affect the version, but changes to the transforms and
base configuration files would also.

Need to make sure that all know DNS slave servers are listed in the NS records below
so that the "notify" protocol will work.
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='/html/head/title'>
      <xsl:variable name='version' select='substring-before(substring-after(.," "),":")' />
      <xsl:text>@&#9;&#9;IN SOA&#9;descartes.sn.redgates.com. hostmaster.sn.redgates.com (&#10;</xsl:text>
      <xsl:text>&#9;&#9;&#9;</xsl:text><xsl:value-of select='$version' /><xsl:text>&#9;; serial&#10;</xsl:text>
      <xsl:text>&#9;&#9;&#9;3H&#9;; refresh&#10;</xsl:text>
      <xsl:text>&#9;&#9;&#9;15M&#9;; retry&#10;</xsl:text>
      <xsl:text>&#9;&#9;&#9;1W&#9;; expiry&#10;</xsl:text>
      <xsl:text>&#9;&#9;&#9;1D )&#9;; minimum&#10;</xsl:text>
      <xsl:text>&#9;&#9;IN NS&#9;descartes&#10;</xsl:text>
      <xsl:text>&#9;&#9;IN NS&#9;hilbert&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
