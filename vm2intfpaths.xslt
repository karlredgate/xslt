<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                version='1.0'>

  <xsl:output method='text'/>
  <xsl:template match='text()' />

  <xsl:template match='/guest/interfaces/interface'>
      <xsl:text>/domains/id/</xsl:text>
      <xsl:value-of select='../../@id' />
      <xsl:text>/interfaces/id/</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
