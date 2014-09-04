<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="@*|node()">
   <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
  </xsl:template>

  <xsl:template match="cluster">
   <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  <lans>
    <lan id="9308fb0e-a569-42be-9164-6a4d8992318f">
      <address>169.154.0.0/16</address>
    </lan>
    <lan id="011b64aa-173d-44bf-b34b-9ff790f54a27">
      <address>10.83.0.0/16</address>
      <router>10.83.0.1</router>
    </lan>
    <lan id="0d4328a5-9d6e-40c9-8418-8c19d360c58e">
      <address>134.111.24.0/21</address>
    </lan>
    <lan id="d0a9343f-1a74-434b-9754-1c9f6ff9053c">
    </lan>
  </lans>
   </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
