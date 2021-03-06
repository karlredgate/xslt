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

  <xsl:import href="dns.xslt"/>

  <dc:title>Generate reverse zone files for each subnet</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
Given a flat XML file for each host/IPv4 address combination, generate reverse
zone files for each subnet, ordered by address.  Input to this transform is
generated by the <filename>concat-hosts.xslt</filename> transform.

Each subnet is put into a separate file.  To do this the first domain in the 
list that uses a unique subnet is added to a list of unique subnets and then
that is iterated over to generate each file.
We use a (I forget the name) transform to accomplish this, since XSLT does
not provide an easy way to just list unique keys from an XML source file.

The contents of the <quote>xsl:document</quote> element below is what creates
the output file.  The <quote>href</quote> attribute generates the filename.
  </dc:description>

  <!-- replace the default transform for text elements to print nothing, since we
       want to only generate the exact output text we specify in these transforms. -->
  <xsl:template match='text()' />

  <xsl:key name='subnet' match='domain' use='concat(address/a,address/b,address/c)' />

  <xsl:template match='list'>

      <xsl:for-each select='domain[count(. | key("subnet", concat(address/a,address/b,address/c))[1]) = 1]'>
          <xsl:document encoding="UTF-8" method="text"
                        href='{concat(address/c,"-",address/b,"-",address/a,".zone")}'>

              <xsl:for-each select='key("subnet", concat(address/a,address/b,address/c))'>
                  <xsl:sort select='address/d' data-type='number' />

                  <xsl:if test='@reverse = "true"'>

                  <xsl:call-template name='DNS:PTR'>
                    <xsl:with-param name='hostname' select='address/d' />
                    <xsl:with-param name='target'>
                        <xsl:value-of select='name' />
                        <xsl:text>.sn.redgates.com.</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>

                  </xsl:if>

              </xsl:for-each>

          </xsl:document>
      </xsl:for-each>

      <xsl:document encoding="UTF-8" method="text"
                        href='lab.data'>

      <xsl:for-each select='domain[address/a=10]'>

          <xsl:if test='@reverse = "true"'>

          <xsl:call-template name='DNS:PTR'>
              <xsl:with-param name='hostname' select='concat(address/d,".",address/c,".",address/b)' />
              <xsl:with-param name='target'>
                  <xsl:value-of select='name' />
                  <xsl:text>.sn.redgates.com.</xsl:text>
              </xsl:with-param>
          </xsl:call-template>

          </xsl:if>

      </xsl:for-each>

      </xsl:document>

  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
