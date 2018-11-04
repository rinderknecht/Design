<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/" as="text()*">
    <xsl:call-template name="csv">
      <xsl:with-param name="items" select="numbers/hexa/text()"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="csv" as="text()*">
    <xsl:param name="items" as="item()*"/>
    <xsl:choose>
      <xsl:when test="empty($items)"/>
      <xsl:when test="empty($items[position()>1])">
        <xsl:value-of select="($items[1],'.')" separator=""/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="($items[1],',')" separator=""/>
        <xsl:call-template name="csv">
          <xsl:with-param name="items"
                          select="$items[position()>1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
