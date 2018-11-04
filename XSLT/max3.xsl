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
      <xsl:with-param name="int" select="num/text()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="max" as="xs:integer?">
    <xsl:param name="int" as="xs:integer*"/>
    <xsl:choose>
      <xsl:when test="empty($int[position()>1])">
        <xsl:sequence select="$int[1]"/>
      </xsl:when>
      <xsl:when test="$int[1] lt $int[2]">
        <xsl:call-template name="max">
          <xsl:with-param name="int" select="$int[position()>1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="max">
          <xsl:with-param name="int"
                          select="($int[1],$int[position()>2])"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>

