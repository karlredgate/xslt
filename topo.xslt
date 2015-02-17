<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://svn.sn.stratus.com/storbitz/DNS'
                xmlns:IPv6='http://svn.sn.stratus.com/storbitz/IPv6'
                xmlns:util='http://svn.sn.stratus.com/storbitz/utils'
                version='1.0'>

  <dc:title>Generate a nice report of the VMs on a DUT</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  </dc:description>

  <xsl:key name='region' match='/cluster/storage/region' use='@id' />
  <xsl:key name='lan' match='/cluster/lans/lan' use='@id' />
  <xsl:key name='network' match='/cluster/networks/network' use='@id' />
  <xsl:key name='interface' match='/cluster/systems/system/networks/interface' use='@id' />
  <xsl:key name='device' match='/cluster/systems/system/devices/*' use='@id' />
  <xsl:key name='Controller' match='/cluster/systems/system/StorageDevices/Controllers/Controller' use='@id' />
  <xsl:key name='LogicalDisk' match='/cluster/systems/system/StorageDevices/Controllers/Controller/LogicalDisks/LogicalDisk' use='@id' />
  <xsl:key name='PhysicalDisk' match='/cluster/systems/system/StorageDevices/Enclosures/Enclosure/DiskSlots/DiskSlot/PhysicalDisk' use='@id' />

  <xsl:variable name='LDSum0' select='sum(/cluster/systems/system[name="node0"]/StorageDevices/Controllers/Controller/LogicalDisks/LogicalDisk/size)'  />
  <xsl:variable name='LDSum1' select='sum(/cluster/systems/system[name="node1"]/StorageDevices/Controllers/Controller/LogicalDisks/LogicalDisk/size)'  />

  <xsl:variable name='PrivSum0' select='sum(/cluster/systems/system[name="node0"]/Storage/PrivateStorage/size)'  />
  <xsl:variable name='PrivSum1' select='sum(/cluster/systems/system[name="node1"]/Storage/PrivateStorage/size)'  />

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster'>
      <xsl:text>digraph {&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='systems/system'>
      <xsl:text>subgraph </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text> {&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:apply-templates />

      <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <dc:description>
      if status is not normal change color
  </dc:description>
  <xsl:template match='sensor'>

<!--
      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='type' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='device/@ref' />
      <xsl:text>";&#10;</xsl:text>
-->

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='chassis'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='model' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='../../@id' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='card'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='model' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='../../@id' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='port[kind = "network"]'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="port:</xsl:text>
      <xsl:value-of select='device' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='card/@ref' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='lan'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="lan"];&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='networks/interface'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="intf:</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='device/@ref' />
      <xsl:text>";&#10;</xsl:text>

      <xsl:if test='lan'>
        <xsl:text>"</xsl:text>
        <xsl:value-of select='@id' />
        <xsl:text>" -&gt; "</xsl:text>
        <xsl:value-of select='lan/@ref' />
        <xsl:text>";&#10;</xsl:text>
      </xsl:if>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='PhysicalDisk'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="Disk:</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='logicalDisk/@ref' />
      <xsl:text>";&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='controller/@ref' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='Controller'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='../../../@id' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='LogicalDisk'>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" [label="</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>"];&#10;</xsl:text>

      <xsl:text>"</xsl:text>
      <xsl:value-of select='@id' />
      <xsl:text>" -&gt; "</xsl:text>
      <xsl:value-of select='../../@id' />
      <xsl:text>";&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='Enclosure'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster/storage'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='region' mode='sum'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='region[writable="false"]'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster/networks'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='guests'>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='guest'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='os[distro]'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='interfaces'>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='volumes'>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='interfaces/interface'>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='volume'>
  </xsl:template>

</xsl:stylesheet>
<!--
  vim:autoindent
  vim:expandtab
  -->
