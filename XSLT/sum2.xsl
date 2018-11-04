<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="text"/>

  <xsl:template match="numbers">
    <xsl:call-template name="sum">
      <xsl:with-param name="numbers" select="num"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

<xsl:template name="sum" as="xs:integer">
  <xsl:param name="numbers" as="element(num)*"/>
  <xsl:param name="current" as="xs:integer" select="0"/>
  <xsl:choose>
    <xsl:when test="empty($numbers)">
      <xsl:sequence select="$current"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="sum">
        <xsl:with-param name="numbers"
                        select="$numbers[position()>1]"/>
        <xsl:with-param name="current" as="xs:integer">
          <xsl:call-template name="sum">
            <xsl:with-param name="numbers"
                            select="$numbers[1]/num"/>
            <xsl:with-param name="current"  
             select="$current + xs:integer($numbers[1]/@val)"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:transform>
