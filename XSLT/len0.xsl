<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="book" as="xs:integer">
    <xsl:call-template name="len0">
      <xsl:with-param name="chapters" select="chapter"
                      as="element(chapter)*"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="len0" as="xs:integer">
    <xsl:param name="chapters" as="element(chapter)*"/>
    <xsl:choose>
      <xsl:when test="empty($chapters)">
        <xsl:sequence select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="x" as="xs:integer">
          <xsl:call-template name="len0">
            <xsl:with-param name="chapters"
                            as="element(chapter)*"
                            select="$chapters[position()>1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="1 + $x"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
