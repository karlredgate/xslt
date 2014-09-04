<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                version="1.0">

  <dc:title>Connect NICs to a LAN segment.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:output method="xml" />

  <xsl:param name="config" />
  <xsl:variable name="data" select='document($config)' />

  <xsl:template match="@*|node()">
   <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
  </xsl:template>

  <xsl:template match='systems/system[name="node0"]/devices'>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:apply-templates select='$data/config/node0/card' />
     <xsl:apply-templates select='$data/config/node0/port' />
   </xsl:copy>
  </xsl:template>

  <xsl:template match='systems/system[name="node1"]/devices'>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:apply-templates select='$data/config/node1/card' />
     <xsl:apply-templates select='$data/config/node1/port' />
   </xsl:copy>
  </xsl:template>

  <xsl:template match='systems/system[name="node0"]/networks'>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:apply-templates select='$data/config/node0/interface' />
   </xsl:copy>
  </xsl:template>

  <xsl:template match='systems/system[name="node1"]/networks'>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:apply-templates select='$data/config/node1/interface' />
   </xsl:copy>
  </xsl:template>

  <xsl:template match='lans'>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:apply-templates select='$data/config/lan' />
   </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
<!--
 vim:autoindent
 vim:syntax=plain
 -->
