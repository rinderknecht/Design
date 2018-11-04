<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="seq" as="element(seq)">
    <xsl:copy>
      <xsl:call-template name="shuffle">
        <xsl:with-param name="a" select="a/element()"/>
        <xsl:with-param name="b" select="b/element()"/>
        <xsl:with-param name="c" select="c/element()"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="shuffle" as="element()*">
    <xsl:param name="a" as="element()*"/>
    <xsl:param name="b" as="element()*"/>
    <xsl:param name="c" as="element()*"/>
    <xsl:choose>
      <xsl:when test="empty($a) and empty($b) and empty($c)"/>
      <xsl:when test="not(empty($c))">
        <xsl:sequence select="$c[1]"/>
        <xsl:call-template name="shuffle">
          <xsl:with-param name="a" select="$b"/>
          <xsl:with-param name="b" select="$c[position()>1]"/>
          <xsl:with-param name="c" select="$a"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="shuffle">
          <xsl:with-param name="a" select="$b"/>
          <xsl:with-param name="b" select="$c"/>
          <xsl:with-param name="c" select="$a"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
