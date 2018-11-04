<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <xsl:output method="xhtml"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              indent="yes"
              omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="book"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="book" as="element(xhtml:html)">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <title><xsl:value-of select="@title"/></title>
      </head>
      <body>
        <h2><xsl:value-of select="@title"/></h2>
        <p>by <xsl:value-of select="author/@*"/></p>
        <h3>Table of contents</h3>
        <ul><xsl:apply-templates select="chapter"/></ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="section|chapter" as="element(xhtml:li)">
    <li xmlns="http://www.w3.org/1999/xhtml">
      <xsl:value-of select="('[',position(),'] ',@title)" separator=""/>
      <xsl:if test="not(empty(section))">
        <ul><xsl:apply-templates select="section"/></ul>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:transform>
