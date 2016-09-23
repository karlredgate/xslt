<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://redgates.com/xslt/DNS'
                version='1.0'>

  <dc:title>Template library for DNS resource records</dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:template name='DNS:RR'>
      <xsl:param name='hostname' />
      <xsl:param name='type' />
      <xsl:param name='value' />

      <xsl:value-of select='$hostname' />
      <xsl:if test="string-length($hostname) &lt; 17"><xsl:text>&#9;</xsl:text></xsl:if>
      <xsl:if test="string-length($hostname) &lt; 9"><xsl:text>&#9;</xsl:text></xsl:if>
      <xsl:text>&#9;IN </xsl:text>
      <xsl:value-of select='$type' />
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select='$value' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name='DNS:HINFO'>
      <xsl:param name='hostname' />
      <xsl:param name='platform' />
      <xsl:param name='os' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>HINFO</xsl:with-param>
          <xsl:with-param name='value'>
              <xsl:text>"</xsl:text>
              <xsl:value-of select='$platform' />
              <xsl:text>" "</xsl:text>
              <xsl:value-of select='$os' />
              <xsl:text>"</xsl:text>
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:RP'>
      <xsl:param name='hostname' />
      <xsl:param name='mailbox' />
      <xsl:param name='text' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>RP</xsl:with-param>
          <xsl:with-param name='value'>
              <xsl:value-of select='$mailbox' />
              <xsl:text> </xsl:text>
              <xsl:value-of select='$text' />
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:SRV'>
      <xsl:param name='service' />
      <xsl:param name='protocol'>tcp</xsl:param>
      <xsl:param name='hostname' />
      <xsl:param name='priority'>1</xsl:param>
      <xsl:param name='weight'>1</xsl:param>
      <xsl:param name='port' />
      <xsl:param name='target' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname'>
            <xsl:text>_</xsl:text>
            <xsl:value-of select='$service' />
            <xsl:text>.</xsl:text>
            <xsl:text>_</xsl:text>
            <xsl:value-of select='$protocol' />
            <xsl:text>.</xsl:text>
            <xsl:value-of select='$hostname' />
          </xsl:with-param>
          <xsl:with-param name='type'>SRV</xsl:with-param>
          <xsl:with-param name='value'>
              <xsl:value-of select='$priority' />
              <xsl:text> </xsl:text>
              <xsl:value-of select='$weight' />
              <xsl:text> </xsl:text>
              <xsl:value-of select='$port' />
              <xsl:text> </xsl:text>
              <xsl:value-of select='$target' />
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:TXT'>
      <xsl:param name='hostname' />
      <xsl:param name='text' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>TXT</xsl:with-param>
          <xsl:with-param name='value'>"<xsl:value-of select='$text' />"</xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:CNAME'>
      <xsl:param name='hostname' />
      <xsl:param name='canonical' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>CNAME</xsl:with-param>
          <xsl:with-param name='value'><xsl:value-of select='$canonical' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:PTR'>
      <xsl:param name='hostname' />
      <xsl:param name='target' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>PTR</xsl:with-param>
          <xsl:with-param name='value'><xsl:value-of select='$target' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:A'>
      <xsl:param name='hostname' />
      <xsl:param name='address' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>A</xsl:with-param>
          <xsl:with-param name='value'><xsl:value-of select='$address' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:AAAA'>
      <xsl:param name='hostname' />
      <xsl:param name='address' />

      <xsl:call-template name='DNS:RR'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='type'>AAAA</xsl:with-param>
          <xsl:with-param name='value'><xsl:value-of select='$address' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:Busy'>
      <xsl:param name='hostname' />
      <xsl:param name='user' />
      <xsl:param name='comment' />

      <xsl:call-template name='DNS:TXT'>
          <xsl:with-param name='hostname'>busy.<xsl:value-of select='$hostname' /></xsl:with-param>
          <xsl:with-param name='text' select='$comment' />
      </xsl:call-template>
      <xsl:call-template name='DNS:RP'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='mailbox'><xsl:value-of select='$user' />.redgates.com</xsl:with-param>
          <xsl:with-param name='text'>busy.<xsl:value-of select='$hostname' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='DNS:Reserved'>
      <xsl:param name='hostname' />
      <xsl:param name='user' />
      <xsl:param name='comment' />

      <xsl:call-template name='DNS:TXT'>
          <xsl:with-param name='hostname'>reserved.<xsl:value-of select='$hostname' /></xsl:with-param>
          <xsl:with-param name='text' select='$comment' />
      </xsl:call-template>
      <xsl:call-template name='DNS:RP'>
          <xsl:with-param name='hostname' select='$hostname' />
          <xsl:with-param name='mailbox'><xsl:value-of select='$user' />.redgates.com</xsl:with-param>
          <xsl:with-param name='text'>reserved.<xsl:value-of select='$hostname' /></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
