<?xml version='1.0' ?>
<!-- read domains' states and generate a grammar to pick an action for one of them -->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Pretty-print spine stack trace</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

<xsl:template match='/exception'>
    <xsl:text>Description: </xsl:text><xsl:value-of select='description' /><xsl:text>&#10;</xsl:text>
    <xsl:text>Class:       </xsl:text><xsl:value-of select='class' /><xsl:text>&#10;</xsl:text>
    <xsl:text>   === Stack === &#10;</xsl:text>
    <xsl:for-each select='stack/frame'>
        <xsl:value-of select='.' /><xsl:text>&#10;</xsl:text>
    </xsl:for-each>
</xsl:template>

<xsl:template match='/error'>
    <xsl:text>Message: </xsl:text><xsl:value-of select='message' /><xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:output method="text"/>
</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
