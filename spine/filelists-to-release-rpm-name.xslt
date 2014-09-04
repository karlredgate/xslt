<?xml version='1.0' ?>
<!-- $Id -->
<!-- Return the path to the RPM which has "/etc/{centos,redhat,fedora,SUSE}-release" -->
<xsl:stylesheet version="1.0" xmlns:fl="http://linux.duke.edu/metadata/filelists"
                              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />
 
  <xsl:template match='/'>
    <xsl:apply-templates select="/fl:filelists/fl:package[fl:file='/etc/redhat-release' or fl:file='/etc/fedora-release']" />
  </xsl:template>
    
  <xsl:template match='fl:package'>
    <xsl:value-of select="@name"/><xsl:text>
</xsl:text>
  </xsl:template>

</xsl:stylesheet>

