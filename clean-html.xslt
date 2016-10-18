<?xml version='1.0' ?>
<xsl:stylesheet
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:dc='http://purl.org/dc/elements/1.1/'
    version='1.0'>

    <dc:title>Clean junk from HTML</dc:title>
    <dc:creator>Karl Redgate</dc:creator>
    <dc:description>
        Chrome used to have a "simplify page" option in its print dialog.
        It wasn't perfect, but it was helpful.  This is an attempt to
        do something similar.
    </dc:description>

  <xsl:output method='xml' omit-xml-declaration='yes'/>
  <xsl:strip-space elements='*' />

  <xsl:template match='comment()'></xsl:template>

    <dc:description>
        Get rid of meta elements that do not matter for the redering
        of the actual data.
    </dc:description>
  <xsl:template match='/html/head/meta'></xsl:template>

    <dc:description>Get rid of any Javascript</dc:description>
  <xsl:template match='/html/head/script'></xsl:template>
  <xsl:template match='/html/body//script'></xsl:template>

    <dc:description>Get rid of any CSS links and styles</dc:description>
  <xsl:template match='/html/head/link'></xsl:template>
  <xsl:template match='/html/head/style'></xsl:template>

    <dc:description>
        Eliminate semantic "nav" elements
    </dc:description>
  <xsl:template mode="disabled" match='/html/body//nav'></xsl:template>

    <dc:description>
        Remove structural elements that have no children.
    </dc:description>
  <xsl:template match='span[count(child::text()) = 0 and count(*) = 0]'></xsl:template>
  <xsl:template match='strong[count(child::text()) = 0 and count(*) = 0]'></xsl:template>
  <xsl:template match='a[count(child::text()) = 0 and count(*) = 0]'></xsl:template>
  <xsl:template match='li[count(child::text()) = 0 and count(*) = 0]'></xsl:template>

    <dc:description>
        Get rid of navigation anchors and divs.  MediaWiki navigation starts
        with "mw-".
        Also, get rid of breadcrumb divs
    </dc:description>
  <xsl:template match='a[@data-container = "#navigation"]'></xsl:template>
  <xsl:template match='div[@id = "navigation"]'></xsl:template>
  <xsl:template match='div[@id = "mw-navigation"]'></xsl:template>
  <xsl:template match='div[@id = "breadcrumb-section"]'></xsl:template>

    <dc:description>
        Get rid of hidden fieldsets.
    </dc:description>
  <xsl:template match='fieldset[contains(@class,"hidden")]'></xsl:template>

    <dc:description>
        Get rid of MS aria navigation, menus and contentinfo.
    </dc:description>
  <xsl:template match='*[@role = "navigation"]'></xsl:template>
  <xsl:template match='*[@role = "menu"]'></xsl:template>
  <xsl:template match='*[@role = "contentinfo"]'></xsl:template>

    <dc:description>
        Remove wrapper divs that have only one child.
        This one is more specific that the role one - so it overrides it ?!?
    </dc:description>
<!--
  <xsl:template match='div[count(*) = 1]'>
    <xsl:apply-templates select='*'/>
  </xsl:template>
-->

    <dc:description>
        Add a border to tables.
        This is not supported in HTML5 - so I will be removing it and
        changing to another XSL-FO setup - or perhaps an epub output...
    </dc:description>
  <xsl:template match='table'>
   <xsl:copy>
    <xsl:attribute name='border'>1</xsl:attribute>
    <xsl:apply-templates select='@*|node()'/>
   </xsl:copy>
  </xsl:template>

    <dc:description>
        Remove attributes that are mostly used for Javascript and
        CSS formatting.
    </dc:description>
  <xsl:template match='@onload'></xsl:template>
  <xsl:template match='@style'></xsl:template>
  <xsl:template match='@colspan[. = "1"]'></xsl:template>
  <!--
  <xsl:template match='@class'></xsl:template>
  <xsl:template match='@id'></xsl:template>
  <xsl:template match='@role'></xsl:template>
  -->

  <xsl:template match='@talk-marker'></xsl:template>

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
