<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version='1.0'>

  <xsl:output method="text"/>

  <dc:title></dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='/exception'>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:text>Spine </xsl:text>
      <xsl:value-of select='class' />
      <xsl:text> Exception  "</xsl:text>
      <xsl:value-of select='description' />
      <xsl:text>"&#10;</xsl:text>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='stack'>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='frame'>
      <xsl:text>  frame: </xsl:text>
      <xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
