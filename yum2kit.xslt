<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc='http://purl.org/dc/elements/1.1/'
                xmlns:yum="http://linux.duke.edu/metadata/common"
                xmlns:rpm="http://linux.duke.edu/metadata/rpm"
                version='1.0'>

  <dc:title>Translate yum packages XML to Unity kit information.</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  So far this only generates the manifest part of the kit info, but
  can easily be extended to provide exactly what smd/cms needs.
  (Although CMS should go away ...)

  This is currently using the sha256 hashes, but the repo can be generated
  with md5 hashes if it is necessary to do it that way.

  Run this as: 
  xsltproc yum2kit.xslt 436f39b656f8fa55ce5c8386cacf3ef6-primary.xml.gz
  </dc:description>

  <xsl:output method="xml"/>
  <xsl:template match='text()' />

  <dc:description>
  Match the root of the yum primary.xml and wrap it in Unity kit elements.
  </dc:description>
  <xsl:template match='/yum:metadata'>
      <manifest>
      <components>
         <xsl:apply-templates />
      </components>
      </manifest>
  </xsl:template>

  <dc:description>
  For each RPM in the primary generate a component element for the Unity kit
  manifest.  All components are considered 'required'.
  </dc:description>
  <xsl:template match='yum:package'>
    <component path='{yum:location/@href}' sum='{yum:checksum}' type='required' />
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
