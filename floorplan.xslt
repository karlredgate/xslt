<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version='1.0'>

  <dc:title>Generate a floorplan of VMs for fttest from spine topology</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
This transform reads a topology xml from spine - either live or from a probcopy
and generates a perl hash that fttest can consume to create a test that replicates
a customer configuration.

Currently this is limited to Windows configurations, since the Linux VMs use a 
template reference which points to the spine repository report - which is not
part of topology and is not gathered in a probcopy.
  </dc:description>

  <xsl:key name='region' match='/cluster/storage/region' use='@id' />
  <xsl:key name='network' match='/cluster/networks/network' use='@id' />
  <xsl:key name='interface' match='/cluster/systems/system/networks/interface' use='@id' />

  <xsl:output method="text"/>
  <xsl:template match='text()' />
  <xsl:template match='*' />

  <dc:description>
  Wrap the outer has configuration around processing the internal xml elements
  that make up the VM configuration.
  </dc:description>
  <xsl:template match='/cluster'>
      <xsl:text>{ # Vm Configuration Information (DUT::Vm::Cfg)&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Wrap hash around the list of VMs.
  </dc:description>
  <xsl:template match='guests'>
      <xsl:text>    vms => {&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>    }&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Generate the hash for the base config of the VM.  After processing the base
  config, apply the other templates to the elements contained in the guest 
  config for the virtual volumes and interfaces.
  </dc:description>
  <xsl:template match='guest'>
      <xsl:text>        </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text> => {&#10;</xsl:text>
      <xsl:text>            name => '</xsl:text><xsl:value-of select='name' /><xsl:text>',&#10;</xsl:text>
      <xsl:text>            cpu => </xsl:text>
          <xsl:value-of select='vcpus' />
      <xsl:text>,              # Number of processors&#10;</xsl:text>
      <xsl:text>            memory => </xsl:text>
          <xsl:value-of select='memory' />
      <xsl:text>,          # Memory Size&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>        },&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Use the os/distro information in topology to generate type and template information.
  </dc:description>
  <xsl:template match='os[distro]'>
      <xsl:text>            type => '</xsl:text>
          <xsl:value-of select='distro' />
      <xsl:text>',     # Type&#10;</xsl:text>
      <xsl:text>            flavor => '</xsl:text><xsl:value-of select='name' /><xsl:text>',&#10;</xsl:text>
      <xsl:choose>
      <xsl:when test='string(name) = "Microsoft Windows Server 2003 R2 Standard Edition"'>
          <xsl:text>            template => 'win2k3_R2_x86_32_SP2',&#10;</xsl:text>
      </xsl:when>
      <xsl:when test='string(name) = "Microsoft Windows Server 2003 R2 Enterprise Edition"'>
          <xsl:text>            template => 'win2k3_R2_x86_32_SP2',&#10;</xsl:text>
      </xsl:when>
      <xsl:when test='string(name) = "Microsoft Windows Server 2003 R2 Enterprise x64 Edition"'>
          <xsl:text>            template => 'win2k3_R2_x86_64_SP2',&#10;</xsl:text>
      </xsl:when>
      </xsl:choose>
  </xsl:template>

  <dc:description>
  Use the PV driver version detected in  topology to generate the name of the
  PV driver cdrom to use.
  </dc:description>
  <xsl:template match='pv_drivers[installed="true"]'>
      <xsl:text>            pvDrivers => </xsl:text>
      <xsl:text>'xen-win-pv-drivers-</xsl:text>
      <xsl:value-of select='version/@major' />
      <xsl:text>.</xsl:text>
      <xsl:value-of select='version/@minor' />
      <xsl:text>.0',</xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Wrap the list of virtual interfaces in a hash.
  </dc:description>
  <xsl:template match='interfaces'>
      <xsl:text>            network => {&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>            },&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Process the individual virtual interface.  Currently this only contains
  the interface index and the network it is connected to.
  </dc:description>
  <xsl:template match='interface'>
      <xsl:variable name='index' select='position()-1' />

      <xsl:text>                </xsl:text>
      <xsl:for-each select='key("network",network/@ref)'>
          <xsl:value-of select='name' />
      </xsl:for-each>
      <xsl:text> => { # Network Configuration Information (DUT::Vm::Network)&#10;</xsl:text>
          <xsl:text>                    index => </xsl:text>
          <xsl:value-of select='$index' />
          <xsl:text>,&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>                },&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Wrap the list of virtual volumes in a hash.
  </dc:description>
  <xsl:template match='volumes'>
      <xsl:text>            volume => {&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>            },&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  Process the individual virtual volume element, and generate a hash for its
  configuration.
  </dc:description>
  <xsl:template match='volume'>
      <xsl:variable name='region_id' select='storage/@ref' />
      <xsl:variable name='index' select='position()-1' />

      <xsl:for-each select='key("region",storage/@ref)'>
          <xsl:text>                '</xsl:text>
          <xsl:value-of select='name' />
          <xsl:text>' => { # Volume Configuration Information (DUT::Vm::Volume)&#10;</xsl:text>
          <xsl:text>                    name => '</xsl:text>
          <xsl:value-of select='name' />
          <xsl:text>',&#10;</xsl:text>
          <xsl:text>                    size => </xsl:text>
          <xsl:value-of select='capacity' />
          <xsl:text>,&#10;</xsl:text>
          <xsl:text>                    index => </xsl:text>
          <xsl:value-of select='$index' />
          <xsl:text>,&#10;</xsl:text>
          <xsl:text>                },&#10;</xsl:text>
      </xsl:for-each>

  </xsl:template>

  <dc:description>
  This is a utility template, copied from another transform - not currently used.
  </dc:description>
  <xsl:template name='left-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:value-of select='$node' />
      <xsl:call-template name='pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
  </xsl:template>

  <dc:description>
  This is a utility template, copied from another transform - not currently used.
  </dc:description>
  <xsl:template name='right-aligned'>
      <xsl:param name='node' />
      <xsl:param name='width' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:call-template name='pad'>
          <xsl:with-param name='count' select='$width - string-length($node)' />
          <xsl:with-param name='fill' select='$fill' />
      </xsl:call-template>
      <xsl:value-of select='$node' />
  </xsl:template>

  <dc:description>
  This is a utility template, copied from another transform - not currently used.
  </dc:description>
  <xsl:template name='pad'>
      <xsl:param name='count' />
      <xsl:param name='fill' as='xs:string'> </xsl:param>
      <xsl:choose>
      <xsl:when test="$count &lt; 1"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='pad'>
            <xsl:with-param name="count" select='$count - 1' />
            <xsl:with-param name='fill' select='$fill' />
        </xsl:call-template>
        <xsl:value-of select='$fill' />
      </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
