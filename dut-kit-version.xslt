<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version='1.0'>

  <xsl:output method="text"/>

  <dc:title></dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='/kits/kit/product/version/name'>
      <xsl:value-of select='.' />
  </xsl:template>

  <xsl:template match='/system/model'>
      <xsl:value-of select='.' />
  </xsl:template>

</xsl:stylesheet>
