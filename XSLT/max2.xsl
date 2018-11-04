<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:apply-templates select="numbers"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="numbers" as="xs:integer?">
    <xsl:call-template name="max">
      <xsl:with-param name="int" select="num[position()>1]/text()"/>
      <xsl:with-param name="cur" select="num[1]/text()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="max" as="xs:integer?">
    <xsl:param name="int" as="xs:integer*"/>
    <xsl:param name="cur" as="xs:integer?"/>
    <xsl:choose>
      <xsl:when test="empty($int)">
        <xsl:sequence select="$cur"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="max">
          <xsl:with-param name="int" select="$int[position()>1]"/>
          <xsl:with-param name="cur">
            <xsl:choose>
              <xsl:when test="not(empty($cur)) and $cur ge $int[1]">
                <xsl:sequence select="$cur"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="$int[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
