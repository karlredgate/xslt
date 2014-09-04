<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Guest result?</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

<xsl:template match='/guest'>
      <xsl:value-of select='state' />
</xsl:template>
<xsl:output method="text"/>
</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
