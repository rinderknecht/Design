<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               exclude-result-prefixes="xs">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="book"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="book" as="element(book)">
    <xsl:copy>
      <xsl:sequence select="@title"/>
      <xsl:sequence select="author"/>
      <xsl:call-template name="mk_chap">
        <xsl:with-param name="chapters" select="chapter"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="mk_chap" as="element(chapter)*">
    <xsl:param name="chapters" as="element(chapter)*"/>
    <xsl:if test="not(empty($chapters))">
      <chapter title="{$chapters[1]/@title}">
        <xsl:call-template name="mir">
          <xsl:with-param name="sections"
                          select="$chapters[1]/section"/>
        </xsl:call-template>
      </chapter>
      <xsl:call-template name="mk_chap">
        <xsl:with-param name="chapters"
                        select="$chapters[position()>1]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir" as="element(section)*">
    <xsl:param name="sections" as="element(section)*"/>
    <xsl:if test="not(empty($sections))">
      <xsl:call-template name="mir">
        <xsl:with-param name="sections" 
                        select="$sections[position()>1]"/>
      </xsl:call-template>
      <section title="{$sections[1]/@title}">
        <xsl:call-template name="mir">
          <xsl:with-param name="sections"
                          select="$sections[1]/section"/>
        </xsl:call-template>
      </section>
    </xsl:if>
  </xsl:template>

</xsl:transform>
