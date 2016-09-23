<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://redgates.com/xslt/DNS'
                xmlns:IPv6='http://redgates.com/xslt/IPv6'
                xmlns:util='http://redgates.com/xslt/utils'
                version='1.0'>

  <dc:title>Generate DHCP configuration files for each subnet</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Given a flat XML file for each host/IPv4 address combination, generate a dhcp
configuration file that assigns a fixed IPv4 address to the MAC address.  Input
to this transform is generated by the <filename>concat-hosts.xslt</filename>
transform.
  </dc:description>

  <!-- replace the default transform for text elements to print nothing, since we
       want to only generate the exact output text we specify in these transforms. -->
  <xsl:template match='text()' />

  <xsl:key name='subnet' match='domain' use='concat(address/a,address/b)' />

  <xsl:template match='list'>

      <xsl:for-each select='domain[count(. | key("subnet", concat(address/a,address/b))[1]) = 1]'>
          <xsl:document encoding="UTF-8" method="text"
                        href='{concat(address/a,"-",address/b,".hosts")}'>

              <xsl:for-each select='key("subnet", concat(address/a,address/b))'>
                  <xsl:sort select='address/c' data-type='number' />

                  <xsl:variable name='vlan-name'>
                      <xsl:choose>
                      <xsl:when test='address/b = "80"'>NET-80-Blue</xsl:when>
                      <xsl:when test='address/b = "81"'>NET-81-Red</xsl:when>
                      <xsl:when test='address/b = "82"'>NET-82-Yellow</xsl:when>
                      <xsl:when test='address/b = "83"'>NET-83-Green</xsl:when>
                      <xsl:when test='address/b = "84"'>NET-84-Orange</xsl:when>
                      <xsl:when test='address/b = "85"'>NET-85-Purple</xsl:when>
                      <xsl:when test='address/b = "86"'>NET-86-Black</xsl:when>
                      <xsl:when test='address/b = "87"'>NET-87-White</xsl:when>
                      <xsl:when test='address/b = "88"'>NET-88-Brown</xsl:when>
                      <xsl:when test='address/b = "89"'>NET-89-Grey</xsl:when>
                      <xsl:when test='address/b = "90"'>NET-90-Tan</xsl:when>
                      <xsl:when test='address/b = "91"'>NET-91-Aqua</xsl:when>
                      <xsl:when test='address/b = "92"'>NET-92-Pink</xsl:when>
                      <xsl:when test='address/b = "93"'>NET-93-Pearl</xsl:when>
                      <xsl:when test='address/b = "94"'>NET-94-Peach</xsl:when>
                      <xsl:when test='address/b = "95"'>NET-95</xsl:when>
                      <xsl:otherwise>NET-24</xsl:otherwise>
                      </xsl:choose>
                  </xsl:variable>

                  <xsl:variable name='pxemac'>
                      <xsl:choose>
                      <xsl:when test='pxeboot'><xsl:value-of select='pxeboot' /></xsl:when>
                      <xsl:when test='mac'><xsl:value-of select='mac' /></xsl:when>
                      </xsl:choose>
                  </xsl:variable>

                  <xsl:if test='$pxemac != ""'>
                  <xsl:text>host </xsl:text>
                  <xsl:value-of select='$vlan-name' />
                  <xsl:text>.</xsl:text>
                  <xsl:value-of select='name' />
                  <xsl:text> {&#10;</xsl:text>

                  <xsl:text>    hardware ethernet </xsl:text>
                  <xsl:value-of select='$pxemac' />
                  <xsl:text> ;&#10;</xsl:text>

                  <xsl:text>    fixed-address </xsl:text>
                  <xsl:value-of select='concat(address/a,".",address/b,".",address/c,".",address/d)' />
                  <xsl:text> ;&#10;</xsl:text>

                  <xsl:text>    if ((exists user-class) and (option user-class = "</xsl:text>
                      <xsl:choose>
                      <xsl:when test='bootloader'><xsl:value-of select='bootloader' /></xsl:when>
                      <xsl:otherwise><xsl:text>gPXE</xsl:text></xsl:otherwise>
                      </xsl:choose>
                  <xsl:text>")) {&#10;</xsl:text>
                  <xsl:text>filename "gpxe.cfg/</xsl:text><xsl:value-of select='name'/><xsl:text>";&#10;</xsl:text>
                  <xsl:text>    } else {&#10;</xsl:text>
                  <xsl:text>filename "gpxeloader/</xsl:text><xsl:value-of select='name'/><xsl:text>";&#10;</xsl:text>
                  <xsl:text>    }&#10;</xsl:text>

                  <xsl:text>}&#10;</xsl:text>
                  </xsl:if>

              </xsl:for-each>

          </xsl:document>
      </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
