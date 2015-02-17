<?xml version='1.0' ?>
<sch:schema xmlns:sch='http://purl.oclc.org/dsdl/schematron'
                xml:lang='en'>

  <sch:title>Schema for validating Storbitz XML descriptions</sch:title>
  <sch:p>
This transform reads an Avance host XML description and validates it
against a set of rules that must be true in order for the file to be
successfully used by the test infrastructure.
  </sch:p>

  <sch:pattern>
      <sch:rule context='storbitz'>
          <sch:assert test='child::class'>A storbitz element must contain a class element.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern>
      <sch:rule context='storbitz[class="CLIENT"]'>
          <sch:assert test='count(nodes/node) = 1'>A client must contain a single node element.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern>
      <sch:p>
        A SuperNova/DUT must contain a node element for each node of the two nodes of
        the cluster and a node for the cluster IP address configuration.
      </sch:p>
      <sch:rule context='storbitz[class="CLUSTERDUT"]'>
          <sch:assert test='count(nodes/node/pxe) = 2'>Cluster <sch:name /> does not have two server nodes.</sch:assert>
          <sch:assert test='count(nodes/node) = 3'>Cluster <sch:name /> does not have a cluster node.</sch:assert>
          <sch:assert test='count(//node()[contains(.,"nodmraid")]) = 0'>Cluster <sch:name /> has a dmraind node.</sch:assert>
      </sch:rule>
  </sch:pattern>

  <sch:pattern>
      <sch:p>
        The 'gateway' field in the PXE args is deprecated, and should have been
        replaced with a 'gw' field.
      </sch:p>
      <sch:rule context='storbitz/nodes/node/pxe/args'>
          <sch:assert test='count(.//node()[contains(.,"gateway")]) = 0'>Cluster <sch:name /> boot args has a DEPRECATED gateway argument.</sch:assert>
      </sch:rule>
  </sch:pattern>

</sch:schema>
<!--
  vim:autoindent
  vim:expandtab
  -->
