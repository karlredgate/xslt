<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xs='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:exslt="http://exslt.org/common"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:IPv6='http://redgates.com/xslt/IPv6'
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <xsl:import href="utils.xslt"/>

  <dc:title>Template library for IPv6 address formats</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Some IPv6 addresses have fixed formats based on the MAC address of the ethernet
device that is configured with the address.  These templates create these
formatted addresses.
  </dc:description>

  <xsl:template name='IPv6:lladdr'>
      <xsl:param name='mac' />
      <xsl:text>FE80::</xsl:text>
      <xsl:call-template name='IPv6:eui64'>
        <xsl:with-param name='mac' select='$mac' />
      </xsl:call-template>
  </xsl:template>

  <xsl:template name='IPv6:eui64-suffix'>
      <xsl:param name='net' />
      <xsl:param name='mac' />
      <xsl:value-of select='$net' />
      <xsl:call-template name='IPv6:eui64'>
        <xsl:with-param name='mac' select='$mac' />
      </xsl:call-template>
  </xsl:template>

  <dc:description>
The EUI-64 format is defined by the IEEE.  It splits the MAC address into 2, 3 octet
chunks, and inserts the octet pair FF:FE in between.  Then the locally administered
bit of the most significant octet is inverted.

If you are wondering why this is done. The answer lies buried in section
2.5.1 of RFC 2373:

The motivation for inverting the "u" bit when forming the interface
identifier is to make it easy for system administrators to hand configure
local scope identifiers when hardware tokens are not available. This
is expected to be case for serial links, tunnel end-points, etc. The
alternative would have been for these to be of the form 0200:0:0:1,
0200:0:0:2, etc., instead of the much simpler ::1, ::2, etc.
  </dc:description>

  <xsl:template name='IPv6:eui64'>
      <xsl:param name='mac' />
      <xsl:variable name='nybble2' select='substring($mac,2,1)' />
      <xsl:value-of select='substring($mac,1,1)' />
      <xsl:value-of select='translate($nybble2,"0123456789ABCDEFabcdef","23016745AB89EFCD89EFCD")' />
      <xsl:value-of select='substring($mac,4,2)' />
      <xsl:text>:</xsl:text>
      <xsl:value-of select='substring($mac,7,2)' />
      <xsl:text>FF:FE</xsl:text>
      <xsl:value-of select='substring($mac,10,2)' />
      <xsl:text>:</xsl:text>
      <xsl:value-of select='substring($mac,13,2)' />
      <xsl:value-of select='substring($mac,16,2)' />
  </xsl:template>

  <dc:description>
The address segmentation templates parse the text representation of an
IPv6 address and expand it into a fully specified address.  This is
done by splitting the address into segments delineated by the
<quote>:</quote> character.  The <quote>glob</quote> part of the
address is expanded into multiple segments based on the number of
explicit segments.
  </dc:description>

  <dc:description>
The segment-address template parses the text representation of the
IPv6 address into its constituent segments and generates a result
document fragment which then must be processed by further templates.
  </dc:description>
  <xsl:template name='IPv6:segment-address'>
      <xsl:param name='address' required='yes' />
      <xsl:param name='globseen' as='xs:boolean' select='false' />

      <xsl:variable name='car' select='substring-before($address,":")' />
      <xsl:variable name='cdr' select='substring-after($address,":")' />

      <xsl:if test='contains(substring-after($address,"::"),"::")'>
          <xsl:message terminate='yes'>IPv6 address may only have one "::" field: <xsl:value-of select='$address' /></xsl:message>
      </xsl:if>

      <xsl:choose>
      <xsl:when test='starts-with($address,":")'>
          <xsl:if test='$globseen = "true"'>
              <xsl:message terminate='yes'>Invalid IPv6 address</xsl:message>
          </xsl:if>
          <xsl:element name='segments' />
          <xsl:call-template name='IPv6:segment-address'>
             <xsl:with-param name='address' select='substring($address,2)' />
             <xsl:with-param name='globseen' as='xs:boolean' select='true' />
          </xsl:call-template>
      </xsl:when>
      <xsl:when test='contains($address,":")'>
          <xsl:element name='segment'>
            <xsl:call-template name='util:right-aligned'>
               <xsl:with-param name='node'  select='$car' />
               <xsl:with-param name='width' select='4' />
               <xsl:with-param name='fill'  select='0' />
            </xsl:call-template>
          </xsl:element>

          <xsl:call-template name='IPv6:segment-address'>
             <xsl:with-param name='address' select='$cdr' />
             <xsl:with-param name='globseen' as='as:boolean' select='$globseen' />
          </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
          <xsl:element name='segment'>
            <xsl:call-template name='util:right-aligned'>
               <xsl:with-param name='node'  select='$address' />
               <xsl:with-param name='width' select='4' />
               <xsl:with-param name='fill'  select='0' />
            </xsl:call-template>
          </xsl:element>
      </xsl:otherwise>
      </xsl:choose>

  </xsl:template>

  <dc:description>
The glob-segment template is a recursive template that generates
the segments of 0s that fill the glob part of an IPv6 address.
  </dc:description>
  <xsl:template name='IPv6:glob-segment'>
      <xsl:param name='count' required='yes' />
      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
          <xsl:element name='segment'>0000</xsl:element>
          <xsl:call-template name='IPv6:glob-segment'>
             <xsl:with-param name='count'  select='$count - 1' />
          </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <dc:description>
The expand-segments template translates the output of the segment-address
template to a fully specified address by applying templates to the 
consituent pieces.  The templates that are applied only run in 
<quote>expand-segments</quote> mode.
  </dc:description>
  <xsl:template name='IPv6:expand-segments'>
      <xsl:param name='address' required='yes' />
      <xsl:variable name='segments' select='count(exslt:node-set($address)//segment)' />
      <xsl:apply-templates select='exslt:node-set($address)' mode='expand-segments'>
         <xsl:with-param name='segments'  select='$segments' />
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match='segment' mode='expand-segments'>
      <xsl:copy-of select='.' />
  </xsl:template>

  <xsl:template match='segments' mode='expand-segments'>
      <xsl:param name='segments' required='yes' />
      <xsl:call-template name='IPv6:glob-segment'>
         <xsl:with-param name='count'  select='8 - $segments' />
      </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
