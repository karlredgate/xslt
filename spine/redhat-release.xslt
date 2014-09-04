<?xml version='1.0' ?>
<!-- $Id -->
<xsl:stylesheet version="1.0" xmlns:yum="http://linux.duke.edu/metadata/common"
                              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" />
  <xsl:strip-space elements="*" />

  <xsl:template match='/'>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='yum:metadata'>
    <xsl:apply-templates select='yum:package[substring-after(yum:name,"-")="release"]'>
      <xsl:sort select='yum:time/@build' data-type='number' order="descending" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='yum:package[substring-after(yum:name,"-")="release"]'>
      <xsl:value-of select="yum:location/@href" /><xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match='yum:package'></xsl:template>

</xsl:stylesheet>

