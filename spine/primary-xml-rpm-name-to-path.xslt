<?xml version='1.0' ?>
<!-- $Id -->
<xsl:stylesheet version="1.0" xmlns:yum="http://linux.duke.edu/metadata/common"
                              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="rpm-name" />
 
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />
 
  <xsl:template match='/'>
    <xsl:apply-templates select='/yum:metadata/yum:package[yum:name = $rpm-name]' />
  </xsl:template>
    
  <xsl:template match='yum:package'>
    <xsl:value-of select="yum:location/@href" />
  </xsl:template>
 
</xsl:stylesheet>

