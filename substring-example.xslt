<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                version='1.0'>
          <xsl:output method='text'/>
          <xsl:template match='text()' />
          <xsl:template match='/log/logentry/paths/path'>
          <xsl:choose>
             <xsl:when test='substring-before(.,"platform/install/files/usr/lib/sa/sa1_avance") != ""'>
               <xsl:value-of select='.' />
<xsl:text>
</xsl:text>
             </xsl:when>
          </xsl:choose>
          </xsl:template>
</xsl:stylesheet>
