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

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/story'>
      <xsl:value-of select='id' />
      <xsl:text>  </xsl:text>
      <xsl:value-of select='story_type' />
      <xsl:text>  </xsl:text>
      <xsl:value-of select='current_state' />
      <xsl:text>  </xsl:text>
      <xsl:value-of select='owned_by' />
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>----------------------------------------------------------&#10;</xsl:text>
      <xsl:value-of select='description' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='notes'>
      <xsl:text>----------------------------------------------------------&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='note'>
      <xsl:text> === Comment (</xsl:text>
      <xsl:value-of select='author' />
      <xsl:text>    </xsl:text>
      <xsl:value-of select='noted_at' />
      <xsl:text>)&#10;</xsl:text>
      <xsl:value-of select='text' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='tasks'>
      <xsl:text>----------------------------------------------------------&#10;</xsl:text>
      <xsl:for-each select='task'>
          <xsl:sort select='position' />
          <xsl:apply-templates select="." />
      </xsl:for-each>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='task'>
      <xsl:choose>
      <xsl:when test='complete = "true"'>Task complete</xsl:when>
      <xsl:otherwise>Task INCOMPLETE</xsl:otherwise>
      </xsl:choose>

      <xsl:text>&#10;</xsl:text>
      <xsl:text>    </xsl:text>
      <xsl:value-of select='description' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
