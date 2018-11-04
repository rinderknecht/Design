<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select="book"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="book" as="xs:integer">
    <xsl:call-template name="max">
      <xsl:with-param name="int" as="xs:integer*">
        <xsl:apply-templates select="chapter">
          <xsl:with-param name="lvl" select="1"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="cur" select="0"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="chapter|section" as="xs:integer*">
    <xsl:param name="lvl" as="xs:integer"/>
    <xsl:if test ="empty(section)">
      <xsl:sequence select ="$lvl"/>
    </xsl:if>
    <xsl:apply-templates select="section">
      <xsl:with-param name="lvl" select="$lvl+1"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="max" as="xs:integer?">
    <xsl:param name="int" as="xs:integer*"/>
    <xsl:param name="cur" as="xs:integer?"/>
    <xsl:choose>
      <xsl:when test="empty($int)">
        <xsl:sequence select="$cur"/>
      </xsl:when>
      <xsl:when test="not(empty($cur)) and $cur ge $int[1]">
        <xsl:call-template name="max">
          <xsl:with-param name="int" select="$int[position()>1]"/>
          <xsl:with-param name="cur" select="$cur"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="max">
          <xsl:with-param name="int" select="$int[position()>1]"/>
          <xsl:with-param name="cur" select="$int[1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
