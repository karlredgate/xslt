<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:dr="http://carbonite.com/2014/09/dr"
                version='1.0'>

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <xsl:param name="email" />

  <xsl:template match='dr:Account'>
    <xsl:text>INSERT OR REPLACE INTO Customer (id, email, cloud_certificate) VALUES (</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:AccountID' /><xsl:text>",</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:email' /><xsl:text>",</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:CertificateData' /><xsl:text>"</xsl:text>
    <xsl:text>);</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match='dr:BackupRun'>

    <xsl:text>INSERT OR REPLACE INTO ProtectedHost (name, customer) VALUES (</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:ComputerName' /><xsl:text>",</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='../../dr:AccountID' /><xsl:text>"</xsl:text>
    <xsl:text>);</xsl:text>
    <xsl:text>&#10;</xsl:text>

    <xsl:text>INSERT INTO BackupSet (id, name, host) VALUES (</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:BackupSetId' /><xsl:text>",</xsl:text>
    <xsl:text>"</xsl:text><xsl:value-of select='dr:BackupSetName' /><xsl:text>",</xsl:text>
    <xsl:text>&#10;</xsl:text>

  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4: -->
