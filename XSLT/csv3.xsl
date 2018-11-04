<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0" 
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="numbers" as="text()*">
    <xsl:apply-templates select="hexa"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="hexa" as="text()*">
    <xsl:sequence select="text()"/>
    <xsl:choose>
      <xsl:when test="position() eq last()">
        <xsl:value-of select="'.'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="','"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
