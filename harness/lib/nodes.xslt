<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Generate grammar listing nodes UUIDs.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

<xsl:output method="text"/>
<xsl:template match='/'>

    <xsl:text>nodes : </xsl:text>
    <xsl:for-each select='systems/system'>
      <xsl:if test="position() != 1"> | </xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

    <xsl:text>peer : </xsl:text>
    <xsl:for-each select='systems/system'>
      <xsl:if test="position() != 1"><![CDATA[ <-> ]]></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

    <!-- add a production for 'not-UUID' - list of all other hosts
       - then the "peer" production could be "uuid" <-> not-UUID
       - allowing a pick from more than one peer as a target.
      -->
    <xsl:text>peer-uuid : </xsl:text>
    <xsl:for-each select='systems/system'>
      <xsl:if test="position() != 1"><![CDATA[ <-> ]]></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='@id' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

    <xsl:for-each select='systems/system'>
      <xsl:value-of select='name' /><xsl:text>-state : "</xsl:text>
      <xsl:value-of select='state' /><xsl:text>" ;&#10;</xsl:text>
      <xsl:value-of select='name' /><xsl:text>-uuid : "</xsl:text>
      <xsl:value-of select='@id' /><xsl:text>" ;&#10;</xsl:text>
    </xsl:for-each>

</xsl:template>
</xsl:stylesheet>

<!--
  vim:autoindent
  vim:expandtab
  -->
