<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc='http://purl.org/dc/elements/1.1/'
                xmlns:scxml='http://www.w3.org/2005/07/scxml'
                xmlns:ax='http://stratus.com/everRun/AX/'
                xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'
                version='1.0'>

  <dc:title>Generate Dot Graph of SCXML State Machine</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:output method="text"/>
  <xsl:template match='text()' />
  <xsl:template match='node()' />

  <dc:description>
  </dc:description>
  <xsl:template match='scxml:scxml'>
    <xsl:text>digraph sc {&#10;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='scxml:state'>
    <xsl:value-of select='@id' />
    <xsl:text>;&#10;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='scxml:transition'>
    <xsl:value-of select='../@id' />
    <xsl:text> -&gt; </xsl:text>
    <xsl:value-of select='scxml:target/@next' />
    <xsl:text> [label="</xsl:text>
    <xsl:value-of select='@event' />
    <xsl:text>"];&#10;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
