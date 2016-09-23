<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
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

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster'>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:text>  </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>  [</xsl:text>
      <xsl:value-of select='kits/kit/product/version/name' /><xsl:text>)</xsl:text>
      <xsl:text>]&#10;</xsl:text>
      <xsl:text>   </xsl:text>
      <xsl:value-of select='address' />/<xsl:value-of select='netmask' />
      <xsl:text>  brd </xsl:text>
      <xsl:value-of select='broadcast' />
      <xsl:text>  gw </xsl:text>
      <xsl:value-of select='gateway' />
      <xsl:text>  dns </xsl:text>
      <xsl:value-of select='dns_servers/dns_server' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='systems/system'>
      <xsl:text>&#10;</xsl:text>
      <xsl:choose>
      <xsl:when test='maintenance = "true"'> M </xsl:when>
      <xsl:otherwise> - </xsl:otherwise>
      </xsl:choose>

      <xsl:value-of select='name' /><xsl:text>  (</xsl:text>
      <xsl:value-of select='state' /><xsl:text>/</xsl:text>
      <xsl:value-of select='mode' /><xsl:text>)   power=</xsl:text>
      <xsl:value-of select='pwrstate' /><xsl:text>    </xsl:text>
      <xsl:value-of select='@id' /><xsl:text>  </xsl:text>
      <xsl:text>&#10;   </xsl:text>
      <xsl:value-of select='model' /><!-- old used model, now uses @enum?? -->
      <xsl:value-of select='model/@enum' />
      <xsl:if test='model/@supported != "true"'>
         <xsl:text> (</xsl:text>
         <xsl:text>ESC[1;31m</xsl:text>
         <xsl:text>unsupported</xsl:text>
         <xsl:text>ESC[0m</xsl:text>
         <xsl:text>) </xsl:text>
      </xsl:if>
      <xsl:text>   Serial# </xsl:text>
      <xsl:value-of select='serial' /><xsl:text>   BMC </xsl:text>
      <xsl:value-of select='bmc/address' /><xsl:text>   </xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>   </xsl:text>
      <xsl:value-of select='bootcount' /><xsl:text> boots</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>   Mem </xsl:text>
      <xsl:value-of select='memory' /><xsl:text>   </xsl:text>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:apply-templates select='sensors/sensor[status != "normal"]' />
      <xsl:apply-templates select='devices/core' />
      <xsl:apply-templates select='devices/disk' />
      <xsl:apply-templates select='StorageDevices' />
      <xsl:apply-templates select='networks/interface' />
      <xsl:apply-templates select='devices/port[kind = "network"]' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='sensor'>
      <xsl:text>   ESC[1;31m[</xsl:text>
      <xsl:value-of select='status' />
      <xsl:text>]     </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>ESC[0m&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='port[kind = "network"]'>
      <xsl:variable name='card_id' select='card/@ref' />

      <xsl:text>   </xsl:text>
      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='device' />
          <xsl:with-param name='width' select='12' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text>s</xsl:text>
      <xsl:value-of select='slot' />
      <xsl:text>p</xsl:text>
      <xsl:value-of select='port' />
      <xsl:text> [</xsl:text>
      <xsl:value-of select='address' />
      <xsl:text>] </xsl:text>
      <xsl:value-of select='status' />
      <xsl:text></xsl:text>
      <xsl:text>  </xsl:text>
      <xsl:for-each select='../card[@id=$card_id]'>
          <xsl:value-of select='vendor' /><xsl:text>  (</xsl:text>
          <xsl:value-of select='model' /><xsl:text>)</xsl:text>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='networks/interface'>
      <xsl:variable name='my-id' select='@id' />
      <xsl:variable name='shared-network' select='/cluster/networks/network[networks/interface/@ref = $my-id]' />

      <xsl:text>   </xsl:text>
      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='name' />
          <xsl:with-param name='width' select='12' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text>[</xsl:text>
      <xsl:value-of select='$shared-network/name' />

      <xsl:for-each select='key("lan",lan/@ref)'>
          <xsl:text>/lan-</xsl:text>
          <xsl:value-of select='generate-id()' />
      </xsl:for-each>
      <xsl:text>]   </xsl:text>

      <xsl:for-each select='$shared-network/capabilities/*'>
          <xsl:sort select='name(.)' />
          <xsl:value-of select='name(.)' /><xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='core'>
      <xsl:variable name='proc_id' select='processor/@ref' />
      <xsl:text>   </xsl:text>
      <xsl:value-of select='../processor[@id=$proc_id]/index' />
      <xsl:text>/</xsl:text>
      <xsl:value-of select='index' />
      <xsl:text> cpu_id=</xsl:text><xsl:value-of select='cpu' />
      <xsl:text>     </xsl:text>
      <xsl:value-of select='../processor[@id=$proc_id]/modelname' />
      <xsl:text>   "</xsl:text>
      <xsl:value-of select='status' />
      <xsl:text>"</xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='disk'>
      <xsl:variable name='slot_id' select='slot/@ref' />

      <xsl:text>   Slot: </xsl:text>
      <xsl:value-of select='../slot[@id=$slot_id]/description' />
      <xsl:text>   </xsl:text>

      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='vendor' />
          <xsl:with-param name='width' select='10' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>

      <xsl:text>   </xsl:text>
      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='model' />
          <xsl:with-param name='width' select='20' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>

      <xsl:call-template name='right-aligned'>
          <xsl:with-param name='node'  select='capacity' />
          <xsl:with-param name='width' select='5' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:value-of select='capacity/@unit' />

      <xsl:text>   "</xsl:text>
      <xsl:value-of select='status' />
      <xsl:text>"</xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='PhysicalDisk'>
      <xsl:text>   Slot: </xsl:text>
      <xsl:value-of select='../name' />
      <xsl:text>   </xsl:text>

      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='name' />
          <xsl:with-param name='width' select='20' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text>   </xsl:text>

      <xsl:value-of select='vendor' />
      <xsl:text>/</xsl:text>
      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='model' />
          <xsl:with-param name='width' select='20' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text>   </xsl:text>

      <xsl:call-template name='right-aligned'>
          <xsl:with-param name='node'  select='size' />
          <xsl:with-param name='width' select='5' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:value-of select='capacity/@unit' />

      <xsl:text> </xsl:text>
      <xsl:for-each select='key("LogicalDisk",logicalDisk/@ref)'>
          <xsl:text> [LD</xsl:text>
          <xsl:value-of select='deviceNumber' /><xsl:text>] </xsl:text>
          <xsl:value-of select='devicePath' />
      </xsl:for-each>

      <xsl:text>   "</xsl:text>
      <xsl:value-of select='status' />
      <xsl:text>"</xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='Controller'>
      <xsl:text>   Controller: </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>   (</xsl:text>

      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='type' />
          <xsl:with-param name='width' select='10' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>

      <xsl:text>)   "</xsl:text>
      <xsl:value-of select='status' />
      <xsl:text>"</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>               FW:</xsl:text>
      <xsl:value-of select='firmwareRev' />
      <xsl:text> (</xsl:text>
      <xsl:value-of select='driverName' />
      <xsl:text>) </xsl:text>
      <xsl:for-each select='LogicalDisks/LogicalDisk'>
          <xsl:text> [LD</xsl:text>
          <xsl:value-of select='deviceNumber' /><xsl:text> </xsl:text>
          <xsl:value-of select='raidLevel' /><xsl:text>]</xsl:text>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='Enclosure'>
      <xsl:text>   Enclosure: </xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster/storage'>
      <xsl:text>&#10;</xsl:text>
      <xsl:text> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -&#10;</xsl:text>
      <xsl:apply-templates select='region[writable="false"]' />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='region[writable="false"]'>
      <xsl:text>    CDROM: (</xsl:text>
      <xsl:value-of select='device/path' /><xsl:text>:</xsl:text>
      <xsl:value-of select='status' />
      <xsl:if test='replicationStatus != "normal"'>
         <xsl:text>:</xsl:text>
         <xsl:text>ESC[1;31m</xsl:text>
         <xsl:value-of select='replicationStatus' />
         <xsl:text>=</xsl:text>
         <xsl:value-of select='replicationProgress' />
         <xsl:text>ESC[0m</xsl:text>
      </xsl:if>
      <xsl:text>)  </xsl:text>
      <xsl:value-of select='name' /><xsl:text>  </xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='/cluster/networks'>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='guests'>
      <xsl:text>&#10;</xsl:text>
      <xsl:text> = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='guest'>
      <xsl:text> - - - - - - - - - - </xsl:text>
      <xsl:value-of select='name' /><xsl:text>  (</xsl:text>
      <xsl:value-of select='state' /><xsl:text>/</xsl:text>
      <xsl:value-of select='mode' /><xsl:text>)</xsl:text>
      <xsl:text> - - - - - - - - - - -&#10;</xsl:text>
      <xsl:value-of select='id' /><xsl:text>  </xsl:text>
      <xsl:value-of select='system' /><xsl:text>  </xsl:text>
      <xsl:text>cpus/</xsl:text><xsl:value-of select='vcpus' />
      <xsl:text>  memory/</xsl:text><xsl:value-of select='memory' />
      <xsl:text>  </xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='os[distro]'>
      <xsl:text>  OS: </xsl:text><xsl:value-of select='distro' />
      <xsl:text>      "</xsl:text><xsl:value-of select='name' /><xsl:text>"&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='pv_drivers[installed="true"]'>
      <xsl:text>  PV Drivers: </xsl:text>
      <xsl:if test='loaded = "true"'>LOADED    </xsl:if>
      <xsl:value-of select='version' />
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='error'>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>  Boot </xsl:text>
      <xsl:value-of select='../reason' />
      <xsl:text>: </xsl:text>
      <xsl:value-of select='type' />
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='interfaces'>
      <xsl:text>  interfaces:&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='volumes'>
      <xsl:text>  volumes:&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='interfaces/interface'>
      <xsl:text>    </xsl:text>
      <xsl:value-of select='MAC' /><xsl:text>  </xsl:text>

      <xsl:for-each select='key("network",network/@ref)'>
          <xsl:value-of select='name' /><xsl:text>  </xsl:text>
      </xsl:for-each>

      <xsl:value-of select='@id' />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='volume'>
      <xsl:variable name='region_id' select='storage/@ref' />

      <xsl:text>    </xsl:text>
      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='type' />
          <xsl:with-param name='width' select='6' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>

      <xsl:for-each select='key("region",storage/@ref)'>

          <xsl:call-template name='left-aligned'>
              <xsl:with-param name='node'  select='name' />
              <xsl:with-param name='width' select='25' />
              <xsl:with-param name='fill' select='" "' />
          </xsl:call-template>

          <xsl:call-template name='right-aligned'>
              <xsl:with-param name='node'  select='capacity' />
              <xsl:with-param name='width' select='5' />
              <xsl:with-param name='fill' select='" "' />
          </xsl:call-template>

          <xsl:text> </xsl:text>
          <xsl:value-of select='capacity/@unit' />
          <xsl:text>  (</xsl:text>
          <!-- Pre-release alum? <xsl:value-of select='drbd/@device' /> -->
          <xsl:value-of select='device/path' />
          <xsl:text> </xsl:text>
             <xsl:for-each select='key("network",sync_network/@ref)'>
             <xsl:value-of select='name' />
             </xsl:for-each>
          <xsl:text> </xsl:text>
          <xsl:value-of select='state' />
          <xsl:if test='replicationStatus != "normal"'>
             <xsl:text> [</xsl:text>
             <xsl:text>ESC[1;31m</xsl:text>
             <xsl:value-of select='replicationStatus' />
             <xsl:text>=</xsl:text>
             <xsl:value-of select='replicationProgress' />
             <xsl:text>ESC[0m</xsl:text>
             <xsl:text>]</xsl:text>
          </xsl:if>
          <xsl:text>)  </xsl:text>
      </xsl:for-each>

      <xsl:call-template name='left-aligned'>
          <xsl:with-param name='node'  select='device' />
          <xsl:with-param name='width' select='6' />
          <xsl:with-param name='fill' select='" "' />
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:value-of select='state' /><xsl:text>  </xsl:text>
      <!-- do not really need <xsl:value-of select='@id' /> -->

      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

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
