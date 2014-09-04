<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Generate grammar productions for storage classes.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  Should pick usable regions based on attachable attribute
  </dc:description>

<xsl:output method="text"/>
<xsl:template match='/'>

    <xsl:text>carvable : </xsl:text>
    <xsl:for-each select='storage/*[carvable="true"]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='@id' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

  <dc:description>
    storage devices which are carvable and have at least 4GB available
  </dc:description>
    <xsl:text>small-carvable : </xsl:text>
    <xsl:for-each select='storage/*[carvable="true" and capacity &gt; 4000]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='@id' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

  <dc:description>
    storage devices which are carvable and have at least 15GB available
  </dc:description>
    <xsl:text>large-carvable : </xsl:text>
    <xsl:for-each select='storage/*[carvable="true" and capacity &gt; 15000]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='@id' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

    <xsl:text>attachable : </xsl:text>
    <xsl:for-each select='storage/*[attachable="true"]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='@id' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

  <dc:description>
    specific information about each storage device
  </dc:description>
    <xsl:for-each select='storage/*'>
      <xsl:text>// start&#10;</xsl:text>
      <xsl:text>name-</xsl:text><xsl:value-of select='@id' /><xsl:text> : </xsl:text>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>" ;&#10;</xsl:text>
      <xsl:text>available-</xsl:text><xsl:value-of select='@id' />
      <xsl:text> : "</xsl:text><xsl:value-of select='available' /><xsl:text>" ;&#10;</xsl:text>
      <xsl:text>capacity-</xsl:text><xsl:value-of select='@id' />
      <xsl:text> : "</xsl:text><xsl:value-of select='capacity' /><xsl:text>" ;&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>

</xsl:template>
</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
