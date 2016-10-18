<?xml version='1.0' ?>
<xsl:stylesheet
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:dc='http://purl.org/dc/elements/1.1/'
    version='1.0'>

    <dc:title>Add style sheet to HTML</dc:title>
    <dc:creator>Karl Redgate</dc:creator>
    <dc:description>
        Add dumb simple style sheet
    </dc:description>

  <xsl:output method='xml' omit-xml-declaration='yes'/>

    <dc:description>
    </dc:description>
  <xsl:template match='/html/head'>
   <xsl:copy>
    <xsl:apply-templates select='@*|node()'/>
    <xsl:element name='style'>
        <xsl:attribute name='type'>text/css</xsl:attribute>
        <xsl:text>
span { font-family:"Trebuchet MS", sans-serif; }
li { font-family:"Trebuchet MS", sans-serif; }
        </xsl:text>
    </xsl:element>
   </xsl:copy>
  </xsl:template>

    <dc:description>
        Just copy everything else.
    </dc:description>
  <xsl:template match='@*|node()'>
   <xsl:copy>
    <xsl:apply-templates select='@*|node()'/>
   </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
