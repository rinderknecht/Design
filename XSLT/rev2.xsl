<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xhtml="http://www.w3.org/1999/xhtml"
               exclude-result-prefixes="xs xhtml">

  <xsl:output method="xhtml"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              indent="yes"
              omit-xml-declaration="yes"/>

  <xsl:template match="book" as="element(xhtml:html)">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <title><xsl:sequence select="title/text()"/></title>
      </head>
      <body>
        <h2><xsl:value-of select="title"/></h2>
        <p>by <xsl:value-of select="author"/></p>
        <h3>Reversed table of contents</h3>
        <ul>
          <xsl:call-template name="rev">
            <xsl:with-param name="chap" select="contents/chapter"/>
          </xsl:call-template>
        </ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="rev" as="element(xhtml:li)*">
    <xsl:param name="chap" as="element(chapter)*"/>
    <xsl:if test="not(empty($chap))">
      <xsl:call-template name="rev">
        <xsl:with-param name="chap" select="$chap[position()>1]"/>
      </xsl:call-template>
      <li xmlns="http://www.w3.org/1999/xhtml">
        <xsl:value-of select="$chap[1]/@title"/>
      </li>
    </xsl:if>
  </xsl:template>

</xsl:transform>
