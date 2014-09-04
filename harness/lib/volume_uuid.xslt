<?xml version='1.0' ?>
<!-- read domains' states and generate a grammar to pick an action for one of them -->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
                version='1.0'>

  <dc:title>Print volume UUID</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

<!-- this should be more generic - and not use 'region' -->
<xsl:template match='/region'>
      <xsl:value-of select='@id' />
</xsl:template>
<xsl:output method="text"/>
</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
