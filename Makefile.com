#-*-makefile-*-

BIB := ${firstword ${TEX}}
IDX := yes
ETC := flat.def flat0.def rev.def ctail.def

override DEF += \def\java{${JAVA} }\def\saxlib{${SAXON} }\def\XMLdir{${XML_DIR}}\def\XSLTdir{${XSLT_DIR}}\def\erlsrc{${ERL_DIR}}

# HTML: Basenames of HTML files
# XML: Basenames of XML files not to validate
# XML_DTD: Basenames of the XML files to validate
# DTD: Basenames of the DTD files
# ERL: Basenames of the Erlang files
#
HTML := h
XML := beers entities scoping cookbook persons4 num
XML_DTD := csv_att csv empty_sum espana notation numbers_bis \
           numbers_tree numbers ordered_lists persons1 persons2 \
           persons3 sum toc3 toc_bis toc_chap toc_deep toc_simple toc
XSLT := empty chapter chapters cookbook cookbook1bis cookbook1 \
        cookbook2 cookbook3 len0 len1 len3 sum sum1 last penult \
        rev2 csv1 shuffle1 shuffle2 shuffle3 shuffle4 max1 max2 \
        max3 red merge1 count1 count2 count3 count4 sum2 flip1 \
        flip2 flip3 flip4 height1 height2 height3 num1 num2 num3 \
        tmerge
DTD  := book book_att sum book_bis csv persons numbers numbers_bis \
        list book_deep numbers_tree book_simple
ERL  := mean max

ETC += ${DTD:%=${DTD_DIR}/%.dtd} ${XML_DIR}/id_idref.xml

# Calling Saxon
#   ${1}: Output file (here, plain text or XML)
#   ${2}: Input XML followed by XSLT file
#
define saxon
printf "Making $@ using XSLT..."
${JAVA} -jar ${SAXON} -o:$@ $^
if test "$$?" = "0"
then echo " done."
else echo " FAILED:"
fi
endef

# OUT_XML: Basenames of XML to be generated (for inclusion)
#
OUT_XML := cookbook1 cookbook2 cookbook3 cookbook4 cookbook5 \
           cookbook6 cookbook7 cookbook8 toc sum toc_bis1 toc_bis2 \
           csv persons1A persons2A persons3A persons1B persons2B \
           persons3B numbers numbers_bis ordered_lists toc_simple \
           toc_chap

OUT_XML := ${OUT_XML:%=${XML_DIR}/%_out.xml}

.PHONY: xml clean_xml
xml: ${OUT_XML}

clean_xml:
> \rm -f ${OUT_XML}

clean:: clean_xml

${XML_DIR}/cookbook1_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/empty.xsl
> ${call saxon}

${XML_DIR}/cookbook2_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/chapter.xsl
> ${call saxon}

${XML_DIR}/cookbook3_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/chapters.xsl
> ${call saxon}

${XML_DIR}/cookbook4_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/cookbook.xsl
> ${call saxon}

${XML_DIR}/cookbook5_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/cookbook1bis.xsl
> ${call saxon}

${XML_DIR}/cookbook6_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/cookbook1.xsl
> ${call saxon}

${XML_DIR}/cookbook7_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/cookbook2.xsl
> ${call saxon}

${XML_DIR}/cookbook8_out.xml: ${XML_DIR}/cookbook.xml ${XSLT_DIR}/cookbook3.xsl
> ${call saxon}

${XML_DIR}/toc_out.xml: ${XML_DIR}/toc.xml ${XSLT_DIR}/len0.xsl
> ${call saxon}

${XML_DIR}/sum_out.xml: ${XML_DIR}/sum.xml ${XSLT_DIR}/sum.xsl
> ${call saxon}

${XML_DIR}/toc_bis1_out.xml: ${XML_DIR}/toc_bis.xml ${XSLT_DIR}/last.xsl
> ${call saxon}

${XML_DIR}/toc_bis2_out.xml: ${XML_DIR}/toc_bis.xml ${XSLT_DIR}/penult.xsl
> ${call saxon}

${XML_DIR}/csv_out.xml: ${XML_DIR}/csv.xml ${XSLT_DIR}/csv1.xsl
> ${call saxon}

${XML_DIR}/persons1A_out.xml: ${XML_DIR}/persons1.xml ${XSLT_DIR}/shuffle1.xsl
> ${call saxon}

${XML_DIR}/persons2A_out.xml: ${XML_DIR}/persons2.xml ${XSLT_DIR}/shuffle1.xsl
> ${call saxon}

${XML_DIR}/persons3A_out.xml: ${XML_DIR}/persons3.xml ${XSLT_DIR}/shuffle1.xsl
> ${call saxon}

${XML_DIR}/persons1B_out.xml: ${XML_DIR}/persons1.xml ${XSLT_DIR}/shuffle2.xsl
> ${call saxon}

${XML_DIR}/persons2B_out.xml: ${XML_DIR}/persons2.xml ${XSLT_DIR}/shuffle2.xsl
> ${call saxon}

${XML_DIR}/persons3B_out.xml: ${XML_DIR}/persons3.xml ${XSLT_DIR}/shuffle2.xsl
> ${call saxon}

${XML_DIR}/numbers_out.xml: ${XML_DIR}/numbers.xml ${XSLT_DIR}/max1.xsl
> ${call saxon}

${XML_DIR}/numbers_bis_out.xml: ${XML_DIR}/numbers_bis.xml ${XSLT_DIR}/red.xsl
> ${call saxon}

${XML_DIR}/ordered_lists_out.xml: ${XML_DIR}/ordered_lists.xml ${XSLT_DIR}/merge1.xsl
> ${call saxon}

${XML_DIR}/toc_simple_out.xml: ${XML_DIR}/toc_simple.xml ${XSLT_DIR}/flip1.xsl
> ${call saxon}

${XML_DIR}/toc_chap_out.xml: ${XML_DIR}/toc_chap.xml ${XSLT_DIR}/flip2.xsl
> ${call saxon}

# Text files
#
toc_deep_out.txt: ${XML_DIR}/toc_deep.xml ${XSLT_DIR}/count1.xsl
> ${call saxon}

numbers_tree_out.txt: ${XML_DIR}/numbers_tree.xml ${XSLT_DIR}/sum2.xsl
> ${call saxon}

toc_chap_out.txt: ${XML_DIR}/toc_chap.xml ${XSLT_DIR}/height1.xsl
> ${call saxon}

num_out.txt: ${XML_DIR}/num.xml ${XSLT_DIR}/tmerge.xsl
> ${call saxon}

OUT_TXT := toc_deep numbers_tree toc_chap num
OUT_TXT := ${OUT_TXT:%=%_out.txt}

.PHONY: txt clean_txt
txt: ${OUT_TXT}

clean_txt:
> \rm -f ${OUT_TXT}

clean:: clean_txt
