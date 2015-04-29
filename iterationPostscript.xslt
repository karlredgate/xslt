<?xml version='1.0' ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:DNS='http://svn.sn.stratus.com/storbitz/DNS'
                xmlns:IPv6='http://svn.sn.stratus.com/storbitz/IPv6'
                xmlns:util='http://svn.sn.stratus.com/storbitz/utils'
                xmlns:str='http://exslt.org/strings'
                version='1.0'>

  <dc:title>Generate a nice report of the stories in an iteration</dc:title>
  <dc:creator>Karl N. Redgate</dc:creator>
  <dc:description>
  Create a postscript report from an XML doc from PivotalTracker.com
  </dc:description>

  <xsl:key name='engineer' match='story' use='owned_by' />

  <xsl:output method="text"/>
  <xsl:template match='text()' />

  <dc:description>
  </dc:description>
  <xsl:template match='/iterations/iteration'>
      <xsl:text><![CDATA[%!PS-Adobe-2.1
%%Title: PivotalTracker iteration report
%%Creator: kredgate
%%Pages: 1
%%EndComments
%%BeginProcSet: textset 1.0 0
/drop /pop load def
/swap /exch load def
/Times-Roman findfont 12 scalefont setfont
/y 740 def
/N {
    y 100 lt {
        showpage
        /y 740 def
    } if
    /y y 15 sub def
} def
/W {20 y moveto} def
/S {50 y moveto} def
/Author {35 y moveto} def
/printstate { % ( type state -- )
    gsave
        25 y       moveto sshow
        25 y 6 add moveto sshow
    grestore
} def
/para {
    /lm currentpoint drop def
    {
        currentpoint drop 500 gt  {
            N lm y moveto
        } if
        dup ( ) search  not  {show exit} if
        show show
    } loop
} def
/sshow {
    gsave
        /Times-Roman findfont 6 scalefont setfont
        show
    grestore
} def
/bshow {
    gsave
        /Times-Bold findfont 14 scalefont setfont
        show
    grestore
} def
/StoryShow {
    gsave
        /Times-Bold findfont 12 scalefont setfont
        show
    grestore
} def
/AuthShow {
    gsave
        /Times-Italic findfont 12 scalefont setfont
        show
    grestore
} def
%%EndProcSet
%%EndProlog
%%Page: 1 1
%%BeginPageSetup
<< /Duplex true >> setpagedevice
%%EndPageSetup
]]></xsl:text>
      <xsl:apply-templates />
      <xsl:text>showpage
%%Trailer
%%EOF
</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='stories'>
      <xsl:for-each select='story[count(. | key("engineer", owned_by)[1]) = 1]'>
          <xsl:sort select='owned_by' />

          <xsl:text>W (</xsl:text>
          <xsl:value-of select='owned_by' />
          <xsl:text>) bshow N&#10;</xsl:text>

          <xsl:for-each select='key("engineer", owned_by)'>
              <xsl:text>S (</xsl:text>
              <xsl:value-of select='story_type' />
              <xsl:text>)  (</xsl:text>
              <xsl:value-of select='current_state' />
              <xsl:text>) printstate  &#10;</xsl:text>
              <xsl:text>S (</xsl:text>
              <xsl:value-of select='name' />
              <xsl:text>) show  N&#10;</xsl:text>
          </xsl:for-each>
      </xsl:for-each>

      <xsl:text>N N&#10;</xsl:text>

      <xsl:for-each select='story'>
          <xsl:sort select='id' />
          <xsl:apply-templates select="." />
      </xsl:for-each>

  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='story'>
      <xsl:text>N W (\(</xsl:text>
      <xsl:value-of select='id' />
      <xsl:text>\)  </xsl:text>
      <xsl:value-of select='story_type' />
      <xsl:text>) show N&#10;</xsl:text>
      <xsl:text>W (</xsl:text>
      <xsl:value-of select='name' />
      <xsl:text>) bshow N&#10;</xsl:text>

      <xsl:text>S (</xsl:text>
      <xsl:value-of select='description' />
      <xsl:text>) para  N&#10;</xsl:text>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='notes'>
      <xsl:apply-templates />
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='note'>
      <xsl:variable name='text'>
          <xsl:value-of select='
str:replace(
    str:replace( str:replace(text,"(","\(") ,")","\)"), "&#10;", ") para N S ("
)
          ' />
      </xsl:variable>
      <xsl:text>Author (</xsl:text>
      <xsl:value-of select='author' />
      <xsl:text>    </xsl:text>
      <xsl:value-of select='noted_at' />
      <xsl:text>) AuthShow N&#10;</xsl:text>
      <xsl:text>S (</xsl:text>
      <xsl:value-of select='$text' />
      <xsl:text>) para  N&#10;</xsl:text>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='tasks'>
      <xsl:text>N&#10;</xsl:text>
      <xsl:for-each select='task'>
          <xsl:sort select='position' />
          <xsl:apply-templates select="." />
      </xsl:for-each>
  </xsl:template>

  <dc:description>
  </dc:description>
  <xsl:template match='task'>
      <xsl:variable name='text'>
          <xsl:value-of select='
str:replace(
    str:replace( str:replace(description,"(","\(") ,")","\)"), "&#10;", ") para N S ("
)
          ' />
      </xsl:variable>
      <xsl:text>Author (</xsl:text>

      <xsl:choose>
      <xsl:when test='complete = "true"'>Task complete</xsl:when>
      <xsl:otherwise>Task INCOMPLETE</xsl:otherwise>
      </xsl:choose>

      <xsl:text>) AuthShow N&#10;</xsl:text>
      <xsl:text>S (</xsl:text>
      <xsl:value-of select='$text' />
      <xsl:text>) para  N&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
