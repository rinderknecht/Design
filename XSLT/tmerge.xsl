<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text"/>

  <xsl:template match="/" as="text()*">
    <xsl:call-template name="csv">
      <!-- The following cast is needed. -->
      <xsl:with-param name="items" as="xs:integer*">
        <xsl:apply-templates select="num"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="num" as="xs:integer*">
    <xsl:choose>
      <xsl:when test="empty(@val)">
        <xsl:call-template name="merge">
          <xsl:with-param name="fst" as="xs:integer*">
            <xsl:apply-templates select="num[1]"/>
          </xsl:with-param>
          <xsl:with-param name="snd" as="xs:integer*">
            <xsl:apply-templates select="num[2]"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="merge" as="xs:integer*">
    <xsl:param name="fst" as="xs:integer*"/>
    <xsl:param name="snd" as="xs:integer*"/>
    <xsl:choose>
      <xsl:when test="empty($fst)">
        <xsl:sequence select="$snd"/>
      </xsl:when>
      <xsl:when test="empty($snd)">
        <xsl:sequence select="$fst"/>
      </xsl:when>
      <xsl:when test="$fst[1] lt $snd[1]">
        <xsl:sequence select="$fst[1]"/>
        <xsl:call-template name="merge">
          <xsl:with-param name="fst" select="$fst[position()>1]"/>
          <xsl:with-param name="snd" select="$snd"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$snd[1]"/>
        <xsl:call-template name="merge">
          <xsl:with-param name="fst" select="$fst"/>
          <xsl:with-param name="snd" select="$snd[position()>1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
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
