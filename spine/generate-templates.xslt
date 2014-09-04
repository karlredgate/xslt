<?xml version='1.0' ?>
<!-- $Id: generate-templates.xslt 18366 2007-09-06 00:25:05Z cboumeno $ -->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                version='1.0'>

  <xsl:template match='/'>

    <xsl:for-each select='comps/grouphierarchy/category[name="Servers"]/subcategories/subcategory'>
      <xsl:variable name='category' select='.' />
      <xsl:variable name='category_id' select='generate-id()'/>
      <xsl:document href="templates/{$category}.template"><template id="{$category_id}">
        <xsl:for-each select='/comps/group[id=$category]'>
          <name><xsl:value-of select='id' /></name>
          <description><xsl:value-of select='name' /></description>
          <xsl:element name='repository'>
            <xsl:attribute name='ref'><xsl:value-of select='$repo'/></xsl:attribute>
          </xsl:element>
          <console>unavailable</console>
          <transition>loading</transition>
          <requirements>
            <storage unit="MB">4000</storage>
          </requirements>
        </xsl:for-each>
      </template>
      </xsl:document>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
