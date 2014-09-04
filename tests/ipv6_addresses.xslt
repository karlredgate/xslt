<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://redgates.com/xslt/DNS'
                xmlns:IPv6='http://redgates.com/xslt/IPv6'
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <xsl:import href='../ipv6.xslt'/>
  <xsl:output method='xml' indent='yes' />

  <xsl:template match='text()' />

  <xsl:template match='/'>
      <xsl:element name='addresses'>
      <xsl:apply-templates />
      </xsl:element>
  </xsl:template>

  <xsl:template match='address'>
      <xsl:element name='address'>
        <xsl:call-template name='IPv6:expand-segments'>
          <xsl:with-param name='address'>
             <xsl:call-template name='IPv6:segment-address'>
               <xsl:with-param name='address' select='.' />
             </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:element>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
