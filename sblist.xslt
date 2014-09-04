<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version='1.0'>

  <xsl:output method="text"/>

  <dc:title>Process Storbitz host descriptions to create zone data</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Storbitz contains a directory of XML files that describe the hosts in the Avance
test environment.  This transforms the HTML output from the SVN servers listing
of that directory to a script of commands that can be sent to bash to create the
DNS zone file for all of these hosts.

Use this stylesheet as follows:
xsltproc --html http://redgates.com/storbitz/trunk/style/sblist.xslt http://redgates.com/storbitz/trunk/xml/ | bash

The setup_named script in .../storbitz/trunk/bin/setup_named uses this stylesheet
as part of the named installation.
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='a[substring(@href,string-length(@href)-3,4) = ".xml"]'>
      <xsl:text>xsltproc http://redgates.com/storbitz/trunk/style/sb2dns.xslt </xsl:text>
      <xsl:text>http://redgates.com/storbitz/trunk/xml/</xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>&#9;
</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
