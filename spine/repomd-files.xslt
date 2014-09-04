<?xml version='1.0' ?>
<!-- $Id -->
<!-- Return a YAML encoded hash of repo data types to file paths -->
<xsl:stylesheet version="1.0" xmlns:repo="http://linux.duke.edu/metadata/repo"
                              xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />
 
  <xsl:template match='/'>
    <!-- YAML header -->
    <xsl:text>--- 
</xsl:text>

    <xsl:apply-templates select="/repo:repomd/repo:data[@type = 'filelists' or @type = 'primary']" />
  </xsl:template>
    
  <xsl:template match='repo:data'>
    <xsl:value-of select="@type"/><xsl:text>: </xsl:text><xsl:value-of select="repo:location/@href" /><xsl:text>
</xsl:text>
  </xsl:template>

</xsl:stylesheet>

