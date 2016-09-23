<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:exslt="http://exslt.org/common"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://redgates.com/xslt/DNS'
                xmlns:IPv6='http://redgates.com/xslt/IPv6'
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <xsl:import href="dns.xslt"/>
  <xsl:import href="ipv6.xslt"/>
  <xsl:output method="text"/>

  <dc:title>Generate reverse zone files for all IPv6 subnets</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='segment'>
      <xsl:value-of select='substring(.,4,1)' />
      <xsl:text>.</xsl:text>
      <xsl:value-of select='substring(.,3,1)' />
      <xsl:text>.</xsl:text>
      <xsl:value-of select='substring(.,2,1)' />
      <xsl:text>.</xsl:text>
      <xsl:value-of select='substring(.,1,1)' />
  </xsl:template>

  <xsl:template name='reverse-segments'>
      <xsl:param name='segments' as='node()*' />

      <xsl:choose>
      <xsl:when test='count($segments) = 1'>
          <xsl:apply-templates select='$segments[1]' />
      </xsl:when>
      <xsl:otherwise>
          <xsl:call-template name='reverse-segments'>
             <xsl:with-param name='segments' select='$segments[position() > 1]' />
          </xsl:call-template>
          <xsl:text>.</xsl:text>
          <xsl:apply-templates select='$segments[1]' />
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match='domain'>

      <xsl:variable name='subnet-address'>
          <xsl:call-template name='IPv6:eui64-suffix'>
             <xsl:with-param name='net'>3D00:FEED:FACE:24:</xsl:with-param>
             <xsl:with-param name='mac' select='mac' />
          </xsl:call-template>
      </xsl:variable>

      <xsl:variable name='link-address'>
          <xsl:call-template name='IPv6:eui64-suffix'>
             <xsl:with-param name='net'>fe80::</xsl:with-param>
             <xsl:with-param name='mac' select='mac' />
          </xsl:call-template>
      </xsl:variable>

      <xsl:variable name='subnet-segments'>
         <xsl:call-template name='IPv6:expand-segments'>
            <xsl:with-param name='address'>
               <xsl:call-template name='IPv6:segment-address'>
                 <xsl:with-param name='address' select='$subnet-address' />
               </xsl:call-template>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>

      <xsl:variable name='link-segments'>
         <xsl:call-template name='IPv6:expand-segments'>
            <xsl:with-param name='address'>
               <xsl:call-template name='IPv6:segment-address'>
                 <xsl:with-param name='address' select='$link-address' />
               </xsl:call-template>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name='DNS:PTR'>
          <xsl:with-param name='hostname'>
              <xsl:call-template name='reverse-segments'>
                  <xsl:with-param name='segments' select='exslt:node-set($subnet-segments)//segment' />
              </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name='target'>
              <xsl:value-of select='name' />
              <xsl:text>.sn.redgates.com.</xsl:text>
          </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name='DNS:PTR'>
          <xsl:with-param name='hostname'>
              <xsl:call-template name='reverse-segments'>
                  <xsl:with-param name='segments' select='exslt:node-set($link-segments)//segment' />
              </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name='target'>
              <xsl:text>link.</xsl:text>
              <xsl:value-of select='name' />
              <xsl:text>.sn.redgates.com.</xsl:text>
          </xsl:with-param>
      </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
