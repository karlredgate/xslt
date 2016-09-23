<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:msb="http://schemas.microsoft.com/developer/msbuild/2003"
                version='1.0'>

  <xsl:output method="text"/>

  <dc:title></dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
    Filter a Microsoft build vcxproj file and generate a basic Makefile.
  </dc:description>

  <xsl:template match='text()' />

  <xsl:template match='/'>
      <xsl:text># Generated from vcxproj file&#10;</xsl:text>
      <xsl:apply-templates select='/msb:Project/msb:ItemGroup/msb:ClCompile' />
      <xsl:text>default: build&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select='/msb:Project/msb:PropertyGroup[@Label="Globals"]' />
  </xsl:template>

  <xsl:template match='msb:RootNamespace'>
      <xsl:text>build: </xsl:text>
      <xsl:value-of select='.' /><xsl:text>.exe&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select='.' /><xsl:text>.exe: $(OBJS)&#10;</xsl:text>
      <xsl:text>&#09;$(CXX) -o $@ $(OBJS)&#10;</xsl:text>
  </xsl:template>

  <xsl:template match='/msb:Project/msb:ItemGroup[msb:ClCompile]'>
      <xsl:text>OBJS = &#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match='msb:ItemGroup/msb:ClCompile'>
      <xsl:variable name='basename' select='substring-before(@Include,".")' />
      <xsl:text>OBJS += </xsl:text>
      <xsl:value-of select='$basename' /><xsl:text>.o&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 : -->
