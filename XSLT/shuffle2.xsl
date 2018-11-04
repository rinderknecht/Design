<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="persons" as="element(persons)">
    <xsl:copy>
      <xsl:call-template name="shuffle">
        <xsl:with-param name="names"  select="names/name"/>
        <xsl:with-param name="notes" select="notes/note"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="shuffle" as="element()*">
    <xsl:param name="names"  as="element(name)*"/>
    <xsl:param name="notes" as="element(note)*"/>
    <xsl:choose>
      <xsl:when test="empty($notes)">
        <xsl:sequence select="$names"/>
      </xsl:when>
      <xsl:when test="empty($names)">
        <xsl:sequence select="$notes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="($names[1],$notes[1])"/>
        <xsl:call-template name="shuffle">
          <xsl:with-param name="names"
                          select="$names[position()>1]"/>
          <xsl:with-param name="notes"
                          select="$notes[position()>1]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:transform>
