<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
                version='1.0'>

  <xsl:output method="text"/>

  <dc:title></dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Print bug history is easy ASCII output.
  </dc:description>

  <xsl:param name='token' />

  <xsl:template match='text()' />

  <xsl:template match='/response'><xsl:apply-templates /></xsl:template>
  <xsl:template match='cases'><xsl:apply-templates /></xsl:template>
  <xsl:template match='events'><xsl:apply-templates /></xsl:template>

  <xsl:template match='case'>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:value-of select='@ixBug' />
      <xsl:text>: </xsl:text>
      <xsl:value-of select='sTitle' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text> AssignedTo: </xsl:text>
      <xsl:value-of select='sPersonAssignedTo' />
      <xsl:text>   </xsl:text>
      <xsl:value-of select='sProject' />
      <xsl:text> / </xsl:text>
      <xsl:value-of select='sArea' />
      <xsl:text>   </xsl:text>
      <xsl:value-of select='sPriority' />
      <xsl:text>(</xsl:text>
      <xsl:value-of select='ixPriority' />
      <xsl:text>) </xsl:text>
      <xsl:value-of select='sFixFor' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text> Opened: </xsl:text>
      <xsl:value-of select='dtOpened' />
      <xsl:text>  Related: </xsl:text>
      <xsl:value-of select='ixRelatedBugs' />
      <xsl:text>   </xsl:text>
      <xsl:value-of select='c' />
      <xsl:text> occurances</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='events'><xsl:apply-templates /></xsl:template>

  <xsl:template match='event'>
      <xsl:text>&#10;</xsl:text>
      <xsl:text> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -&#10;</xsl:text>
      <xsl:text> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -&#10;</xsl:text>
      <xsl:text> (</xsl:text>
      <xsl:value-of select='ixBugEvent' />
      <xsl:text>)  -- </xsl:text>
      <xsl:value-of select='evtDescription' />
      <xsl:text> -- </xsl:text>
      <xsl:value-of select='dt' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='sChanges'>
      <xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match='s'>
      <xsl:value-of select='.' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match='rgAttachments/attachment'>
      <xsl:variable name='atturi' select='sURL' />
      <xsl:variable name='auri' select='concat("http://bugs.sn.stratus.com/",$atturi,"&amp;token=",$token)' />
      <xsl:text>   Attachement: </xsl:text>
      <xsl:value-of select='sFileName' />
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select='$auri' />
  </xsl:template>

</xsl:stylesheet>
