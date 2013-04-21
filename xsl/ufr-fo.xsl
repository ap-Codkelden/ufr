<?xml version="1.0" encoding="UTF-8"?>

<!-- ################################################################
#  Файл XSLT-преобразования для документов UFR проекта 
#  "Созвездие" в схемы Formatting Objects
#  Версия 1.0 от 2013-04-04
#
#  The MIT License (MIT)
#  Copyright (c) 2013 Renat Nasridinov, <mavladi@gmail.com>
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
 ################################################################ -->

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:sk="http://f.skobkin.ru/other/constellation/UFR"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <!-- <xsl:character-map name="dash">
        <xsl:output-character character="&#x2014;" string="&amp;nbsp;&amp;mdash;"/>
    </xsl:character-map> -->
<xsl:output method="xml" 
    encoding="utf-8" 
    indent="yes" />
    <!--
    # Добавить в xsl:output
    # use-character-maps="dash" 
    --> 

    <!-- Обработка пробелов в элементах кода -->
    <xsl:strip-space elements="code"/> 
    <xsl:preserve-space elements="codesample"/>

    <xsl:variable name="ufr-sfonly-copyright">
        <xsl:value-of select="/ufr/middle/copyright/@efsf-only" />
    </xsl:variable>

    <!-- Номер -->
    <xsl:variable name="this-ufr-num" select="/ufr/front/ufrdata/ufrname/@number" />

    <!-- Категория -->
    <xsl:variable name="urfcat" select="ufr/front/ufrdata/ufrcategory/@cat" />

    <!-- Дата -->
    <xsl:variable name="d">
        <xsl:value-of select="/ufr/front/ufrdata/ufrdate/@value" />
    </xsl:variable>

    <!-- КЛЮЧИ  -->
    <!-- для перекрестных ссылок -->
    <xsl:key name="cross-ref" match="//insert|//section|//appendix" use="@id"/>
    <!-- ключ для ссылок на литературу  -->
    <xsl:key name="book-ref" match="//ref" use="@id"/>
    <!-- Для иллюстраций -->
    <xsl:key name="fig-search" match="//figure" use="@id"/>
    <!-- Для сносок -->
    <xsl:key name="ftnt-search" match="//footnote" use="@id"/>
    <!-- Для таблиц -->
    <xsl:key name="table-search" match="//table" use="@id"/>

    <!-- ***********ФУНКЦИИ************** -->

    <xsl:function name="sk:trimURL"> 
        <xsl:param name="inputURL"/> 
        <xsl:variable name="http_trim">
            <xsl:choose>
                <xsl:when test="starts-with($inputURL,'https://')">
                    <xsl:value-of select="replace($inputURL,'https://','')" /> 
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($inputURL,'http://','')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="base_url">
            <xsl:choose>
                <xsl:when test="contains($http_trim,'/')">
                    <xsl:value-of select="substring-before($http_trim,'/')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$http_trim" /> 
                </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$base_url"/>
    </xsl:function>



    <!-- ################################################## -->

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format"> 
        <fo:layout-master-set>
            <fo:simple-page-master 
                margin-right="1cm" 
                margin-left="3cm" 
                margin-bottom="2cm" 
                margin-top="2cm" 
                page-width="21cm" 
                page-height="29.7cm" 
                master-name="first">
            <fo:region-body margin-top="0cm" margin-bottom="0cm"/>
            <fo:region-before extent="0cm"/>
            <fo:region-after extent="0cm"/>
            </fo:simple-page-master>
        </fo:layout-master-set>

        <fo:page-sequence font-family="sans-serif" font-size="10pt" master-reference="first">




    <fo:flow flow-name="xsl-region-body">
            <!-- <fo:block text-align="center" font-weight="normal">
                <fo:table table-layout="fixed">
                    <fo:table-column column-width="50%"/>
                    <fo:table-column column-width="50%"/>
                    <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell padding-start="0pt" padding-end="0pt" padding-before="0pt" padding-after="0pt">
                            <fo:block text-align="left" color="grey" line-height="0.50">
                                <xsl:value-of select="ufr/front/creator/organization/text()" /> 
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
                            <fo:block text-align="right">
                                <xsl:value-of select="ufr/front/creator/unit/text()"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>

                    <fo:table-row>
                        <fo:table-cell padding-start="0pt" padding-end="0pt" padding-before="0pt" padding-after="0pt">
                            <fo:block text-align="left">
                                <xsl:text>UFR &#8470;</xsl:text><xsl:value-of select="ufr/front/ufrdata/ufrname/@number" />
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
                            <fo:block text-align="right">
                                <xsl:value-of select="ufr/front/creator/author/text()"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>

                    <fo:table-row>
                        <fo:table-cell padding-start="0pt" padding-end="0pt" padding-before="0pt" padding-after="0pt">

                        </fo:table-cell>
                        <fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
                            <fo:block>
                                <xsl:attribute name="text-align">right</xsl:attribute>
                                <xsl:value-of select="format-date($d, '[M01] месяц [Y0001]', 'ru', (), ())"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>

                    </fo:table-body>
                </fo:table>
            </fo:block> -->

            <fo:block>
                <xsl:attribute name="text-align">center</xsl:attribute>
                <fo:external-graphic src="just.svg" 
                    content-height="scale-to-fit" 
                    height="6cm" 
                    width="4.8644cm" 
                    scaling="non-uniform"/>
            </fo:block>

            <fo:block>
                <xsl:attribute name="text-align">center</xsl:attribute>
                <xsl:attribute name="space-before">20mm</xsl:attribute>
                <xsl:attribute name="font-size">22pt</xsl:attribute>
                <xsl:attribute name="font-family">AntykwaTorunska-Bold</xsl:attribute>
                <xsl:value-of select="upper-case(ufr/front/ufrdata/ufrname)" />
            </fo:block>
            <fo:block>
                <xsl:attribute name="text-align">center</xsl:attribute>
                <xsl:attribute name="space-before">10mm</xsl:attribute>
                <xsl:attribute name="font-size">18pt</xsl:attribute>
                <xsl:attribute name="font-family">FreeSerifBold</xsl:attribute>
                <xsl:value-of select="format-date($d, '[D] [MNn] [Y0001]', 'ru', (), ())"/>
            </fo:block>
            <fo:block text-align="left" padding-left="100mm">
                <xsl:variable name="is_draft" select="ufr/front/ufrdata/ufrcategory/@draft" />
                <xsl:variable name="draft">
                    <xsl:choose>
                        <xsl:when test="$is_draft='yes'">
                            <xsl:value-of select="' (черновой)'"/>
                        </xsl:when>
                        <xsl:when test="$is_draft='no'">
                            <xsl:value-of select="''"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="ufrcat">
                <xsl:choose>
                    <xsl:when test="$urfcat='std'">
                        <xsl:value-of select="стандарт" />
                    </xsl:when> 
                    <xsl:when test="$urfcat='rec'">
                        <xsl:value-of select="рекомендация" />
                    </xsl:when>   
                    <xsl:when test="$urfcat='tech'">
                        <xsl:value-of select="технический" /> 
                    </xsl:when>   
                    <xsl:when test="$urfcat='historic'">
                        <xsl:value-of select="исторический" /> 
                    </xsl:when>   
                    <xsl:when test="$urfcat='info'">
                        <xsl:value-of select="информационный" />
                    </xsl:when>   
                </xsl:choose> 
                </xsl:variable>
                <xsl:value-of select="concat(upper-case(substring($ufrcat,1,1)),substring($ufrcat,2), UFR, $draft)"/>
            </fo:block>


    </fo:flow>  


    
    </fo:page-sequence>
    </fo:root>
</xsl:template>
</xsl:stylesheet>