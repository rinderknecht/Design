<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="book" as="xs:integer">
    <xsl:call-template name="count">
      <xsl:with-param name="sections" select="chapter/section"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="count" as="xs:integer">
    <xsl:param name="sections" as="element(section)*"/>
    <xsl:choose>
      <xsl:when test="empty($sections)">
        <xsl:sequence select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="subseq" as="xs:integer">
          <xsl:call-template name="count">
            <xsl:with-param name="sections"
                            select="$sections[position()>1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="subsec" as="xs:integer">
          <xsl:call-template name="count">
            <xsl:with-param name="sections" select="$sections[1]/section"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="1 + $subsec + $subseq"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
