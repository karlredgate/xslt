<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xs='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <dc:title>Utility transformation library</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
This contains a set of transformations that are generally useful and so do not
belong in the specific stylesheets.
  </dc:description>

  <xsl:template name='util:left-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:value-of select='$node' />
      <xsl:call-template name='pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='util:right-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:call-template name='util:pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
      <xsl:value-of select='$node' />
  </xsl:template>

  <xsl:template name='util:pad'>
      <xsl:param name='count' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='util:pad'>
            <xsl:with-param name="count" select='$count - 1' />
            <xsl:with-param name='fill' select='$fill' />
        </xsl:call-template>
        <xsl:value-of select='$fill' />
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name='util:hex-digit'>
      <xsl:param name='value' />
      <xsl:choose>
      <xsl:when test="$value = 0">0</xsl:when>
      <xsl:when test="$value = 1">1</xsl:when>
      <xsl:when test="$value = 2">2</xsl:when>
      <xsl:when test="$value = 3">3</xsl:when>
      <xsl:when test="$value = 4">4</xsl:when>
      <xsl:when test="$value = 5">5</xsl:when>
      <xsl:when test="$value = 6">6</xsl:when>
      <xsl:when test="$value = 7">7</xsl:when>
      <xsl:when test="$value = 8">8</xsl:when>
      <xsl:when test="$value = 9">9</xsl:when>
      <xsl:when test="$value = 10">A</xsl:when>
      <xsl:when test="$value = 11">B</xsl:when>
      <xsl:when test="$value = 12">C</xsl:when>
      <xsl:when test="$value = 13">D</xsl:when>
      <xsl:when test="$value = 14">E</xsl:when>
      <xsl:when test="$value = 15">F</xsl:when>
      <xsl:otherwise>
          <xsl:message>Invalid HEX digit '<xsl:value-of select="$value" />'</xsl:message>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name='util:hex-value'>
      <xsl:param name='value' />
      <xsl:choose>
      <xsl:when test="$value = 0"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='util:hex-value'>
            <xsl:with-param name='value' select='floor($value div 16)' />
        </xsl:call-template>
        <xsl:call-template name='util:hex-digit'>
            <xsl:with-param name='value' select='$value mod 16' />
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name='util:hex-byte'>
      <xsl:param name='value' />
      <xsl:call-template name='util:hex-digit'>
          <xsl:with-param name='value' select='floor($value div 16)' />
      </xsl:call-template>
      <xsl:call-template name='util:hex-digit'>
          <xsl:with-param name='value' select='$value mod 16' />
      </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
