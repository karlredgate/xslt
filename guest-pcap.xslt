<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://svn.sn.stratus.com/storbitz/DNS'
                xmlns:IPv6='http://svn.sn.stratus.com/storbitz/IPv6'
                xmlns:util='http://svn.sn.stratus.com/storbitz/utils'
                version='1.0'>

  <dc:title>Generate a nice report of the VMs on a DUT</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
<!-- <xsl:template match='packet/[proto/@name="eth"/field/@name="eth.dst"/@show="00:04:fc:40:1e:03"]/'> -->
  <!-- <xsl:template match='packet/proto[@name="eth"]/field[@name="eth.dst" and @show="00:04:fc:40:1e:03"]'> -->
  <!--
  <xsl:template match='packet/[
  proto/@name="eth" and 
  proto/field/@name="eth.dst" and
  -->
  <xsl:template match='packet/[ proto/@name="eth" ]'>
      <xsl:text> - - - - - MAIN - - - - - </xsl:text>
      <xsl:text>&#10;</xsl:text>

      <xsl:copy-of select='.' />

      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='guest'>
      <xsl:text> - - - - - - - - - - </xsl:text>
      <xsl:value-of select='name' /><xsl:text>  (</xsl:text>
      <xsl:value-of select='state' /><xsl:text>/</xsl:text>
      <xsl:value-of select='mode' /><xsl:text>)</xsl:text>
      <xsl:text> - - - - - - - - - - -&#10;</xsl:text>
      <xsl:value-of select='id' /><xsl:text>  </xsl:text>
      <xsl:value-of select='system' /><xsl:text>  </xsl:text>
      <xsl:text>cpus/</xsl:text><xsl:value-of select='vcpus' />
      <xsl:text>  memory/</xsl:text><xsl:value-of select='memory' />
      <xsl:text>  </xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name='left-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:value-of select='$node' />
      <xsl:call-template name='pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='right-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:call-template name='pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
      <xsl:value-of select='$node' />
  </xsl:template>

  <xsl:template name='pad'>
      <xsl:param name='count' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='pad'>
            <xsl:with-param name="count" select='$count - 1' />
            <xsl:with-param name='fill' select='$fill' />
        </xsl:call-template>
        <xsl:value-of select='$fill' />
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
