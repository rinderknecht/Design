<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0"
              encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="lists" as="element(lists)">
    <xsl:copy>
      <xsl:call-template name="merge">
        <xsl:with-param name="seq1" select="list[1]/item"/>
        <xsl:with-param name="seq2" select="list[2]/item"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="merge" as="element(item)*">
    <xsl:param name="seq1" as="element(item)*"/>
    <xsl:param name="seq2" as="element(item)*"/>
    <xsl:choose>
      <xsl:when test="empty($seq1)">
        <xsl:sequence select="$seq2"/>
      </xsl:when>
      <xsl:when test="empty($seq2)">
        <xsl:sequence select="$seq1"/>
      </xsl:when>
      <xsl:when test="xs:integer($seq1[1]/@val)
                      lt xs:integer($seq2[1]/@val)">
        <xsl:sequence select="$seq1[1]"/>
        <xsl:call-template name="merge">
          <xsl:with-param name="seq1"
                          select="$seq1[position()>1]"/>
          <xsl:with-param name="seq2" select="$seq2"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$seq2[1]"/>
        <xsl:call-template name="merge">
          <xsl:with-param name="seq1" select="$seq1"/>
          <xsl:with-param name="seq2" 
                          select="$seq2[position()>1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
