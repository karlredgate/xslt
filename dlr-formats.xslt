<?xml version='1.0' ?>
<xsl:stylesheet
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
              xmlns:xsd='http://www.w3.org/2001/XMLSchema'
              xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
               xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:akamai="uri:akamai.com/metadata/akamai/5.0"
           xmlns:assign="uri:akamai.com/metadata/assign/5.0"
             xmlns:auth="uri:akamai.com/metadata/auth/5.0"
            xmlns:cache="uri:akamai.com/metadata/cache/5.0"
           xmlns:config="uri:akamai.com/metadata/config/5.0"
    xmlns:edgecomputing="uri:akamai.com/metadata/edgecomputing/5.0"
     xmlns:edgeservices="uri:akamai.com/metadata/edgeservices/5.0"
          xmlns:forward="uri:akamai.com/metadata/forward/5.0"
            xmlns:match="uri:akamai.com/metadata/match/5.0"
          xmlns:network="uri:akamai.com/metadata/network/5.0"
        xmlns:reporting="uri:akamai.com/metadata/reporting/5.0"
         xmlns:security="uri:akamai.com/metadata/security/5.0"
              xmlns:mmd="uri:akamai.com/metametadata/1.0"
    version="1.0">

  <dc:title>Extract DLR format strings from metadata</dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
      Read a security pearl file and extract the DLR formats,
      printing one field per line into an output file for each
      template/DLR tuple used for the filename.

      Examples:
      xsltproc --stringparam values 2  \
               dlr-formats.xslt \
               ~/t/sur/security-upcoming-rules.xml
      cat SEC_UPCOMING_RULES_1.0+SEC_DLR_CSI_BEACON_UPCOMING.txt  \
               | sed -e 's/:/    /'
  </dc:description>

  <xsl:param name='values' />
  <xsl:output method="text" />
  <xsl:key name='variables' match='assign:variable' use='name' />

  <xsl:template match='text()' />

  <dc:description>
      Call the recursive format splitter template for a variable value.
      This should only get called for variables that are used in the
      DLR format element.
  </dc:description>
  <xsl:template match="assign:variable" mode="found">
      <xsl:call-template name='fields'>
          <xsl:with-param name='format' select='value' />
      </xsl:call-template>
  </xsl:template>

  <dc:description>
      Match all format elements to extract the DLR format values.
      This is less specific than the next template, so the next template
      overrides this template.
  </dc:description>
  <xsl:template match="reporting:edge-logging.send-receipt/format | reporting:edge-logging/send-receipt/format">
      <xsl:variable name='templateName' select='ancestor::akamai:template/@name' />
      <xsl:variable name='filename' select='concat($templateName,"+",../@name,".txt")' />
      <xsl:text># </xsl:text>
      <xsl:value-of select="$filename" />
      <xsl:text>&#10;</xsl:text>
      <xsl:document encoding="UTF-8" method="text" href='{$filename}'>
          <xsl:call-template name='fields'>
              <xsl:with-param name='format' select='.' />
          </xsl:call-template>
      </xsl:document>
  </xsl:template>

  <dc:description>
      Override the more generic template above, for format elements that
      contain a variable dereference.  In this case we need to hunt down
      the variable setting to get the real value to print.
      The match pattern here finds format elements as a child of both forms
      of send-receipt - either as part of the element or as a child element.
  </dc:description>
  <xsl:template match="reporting:edge-logging.send-receipt/format[starts-with(.,'%')] |
                       reporting:edge-logging/send-receipt/format[starts-with(.,'%')]">
      <xsl:variable name='templateName' select='ancestor::akamai:template/@name' />
      <xsl:variable name='filename' select='concat($templateName,"+",../@name,".txt")' />
      <xsl:variable name='varName' select='substring-before(substring-after(.,"%("),")")' />
      <xsl:text># </xsl:text>
      <xsl:value-of select="$filename" />
      <xsl:text>&#10;</xsl:text>
      <!-- <xsl:apply-templates select="//assign:variable[name=$varName]" mode="found" /> -->
      <xsl:document encoding="UTF-8" method="text" href='{$filename}'>
          <xsl:apply-templates select='key("variables",$varName)' mode="found" />
      </xsl:document>
  </xsl:template>

  <dc:description>
      Recursive template.
      Processes a list of &amp; separated values and prints them one
      per line.  The first choose chunk looks for the &amp; and prints
      the left most field name, then calls this same template again for
      the rest of the list.
  </dc:description>
  <xsl:template name='fields'>
      <xsl:param name='format' />
      <xsl:choose>
          <xsl:when test='contains($format,"&amp;")'>
              <xsl:call-template name='field-name'>
                  <xsl:with-param name='format' select='substring-before($format,"&amp;")' />
              </xsl:call-template>
              <xsl:call-template name='fields'>
                  <xsl:with-param name='format' select='substring-after($format,"&amp;")' />
              </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
              <xsl:call-template name='field-name'>
                  <xsl:with-param name='format' select='$format' />
              </xsl:call-template>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <dc:description>
      Callable template.  This prints info about the field name
      and value.  If the field is really a variable reference,
      pull the value from that variable and process it like it
      was inline.
  </dc:description>
  <xsl:template name='field-name'>
      <xsl:param name='format' />
      <xsl:variable name='varName'
          select='substring-before(substring-after($format,"%("),")")' />
      <xsl:choose>
          <xsl:when test='starts-with($format,"%")'>
              <!-- this is a var ref - not a field name -->
              <xsl:text># dereference variable </xsl:text>
              <xsl:value-of select='$varName' />
              <xsl:text>&#10;</xsl:text>
              <xsl:call-template name='fields'>
                  <xsl:with-param name='format'
                      select='key("variables",$varName)/value' />
              </xsl:call-template>
              <xsl:text># done with </xsl:text>
              <xsl:value-of select='$varName' />
              <xsl:text>&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$values = "2"'>
              <xsl:value-of select='substring-before($format,"=")' />
              <xsl:text>:</xsl:text>
              <xsl:call-template name='field-value'>
                  <xsl:with-param name='value'
                      select='substring-after($format,"=")' />
              </xsl:call-template>
          </xsl:when>
          <xsl:when test='$values = "1"'>
              <xsl:value-of select='$format' />
              <xsl:text>&#10;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select='substring-before($format,"=")' />
              <xsl:text>&#10;</xsl:text>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <dc:description>
      Translate the value in the field to a descriptive string.
      There are some undocumented values.
      This is just a start ...
  </dc:description>
  <xsl:template name='field-value'>
      <xsl:param name='value' />
      <xsl:choose>
          <xsl:when test='$value = ""'>
              <xsl:text>EMPTY&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%d"'>
              <xsl:text>download time in ms (%d)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%D"'>
              <xsl:text>download time DDHHMMSS (%d)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%G"'>
              <xsl:text>edge server IP address&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%h"'>
              <xsl:text>origin server name&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%H"'>
              <xsl:text>HTTP status code&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%i"'>
              <xsl:text>client IP address&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%I"'>
              <!-- <xsl:text>object content-length&#10;</xsl:text> -->
              <xsl:text>request ID (%I)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%k"'>
              <xsl:text>receipt version from send-receipt.version (%k)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%K"'>
              <xsl:text>Set cookie values (%K)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%p"'>
              <xsl:text>Request URL path (%p)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%P"'>
              <xsl:text>Customer CPcode&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%q"'>
              <xsl:text>Request URL query string&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%s"'>
              <xsl:text>content bytes served (%s)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%S"'>
              <xsl:text>serial number&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%t"'>
              <xsl:text>start timestamp for request&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%0t"'>
              <xsl:text>start timestamp for request&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%1t"'>
              <xsl:text>start timestamp (1/10) for request&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%2t"'>
              <xsl:text>start timestamp (1/100) for request&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%3t"'>
              <xsl:text>start timestamp (1/1000) for request&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%u"'>
              <xsl:text>Request URL (path+query)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%U"'>
              <xsl:text>Request UUID (%U)&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%w"'>
              <xsl:text>Win32 status code&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%x"'>
              <xsl:text>API id&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='$value = "%z"'>
              <xsl:text>client port number&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='starts-with($value,"%(AK_")'>
              <xsl:text>Ghost variable: </xsl:text>
              <xsl:value-of select='$value' />
              <xsl:text>&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='starts-with($value,"%(")'>
              <xsl:text>Variable: </xsl:text>
              <xsl:value-of select='$value' />
              <xsl:text>&#10;</xsl:text>
          </xsl:when>
          <xsl:when test='starts-with($value,"%")'>
              <xsl:text>Unknown field  </xsl:text>
              <xsl:value-of select='$value' />
              <xsl:text>&#10;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
              <xsl:text>Static value: </xsl:text>
              <xsl:value-of select='$value' />
              <xsl:text>&#10;</xsl:text>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
