<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                version="1.0">

  <dc:title>Rename NICs to new naming scheme.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="@*|node()">
   <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="priv0"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">e7d9ab1f-2e6d-438c-b4e5-206719afdbce</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="ibiz0"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">d20f48b9-2dc7-4e53-ba60-194f8b62dc3e</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="ibiz1"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">1b4d8370-251f-4bce-89a6-0d8423167cf5</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="ibiz2"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">3603cf9b-65a1-4eb7-b814-d23f09ca685e</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="ibiz3"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">197d85ac-f607-4438-b1e2-b359d4a6fc01</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface[name="ibiz4"]'>
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="lan">
         <xsl:attribute name="ref">c0697d1b-4a83-452e-ad8f-90c671b34ae5</xsl:attribute>
     </xsl:element>
     </xsl:copy>
  </xsl:template>

  <xsl:template match='system/networks/interface/name'>
      <xsl:choose>
      <xsl:when test='. = "priv0"'><name>eth_s0_0</name></xsl:when>
      <xsl:when test='. = "ibiz0"'><name>eth_s0_1</name></xsl:when>
      <xsl:when test='. = "ibiz1"'><name>eth_s1_0</name></xsl:when>
      <xsl:when test='. = "ibiz2"'><name>eth_s1_1</name></xsl:when>
      <xsl:when test='. = "ibiz3"'><name>eth_s3_0</name></xsl:when>
      <xsl:when test='. = "ibiz4"'><name>eth_s3_1</name></xsl:when>
      <xsl:otherwise>
          <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match='system/devices/port/device'>
      <xsl:choose>
      <xsl:when test='. = "priv0"'><name>eth_s0_0</name></xsl:when>
      <xsl:when test='. = "ibiz0"'><name>eth_s0_1</name></xsl:when>
      <xsl:when test='. = "ibiz1"'><name>eth_s1_0</name></xsl:when>
      <xsl:when test='. = "ibiz2"'><name>eth_s1_1</name></xsl:when>
      <xsl:when test='. = "ibiz3"'><name>eth_s3_0</name></xsl:when>
      <xsl:when test='. = "ibiz4"'><name>eth_s3_1</name></xsl:when>
      <xsl:otherwise>
          <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match='/cluster'>
     <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
         <xsl:element name="lans">
           <xsl:element name="lan">
               <xsl:attribute name="id">e7d9ab1f-2e6d-438c-b4e5-206719afdbce</xsl:attribute>
           </xsl:element>
           <xsl:element name="lan">
               <xsl:attribute name="id">d20f48b9-2dc7-4e53-ba60-194f8b62dc3e</xsl:attribute>
           </xsl:element>
           <xsl:element name="lan">
               <xsl:attribute name="id">1b4d8370-251f-4bce-89a6-0d8423167cf5</xsl:attribute>
           </xsl:element>
           <xsl:element name="lan">
               <xsl:attribute name="id">3603cf9b-65a1-4eb7-b814-d23f09ca685e</xsl:attribute>
           </xsl:element>
           <xsl:element name="lan">
               <xsl:attribute name="id">197d85ac-f607-4438-b1e2-b359d4a6fc01</xsl:attribute>
           </xsl:element>
           <xsl:element name="lan">
               <xsl:attribute name="id">c0697d1b-4a83-452e-ad8f-90c671b34ae5</xsl:attribute>
           </xsl:element>
         </xsl:element>
     </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
