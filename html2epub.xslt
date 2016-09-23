<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version='1.0'>

  <xsl:output method="html"/>

  <dc:title></dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
  Input should be HTML also.
  This is not doing everything I want yet.
  It is just a starting point
  Currently all it does is eliminate the nav and script elements.
  </dc:description>

  <xsl:template match='nav'>
  </xsl:template>

  <xsl:template match='script'>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
       <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
