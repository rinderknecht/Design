<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="xml" version="1.0" encoding="UTF-8"
              indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="numbers"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="numbers" as="element(numbers)">
    <xsl:copy>
      <xsl:call-template name="red">
        <xsl:with-param name="t" select="num"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="red" as="element(num)*">
    <xsl:param name="t" as="element(num)*"/>
    <xsl:choose>
      <xsl:when test="empty($t[position()>1])">
        <xsl:sequence select="$t"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$t[1]/@val ne $t[2]/@val">
          <xsl:sequence select="$t[1]"/>
        </xsl:if>
        <xsl:call-template name="red">
          <xsl:with-param name="t" select="$t[position()>1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>

