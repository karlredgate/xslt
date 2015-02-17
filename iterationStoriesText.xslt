<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://svn.sn.stratus.com/storbitz/DNS'
                xmlns:IPv6='http://svn.sn.stratus.com/storbitz/IPv6'
                xmlns:util='http://svn.sn.stratus.com/storbitz/utils'
                xmlns:str='http://exslt.org/strings'
                version='1.0'>

  <dc:title>Generate a nice report of the stories in an iteration</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  Create a postscript report from an XML doc from PivotalTracker.com
  </dc:description>

  <xsl:key name='engineer' match='story' use='owned_by' />

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/iterations/iteration'>
      <xsl:text></xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='stories'>
      <xsl:for-each select='story[count(. | key("engineer", owned_by)[1]) = 1]'>
          <xsl:sort select='owned_by' />

          <xsl:text></xsl:text>
          <xsl:value-of select='owned_by' />
          <xsl:text>:&#10;</xsl:text>

          <xsl:for-each select='key("engineer", owned_by)'>
              <xsl:text>  </xsl:text>
              <xsl:value-of select='id' />
              <xsl:text>  </xsl:text>
              <xsl:value-of select='name' />
              <xsl:text>&#10;</xsl:text>
          </xsl:for-each>
      </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
