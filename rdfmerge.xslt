<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
               xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
               xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
               xmlns:dc="http://purl.org/dc/elements/1.1/"
	       xmlns:dcterms="http://purl.org/dc/terms/"
	       xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	       xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	       xmlns:owl="http://www.w3.org/2002/07/owl#"
               version="1.0">

  <dc:title>Merge two XML/RDF files</dc:title>
  <dc:creator>Karl Redgate</dc:creator>
  <dc:description>
  Merge the child nodes of the root of one XML document into the root
  of the first XML document.
  </dc:description>

  <xsl:param name="filename" />

  <xsl:template match="rdf:RDF" >
    <xsl:copy>
     <xsl:apply-templates />
     <xsl:copy-of select="document($filename)/rdf:RDF/*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:transform>
