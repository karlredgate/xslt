<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Read domains' states and generate a grammar to pick an action for one of them</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

<xsl:output method="text"/>
<xsl:template match='/'>

    <xsl:text>domain : </xsl:text>
    <xsl:for-each select='guests/guest'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> ;&#10;</xsl:text>

    <xsl:text>#define TRANSITIONING </xsl:text>
    <xsl:value-of select='count(guests/guest[state="pausing" or state="stopping" or state="moving" or state="starting" or state="resuming"])'/>
    <xsl:text>&#10;</xsl:text>

    <xsl:text>transitioning-domains : "" </xsl:text>
    <xsl:for-each select='guests/guest[state="pausing" or state="stopping" or state="moving" or state="starting" or state="resuming"]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> "" ;&#10;</xsl:text>

    <xsl:text>#define STEADY </xsl:text>
    <xsl:value-of select='count(guests/guest[state="running" or state="stopped" or state="paused"])'/>
    <xsl:text>&#10;</xsl:text>

    <xsl:text>steady-domains : "" </xsl:text>
    <xsl:for-each select='guests/guest[state="running" or state="stopped" or state="paused"]'>
      <xsl:if test="position() != 1"><xsl:text> | </xsl:text></xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select='name' /><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text> "" ;&#10;</xsl:text>

    <xsl:for-each select='guests/guest'>
      <xsl:value-of select='name' /> : "<xsl:value-of select='state' /><xsl:text>" ;&#10;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select='guests/guest'>
      <xsl:text>uuid-</xsl:text><xsl:value-of select='name' />
      <xsl:text> : "</xsl:text><xsl:value-of select='@id' /><xsl:text>" ;&#10;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select='guests/guest'>
      <xsl:text>primary-</xsl:text><xsl:value-of select='name' />
      <xsl:text> : "</xsl:text><xsl:value-of select='system' /><xsl:text>" ;&#10;</xsl:text>
    </xsl:for-each>

</xsl:template>
</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
