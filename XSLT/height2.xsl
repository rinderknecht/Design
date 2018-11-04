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
    <xsl:call-template name="height">
      <xsl:with-param name="seq" select="chapter"/>
      <xsl:with-param name="cur" select="0"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="height" as="xs:integer">
    <xsl:param name="seq" as="element()*"/>
    <xsl:param name="cur" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="empty($seq)">
        <xsl:sequence select="$cur"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="height">
          <xsl:with-param name="seq"
                          select="$seq[position()>1]"/>
          <xsl:with-param name="cur" as="xs:integer">
            <xsl:variable name="sub" as="xs:integer">
              <xsl:call-template name="height">
                <xsl:with-param name="seq" 
                                select="$seq[1]/section"/>
                <xsl:with-param name="cur" select="0"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$cur gt $sub">
                <xsl:sequence select="$cur"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="1 + $sub"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
