<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                version='1.0'>

<xsl:template match='template'>

<xsl:document href="templates/{$uuid}.template">
  <xsl:copy select='.'>
  <xsl:attribute name='id'><xsl:value-of select='$uuid' /></xsl:attribute>
    <xsl:for-each select='*'><xsl:copy-of select='.'/></xsl:for-each>
  </xsl:copy>
</xsl:document>

</xsl:template>

</xsl:stylesheet>
