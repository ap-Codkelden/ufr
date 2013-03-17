<?xml version="1.0" encoding="UTF-8"?>

<!-- ################################################################
#  Файл XSLT-преобразования для документов UFR проекта 
#  "Созвездие"
#  Версия 1.0 от 2013-02-24
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
    xmlns:sks="http://f.skobkin.ru/other/constellation/UFR">
<!-- <xsl:character-map name="dash">
    <xsl:output-character character="&#x2014;" string="&amp;nbsp;&amp;mdash;"/>
</xsl:character-map> -->
<xsl:output method="html" 
    encoding="utf-8" 
    indent="no" />
    <!--
    # Добавить в xsl:output
    # use-character-maps="dash" 
    --> 

<!-- Обработка пробелов в элементах кода -->
<xsl:strip-space elements="code"/> 
<xsl:preserve-space elements="codesample"/>

<xsl:variable name="ufr-sfonly-copyright">
    <xsl:value-of select="/ufr/document/copyright/@efsf-only" />
</xsl:variable>

<!-- Номер -->
<xsl:variable name="this-ufr-num" select="/ufr/description/ufrdata/ufrname/@number" />

<!-- Категория -->
<xsl:variable name="urfcat" select="ufr/description/ufrdata/ufrcategory/@cat" />

<!-- Дата -->
<xsl:variable name="d">
    <xsl:value-of select="/ufr/description/ufrdata/ufrdate/@value" />
</xsl:variable>

<!-- КЛЮЧИ  -->
<!-- для перекрестных ссылок -->
<xsl:key name="cross-ref" match="//insert|//section|//appendix" use="@id"/>
<!-- ключ для ссылок на литературу  -->
<xsl:key name="book-ref" match="//ref" use="@id"/>
<!-- Для иллюстраций -->
<!-- <xsl:key name="fig-search" match="//figure|//svg" use="@id"/> -->
<xsl:key name="fig-search" match="//figure" use="@id"/>
<!-- Для сносок -->
<xsl:key name="ftnt-search" match="//footnote" use="@id"/>
<!-- Ссылки link  (пара - <anchor>) 
<xsl:key name="link-ref" match="//link" use="@id"/> -->

<!-- ***********ФУНКЦИИ************** -->

<xsl:function name="sks:trimURL"> 
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
<!--    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;</xsl:text> -->
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text> 
    <!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
    <html> 
    <head>
    <meta charset="utf-8" />
    <xsl:call-template name="insertCSS" />
    <title>
        <xsl:text>URF </xsl:text><xsl:value-of select="$this-ufr-num" />
        <xsl:text> - </xsl:text><xsl:value-of select="ufr/description/ufrdata/ufrname/text()" /> 
    </title>
    </head> 	
    <body>
        <table style="width:100%;border:0px;border-spacing:0px">
        <tbody>
        <tr>
            <td style="text-align:left"><xsl:value-of select="ufr/description/creator/organization/text()" /></td>
            <td style="text-align:right"><xsl:value-of select="ufr/description/creator/unit/text()"/></td>
        </tr>
        <tr>
            <td style="text-align:left">
                <xsl:text>UFR &#8470;</xsl:text><xsl:value-of select="ufr/description/ufrdata/ufrname/@number" />
            </td>
            <td style="text-align:right">
                <xsl:value-of select="ufr/description/creator/author/text()"/>
            </td>
        </tr>
        <tr>
            <td style="text-align:left">
                <xsl:text>Категория: </xsl:text>
                <xsl:variable name="is_draft" select="ufr/description/ufrdata/ufrcategory/@draft" />
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
                <xsl:choose>
                    <xsl:when test="$urfcat='std'">
                        <xsl:value-of select="concat('стандарт',$draft)" />
                    </xsl:when> 
                    <xsl:when test="$urfcat='rec'">
                        <xsl:value-of select="concat('рекомендация',$draft)" />
                    </xsl:when>   
                    <xsl:when test="$urfcat='tech'">
                        <xsl:value-of select="concat('технический',$draft)" /> 
                    </xsl:when>   
                    <xsl:when test="$urfcat='historic'">
                        <xsl:value-of select="concat('исторический',$draft)" /> 
                    </xsl:when>   
                    <xsl:when test="$urfcat='info'">
                        <xsl:value-of select="concat('информационный',$draft)" />
                    </xsl:when>   
                </xsl:choose> 
            </td>
                    <!-- конец КАТЕГОРИИ -->
            <td style="text-align:right"><xsl:value-of select="format-date($d, '[M01] месяц [Y0001]', 'ru', (), ())"/></td>    
        </tr>
        </tbody>
        </table>
        <!-- <div class="caption">-->
            <h1 class="caption"><xsl:value-of select="upper-case(ufr/description/ufrdata/ufrname)" /></h1>
            <p class="caption">
                <xsl:value-of select="format-date($d, '[D] [MNn] [Y0001]', 'ru', (), ())"/>
            </p>
        <!--</div>-->
        <div style="margin-left:36pt">
        <!-- ################# DOCUMENT CHANGED-BY ##########################  
        # <urfchanged>
        #   <changed no="2" date="2013-02-03" edition=""/> 
        # </urfchanged>
        # Элемент <urfchanged> не имеет закрывающего тега и атрибутов,
        # если изменений не было
        # Атрибуты 
        #   edition 
        #   date
        ################################################################## -->

        <xsl:if test="ufr/description/ufrdata/ufrchanged/changed" >
            <p class="center">Изменен:</p>
            <xsl:text  disable-output-escaping='yes'>&lt;</xsl:text>p class="center"
            <xsl:if test="not(ufr/description/ufrdata/urfobsolete)"> style="margin-bottom:10ex"</xsl:if>
            <xsl:text  disable-output-escaping='yes'>&gt;</xsl:text>

            <xsl:for-each select="ufr/description/ufrdata/ufrchanged/changed">
                <xsl:variable name="date-of-change" select="@date" />
                <!-- @number - номер ВНОСЯЩЕГО  -->
                <!-- date дата вносящего -->
                <a href="{concat('ufr',@number,'.html')}"><xsl:text>UFR &#8470;</xsl:text><xsl:value-of select="@number" /></a>
                <xsl:text> (</xsl:text>
                <xsl:variable name="delimiter">
                <xsl:choose>
                    <xsl:when test="@edition!=''">
                        <xsl:text>-</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text></xsl:text>
                    </xsl:otherwise>
                </xsl:choose></xsl:variable>
                <a href="{concat('ufr',$this-ufr-num, '_', format-date($date-of-change, '[Y0001][M01][D01]'),$delimiter, @edition,'.html')}">
                    <xsl:text>предыдущая версия</xsl:text></a><xsl:text> UFR &#8470;</xsl:text>
                <xsl:value-of select="$this-ufr-num" /><xsl:text>)</xsl:text>
                <xsl:if test="count(/ufr/description/ufrdata/ufrchanged/changed) &gt; 1">
                    <xsl:if test="not(position() = last())">
                        <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
            <xsl:text  disable-output-escaping='yes'>&lt;</xsl:text>/p<xsl:text  disable-output-escaping='yes'>&gt;</xsl:text>
        </xsl:if>

        <!-- 
        #    O B S O L E T E 
        -->
        <xsl:if test="ufr/description/ufrdata/urfobsolete">
            <xsl:call-template name="obsoleteUFR">
                <xsl:with-param name="obsolete" select="ufr/description/ufrdata/urfobsolete/@ufrno" />
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="insertAbstract" /> 
        <xsl:call-template name="insertCopyright" />  
        <xsl:call-template name="insertLicense" />  
 
<!-- 
#           TABLE OF CONTENTS 
# -->
        <h2>Содержание</h2>
            <xsl:apply-templates select="ufr/document/section
                |ufr/document/insert
                |//appendixes
                |/ufr/back/references" mode="toc"/> 
<!--
#
#   Main document processing
#
 -->
        <xsl:for-each select="ufr/document/section|ufr/document/insert">
            <h2><a id="{@id}"/>
            <xsl:number level="any" count="ufr/document/section|ufr/document/insert" 
                format="1. "/>
                <xsl:value-of select="@name" />
            </h2>
                <xsl:apply-templates />
                 <xsl:call-template name="footnotes"/>
                <xsl:if test="@type">
                <xsl:variable name="type">
                    <xsl:value-of select="@type" />
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$type='apply-changes'">
                        <xsl:call-template name="apply-changes" /> 
                    </xsl:when>
                </xsl:choose>   
            </xsl:if> 
        </xsl:for-each>

    <xsl:for-each select="ufr/back/references">
            <h2><a id="{@id}"/>
            <xsl:number level="any" 
                count="ufr/document/section
                    |ufr/document/insert
                    |ufr/back/references" format="1. "/>
                <xsl:value-of select="@name" />
            </h2> 
            <xsl:call-template name="insertReferences"/>
             <xsl:call-template name="footnotes"/>
        </xsl:for-each> 
<!--
#   Приложения
-->
        <xsl:for-each select="ufr/back/appendixes">
                <h2><a id="{@id}"/>
                    <xsl:value-of select="@name" /></h2> 
                <xsl:apply-templates />   
        </xsl:for-each>

        <!-- ##########################################################
        # Вставка раздела Автор(ы) 
        # Если авторов больше одного, то раздел зовут "Авторы", иначе "Автор"
        ########################################################### -->
        <xsl:variable name="author">
            <xsl:choose>
                <xsl:when test="count(/ufr/description/authors/author) &gt; 1">Авторы</xsl:when>
                <xsl:otherwise>Автор</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <h2><xsl:value-of select="$author" /></h2>
        <xsl:for-each select="ufr/description/authors/author">
            <p><xsl:value-of select="assignment" />
            <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
            <xsl:value-of select="rank" />
            <xsl:text  disable-output-escaping='yes'> </xsl:text>
            <xsl:value-of select="name" />
            <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
            <xsl:value-of select="unit" />
            <xsl:text disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
            <xsl:value-of select="organization" /></p>
        </xsl:for-each>
    </div>
    </body>
    </html>	
    </xsl:template>

<!--
# вставка ссылок в конце каждого раздела 
-->
<xsl:template name="footnotes">
            <xsl:for-each select="self::node()//footnote">

        <xsl:variable name="ftnumb">
            <xsl:number  level="any" count="footnote" format="i"/>
        </xsl:variable> 
        <p>
            <a id="{@id}">
            <sup><xsl:number  level="any" count="footnote" format="i"/></sup>
            <!-- &#8593; - стрелка вверх -->
            <a href="#{concat('footnote',$ftnumb)}">&#8593;</a>
        </a>
            <span class="footnote"><xsl:apply-templates /></span></p>
  </xsl:for-each>
</xsl:template>


<!-- **************************** ШАБЛОНЫ ***************************** -->
<!-- Шаблон абзаца (самая маленькая единица в документе) -->
    <xsl:template match="//t">  
        <p><xsl:apply-templates /></p>
    </xsl:template>

<!-- Шаблон рисунка с номером -->

    <xsl:template match="//figure">  
        <xsl:variable name="fig_num">
            <xsl:number level="any" count="figure" format="1"/>
        </xsl:variable>
        <a id="{concat('pic',$fig_num)}"><xsl:apply-templates /><div>
        <p class="center"><xsl:text>Рисунок&#160;</xsl:text>
        <xsl:value-of select="$fig_num" /><xsl:text>. </xsl:text><xsl:value-of select="@name" />
        </p></div></a>
    </xsl:template>

<!-- Шаблон для вывода части неформатированного текста -->

<xsl:template match="//figure/artwork/text()">
        <pre class="artwork"><xsl:copy/></pre>
</xsl:template>  

<!-- ССЫЛКИ НА ВНЕШНИЕ ИСТОЧНИКИ -->

    <!-- ссылка в инет без текста -->
    <xsl:template match="//eref[not(node())]">
        <xsl:text>&lt;</xsl:text>
            <a href="{@target}" target="_blank"><xsl:value-of select="@target" /></a>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <!-- ссылка в инет с текстом -->
    <xsl:template match="//eref[node()]">
<a href="{@target}" target="_blank">
<xsl:apply-templates />
</a> 
    </xsl:template>

<!-- ################### CROSS-REFERENCE HANDLING ############################# 
# <fgref id="circle"/> - на картинки (<figure id="circle"/>)
#
# <ufrref no="4"/> - на другие (<reference ufrno="5" />, без ука)
#
# <refref id=? [short='yes']> - на литературу <reference id="moon">
# 
# <xref id="special-tags" /> -  на id="approved-tags"
#
# <link id="">  - ссылка на определенный заранее якорь без номера, 
# e. g. <link id="tags">этих тегов</link> 
#
# <ftref name=""> - сторонняя ссылка на определенную заранее сноску, при этом 
# приводит к тому, что невозможно возвратиться к тому месту, откуда ты пришел
#
-->

<!-- 
    Якорь для сслыки типа <link id="someAnchor"> 
-->
<!-- заменено name -> id -->
<xsl:template match="//anchor">
    <xsl:variable name="id" select="@id" />
        <a id="{concat('link-',$id)}">
            <xsl:apply-templates />
        </a>
</xsl:template> 

<xsl:template match="//link">
    <xsl:variable name="target" select="@target" />
        <a href="{concat('#','link-',$target)}">
            <xsl:apply-templates />
        </a>
</xsl:template> 

    <xsl:template match="//fgref">
    <xsl:variable name="id" select="@id" />
        <xsl:text>[</xsl:text>
            <xsl:for-each select="key('fig-search', $id)">
            <xsl:variable name="fig-num">
                <xsl:number level="any" count="figure" />
            </xsl:variable> 
            <a href="{concat('#','pic',$fig-num)}">рис. <xsl:value-of select="$fig-num" /></a>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="//ufrref">
        <xsl:text>[</xsl:text><a href="{concat('#','ufr',@no)}">
        <xsl:text>UFR</xsl:text>
        <xsl:value-of select='@no' /></a><xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="//ftref">
        <xsl:variable name="footnote-name" select="@name" />
        <xsl:value-of select="." />
            <sup><xsl:for-each select="key('ftnt-search', $footnote-name)">
                <a href="{concat('#',$footnote-name)}"><xsl:number  level="any" count="footnote" format="i"/></a>
        </xsl:for-each></sup>
    </xsl:template>

    <xsl:template match="//refref">
    <xsl:variable name="id" select="@target" />
    <xsl:choose>
        <xsl:when test="@short='yes'">
            <xsl:for-each select="key('book-ref', $id)">
                <xsl:variable name="ref-num">
                    <xsl:number level="any" count="back/references/reference[@type='other']/ref"/>
                </xsl:variable>
                <xsl:variable name="ref-title">
                    <xsl:value-of select="title"/>
                </xsl:variable> 
                <xsl:text>[</xsl:text>
                    <a href="#{@id}" title="{$ref-title}"><xsl:value-of select="$ref-num"/></a>
                <xsl:text>]</xsl:text>
            </xsl:for-each>
        </xsl:when>
        <xsl:when test="@short='no'">
            <xsl:for-each select="key('book-ref', $id)">
                <xsl:text>[</xsl:text>
                        <a href="#{@id}"><xsl:value-of select="title"/></a>
                <xsl:text>]</xsl:text>
            </xsl:for-each>
        </xsl:when>
    </xsl:choose>
    </xsl:template>

    <xsl:template match="//xref[not(node())]">
        <xsl:variable name="id" select="@target" />
         <xsl:for-each select="key('cross-ref', $id)">
            <xsl:choose>
                <xsl:when test="name()='appendix'">
                        <xsl:text disable-output-escaping='yes'>прил.&lt;span class="nowrap"&gt;&#160;&lt;/span&gt;[</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping='yes'>разд.&lt;span class="nowrap"&gt;&#160;&lt;/span&gt;[</xsl:text>
                    </xsl:otherwise>
            </xsl:choose>
            <a href="#{$id}">
                <xsl:choose>
                    <xsl:when test="name()='appendix'">
                        <xsl:number level="multiple" format="A." count="appendix"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:number level="multiple" format="1.1.1.1.1."
                        count="insert
                        |appendix
                        |references
                        |ufr/document/section
                        |ufr/document/section/section
                        |ufr/document/section/section/section
                        |ufr/document/section/section/section/section
                        |ufr/document/section/section/section/section/section
                        |ufr/document/section/section/section/section/section/section" />
                    </xsl:otherwise>
                </xsl:choose>
                <span class="nowrap">&#160;</span>
                <xsl:choose>
                    <xsl:when test="@xreftext">
                        <xsl:value-of select="key('cross-ref', $id)/@xreftext" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="key('cross-ref', $id)/@name" />
                    </xsl:otherwise>
                </xsl:choose></a><xsl:text>]</xsl:text>
        </xsl:for-each>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="//xref[node()]">
        <a href="#{@target}"><xsl:apply-templates /></a> 
    </xsl:template>

    <!-- Обработка разделов  
    СОЗДАНИЕ ОГЛАВЛЕНИЯ -->
    <xsl:template match="appendixes
        |appendix
        |insert
        |references
        |ufr/document/section
        |ufr/document/section/section
        |ufr/document/section/section/section
        |ufr/document/section/section/section/section
        |ufr/document/section/section/section/section/section
        |ufr/document/section/section/section/section/section/section" mode="toc">
    <xsl:variable name="include-toc" select="@toc"/>
        <xsl:if test="$include-toc='include'">
        <xsl:variable name="id" select="@id" />
        <div class="toc_inner">
            <a href="#{$id}">
                <xsl:choose>
                    <xsl:when test="name()='insert' or name()='section'">
                        <xsl:number level="multiple" format="1.1.1.1.1."
                        count="insert|section"/>
                    </xsl:when>
                    <xsl:when test="name()='references'">
                        <xsl:number level="any" format="1.1.1.1.1."
                        count="ufr/document/insert|references|ufr/document/section"/>
                    </xsl:when>
                    <xsl:when test="name()='appendix'">
                        <xsl:number level="multiple" format="A." count="appendix"/>
                    </xsl:when>
                </xsl:choose></a>
            <xsl:text> </xsl:text><xsl:value-of select="@name"/>
            <xsl:apply-templates select="appendixes|appendix|insert|references|section" mode="toc"/>
        </div>
    </xsl:if>
    </xsl:template> 
<!-- ############################################################# -->

    <xsl:template match="ufr/document/section|ufr/document/insert">
            <a id="{@id}"><h2><xsl:number level="multiple"
                 count="ufr/document/insert|ufr/document/section"
                 format="1. "/>
        <xsl:value-of select="@name" /></h2></a>
        <xsl:apply-templates/> 
    </xsl:template>

    <!--  LEVEL 2  -->
    <xsl:template match="ufr/document/section/section" priority="1" > 
        <a id="{@id}"><h3><xsl:number level="multiple"
                 count="insert
                 |ufr/document/section
                 |ufr/document/section/section"
                 format="1.1. "/>
        <xsl:value-of select="@name" /></h3></a>
        <xsl:apply-templates/> 
    </xsl:template> 

    <!--  LEVEL 3 -->
    <xsl:template match="ufr/document/section/section/section" priority="1" > 
        <a id="{@id}"><h4><xsl:number level="multiple"
                 count="ufr/document/insert
                 |ufr/document/section
                 |ufr/document/section/section
                 |ufr/document/section/section/section"
                 format="1.1.1. "/>
        <xsl:value-of select="@name" /></h4></a>
        <xsl:apply-templates/> 
    </xsl:template> 

    <!--  LEVEL 4  -->
    <xsl:template match="ufr/document/section/section/section/section" priority="1" > 
        <a id="{@id}"><h5><xsl:number level="multiple"
                 count="ufr/document/insert
                 |ufr/document/section
                 |ufr/document/section/section
                 |ufr/document/section/section/section
                 |ufr/document/section/section/section/section" format="1.1.1.1. "/>
        <xsl:value-of select="@name" /></h5></a>
        <xsl:apply-templates/> 
    </xsl:template> 

    <!--  LEVEL 5  -->
    <xsl:template match="ufr/document/section/section/section/section/section" priority="1" > 
        <a id="{@id}"><h6><xsl:number level="multiple"
                 count="ufr/document/insert
                 |ufr/document/section
                 |ufr/document/section/section
                 |ufr/document/section/section/section
                 |ufr/document/section/section/section/section
                 |ufr/document/section/section/section/section/section" format="1.1.1.1.1. "/>
        <xsl:value-of select="@name" /></h6></a>
        <xsl:apply-templates/> 
    </xsl:template> 

    <!-- ################# ПРИЛОЖЕНИЯ #############################3 -->

    <xsl:template match="appendixes/appendix"> 
        <a id="{@id}"><h3><xsl:text>Приложение </xsl:text>
        <xsl:number level="any"
                 count="appendix"
                 format="A. "/><xsl:value-of select="@name" /></h3></a>
        <xsl:apply-templates/>
        <xsl:call-template name="footnotes"/>
    </xsl:template> 

    <!-- ################# С Н О С К И #############################3 
        их 26???? -->

    <xsl:template match="footnote" name="footnote"> 
        <xsl:variable name="ftnumb">
            <xsl:number  level="any" count="footnote" format="i"/>
        </xsl:variable> 
        <a id="{concat('footnote',$ftnumb)}"><a href="#{@id}"><sup><xsl:number  level="any" count="footnote" lang="ru" format="i"/></sup></a></a>
    </xsl:template> 

     <!-- ################# LISTS ############################# -->

    <xsl:template match="//olist">
        <ol>
            <xsl:apply-templates /> 
        </ol>
    </xsl:template>

    <xsl:template match="//ulist">
        <ul>
            <xsl:apply-templates /> 
        </ul>
    </xsl:template>

    <xsl:template match="//item">
        <li>
            <xsl:apply-templates/> 
        </li>
    </xsl:template>


<!-- Если ваш URF устарел... -->

<xsl:template name="obsoleteUFR">
  <xsl:param name="obsolete" />
  <p class="center" style="color:FireBrick;margin-bottom:10ex">
<xsl:text disable-output-escaping='yes'>Данный UFR устарел - см. &lt;a href="</xsl:text><xsl:value-of select="concat('ufr',$obsolete,'.html')"/><xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>UFR &#8470;<xsl:value-of select="$obsolete" /><xsl:text disable-output-escaping='yes'>&lt;/a&gt;</xsl:text></p>
</xsl:template>

    <!-- 
    #
    #   Заготовки лицензий, и неизменяемых текстов;
    #
     -->

    <xsl:template name="apply-changes"> 
        <p>В соответствии с &#167;&#167;42, 64 раздела 5, &#167;94 раздела 8 Устава Звёздного Флота внесение изменений в данный стандарт производится только стандартами UFR, принятыми в установленном порядке.</p>
    </xsl:template>

<xsl:template name="insertLicense">
    <h2><xsl:value-of select="ufr/document/license/@name" /></h2>
    <xsl:choose>
<xsl:when test="ufr/document/license/@type='cc-license'">
<p>В соответствии с &#167;105 раздела 17 Устава Звёздного Флота данный стандарт распространяется на условиях лицензии Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported (<a href="http://creativecommons.org/licenses/by-nc-nd/3.0/">CC-BY-NC-ND-3.0</a>)</p>
</xsl:when>
<xsl:when  test="ufr/document/license/@type='mit-license'">
<p>В соответствии с &#167;106 раздела 17 Устава Звёздного Флота данный стандарт распространяется на условиях лицензии MIT (<a href="http://opensource.org/licenses/MIT">MIT License</a>)</p>
</xsl:when>
<xsl:when test="ufr/document/license/@type='other-license'">
    <!-- !!! Необходимо определять лицензию в соответствующем разделе !!! -->
    <p>В соответствии с &#167;107 раздела 17 Устава Звёздного Флота данный стандарт распространяется на условиях лицензии, отличной от указанных в &#167;&#167;105, 106 раздела 17 Устава Звёздного Флота, и изложенных в <a href="full-copyright-statement">соответствующем разделе этого</a> документа.</p>
</xsl:when>
    </xsl:choose>
</xsl:template>    

    <xsl:template name="insertCopyright"> 
        <xsl:param name="starfleet"/> 
        <h2><xsl:value-of select="ufr/document/copyright/@name" /></h2>
        <p>Copyright &#169; <xsl:value-of select="format-date($d, '[Y0001]', (), (), ())" /> Звёздный Флот Федерации Земли<xsl:if test="$ufr-sfonly-copyright='no'"> и лица, указанные как авторы документа</xsl:if>. Все права защищены.</p>
    </xsl:template> 

    <xsl:template name="insertAbstract">
        <xsl:if test='ufr/document/abstract'>
        <h2><xsl:value-of select="ufr/document/abstract/@name" /></h2>
        <xsl:choose>
            <xsl:when test="$urfcat='std'">
                <p>Этот документ устанавливает обязательные к использованию 
                стандарты "Созвездия", которые могут быть дополнены, улучшены 
                или изменены. Допускается неограниченное распространение 
                данного стандарта.</p>
            </xsl:when> 
            <xsl:when test="$urfcat='rec'">
                <p>Этот документ устанавливает рекомендованные к использованию 
                при участии в проекте "Созвездие" и одобренные командованием 
                практические наработки, которые будущем могут быть приняты
                в качестве стандартов. Допускается неограниченное распространение 
                данного стандарта.</p>
            </xsl:when>   
            <xsl:when test="$urfcat='tech'">
                <p>Этот документ устанавливает в качестве стандартных технические 
                правила и нормативы, обязательные к использованию при участии в 
                проекте "Созвездие", которые могут быть дополнены, улучшены 
                или изменены. Допускается неограниченное распространение 
                данного стандарта.</p>
            </xsl:when>   
            <xsl:when test="$urfcat='historic'">
                <p>Этот документ описывает состояние сюжетной линии проекта 
                "Созвездие", с целью соответствия изменений состояния проекта, 
                вносимых участниками, генеральной линии командования ЗФ. Допускается 
                неограниченное распространение данного стандарта.</p>
            </xsl:when>   
            <xsl:when test="$urfcat='info'">
                <p>Этот документ не устанавливает стандартов и не предоставляет
                рекомендаций. Тем не менее, он содержит информацию, относящуюся 
                к проекту, и может быть принят участниками проекта к сведению. 
                Допускается неограниченное распространение данного документа.</p>
            </xsl:when>   
        </xsl:choose>
    </xsl:if>
    </xsl:template> 

<!-- Объявление ключевых слов -->
    <xsl:template match="document/section[1]//ufr3|document/section[2]//ufr3">
        <p>Ключевые слова <span class='rfc2119'>необходимо</span>, <span class='rfc2119'>требуется</span>, 
            <span class='rfc2119'>нужно</span>, <span class='rfc2119'>недопустимо</span>, 
            <span class='rfc2119'>не разрешается</span>, <span class='rfc2119'>следует</span>, 
            <span class='rfc2119'>рекомендуется</span>, <span class='rfc2119'>не следует</span>,
            <span class='rfc2119'>не рекомендуется</span>, <span class='rfc2119'>возможно</span>, 
            <span class='rfc2119'>необязательно</span> в соответствующих формах в данном документе 
            должны интерпретироваться в соответствии с требованиями <a href="UFR3.html" target="_blank">URF3</a>.</p>
    </xsl:template>     

<!-- 
#
#   Обработка списка литературы
#
 -->
    <xsl:template name="insertReferences">
        <xsl:for-each select="/ufr/back/references/reference">
        <h5><xsl:value-of select="@title"/></h5>
        <xsl:variable name="type">
            <xsl:value-of select="@type" />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type='ufr'">
                <xsl:text  disable-output-escaping='yes'>&lt;table width="100%" 
                    style="border:0;border-spacing:0"&gt;</xsl:text>
                <xsl:for-each select="ref">
                    <xsl:variable name="ufrno" select="@ufrno" />
                    <xsl:variable name="ufrfile" select="concat('../xml/ufr',$ufrno,'.xml')" />
                    <xsl:variable name="authors_info" select="document($ufrfile)/ufr/description/authors"/>
                    <xsl:variable name="ufr_name" select="document($ufrfile)/ufr/description/ufrdata/ufrname/text()"/>
                    <xsl:variable name="auth_count" select="count($authors_info/author)" /> 
                    <xsl:text  disable-output-escaping='yes'>&lt;tr&gt;</xsl:text>
                    <xsl:for-each select="$authors_info/author">
                        <xsl:text  disable-output-escaping='yes'>&lt;td style="vertical-align:top;width:15%"&gt;</xsl:text>
                            <xsl:if test="position() = 1">
                                <a id="{concat('ufr',$ufrno)}">
                                <xsl:text disable-output-escaping='yes'>[&lt;a href="</xsl:text>
                                    <xsl:value-of select="concat('ufr',$ufrno,'.html')" /><xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
                                    <xsl:value-of select="concat(upper-case('ufr'),$ufrno)"/><xsl:text  disable-output-escaping='yes'>&lt;/a&gt;]</xsl:text></a>
                            </xsl:if>
                        <!-- Вставка данных автора из другого UFR -->
                        <xsl:text disable-output-escaping='yes'>&lt;/td&gt;</xsl:text>
                        <xsl:text disable-output-escaping='yes'>&lt;td&gt;</xsl:text>
                        <!-- Название UFR -->
                        <xsl:if test="position() = 1">
                            <xsl:value-of select="$ufr_name" />
                            <xsl:text disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="rank" /><xsl:text> </xsl:text>
                        <xsl:value-of select="name" />
                        <xsl:text disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
                        <xsl:value-of select="unit" />
                        <xsl:text disable-output-escaping='yes'>&lt;/td&gt;</xsl:text>
                        <xsl:text disable-output-escaping='yes'>&lt;/tr&gt;</xsl:text>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:text  disable-output-escaping='yes'>&lt;/table&gt;</xsl:text>
                <!-- <xsl:text  disable-output-escaping='yes'>&lt;/div&gt;</xsl:text> -->
            </xsl:when>

            <!-- Другие источники   -->
            <xsl:when test="$type='other'">
                <xsl:text  disable-output-escaping='yes'>&lt;table style="width:100%;border:0;border-spacing:0px 2px;"&gt;</xsl:text>
                <xsl:for-each select="ref">
                <xsl:text  disable-output-escaping='yes'>&lt;tr&gt;</xsl:text>    
                <xsl:text  disable-output-escaping='yes'>&lt;td style="vertical-align:top;width:10%"&gt;</xsl:text>
                        <xsl:text>[</xsl:text><xsl:number level="single" count="ref"/><xsl:text>]</xsl:text>
                <xsl:text  disable-output-escaping='yes'>&lt;/td&gt;</xsl:text>
                <xsl:text  disable-output-escaping='yes'>&lt;td style="vertical-align:top"&gt;</xsl:text>
                        <a id="{@id}">
                        <xsl:value-of select="title"/></a>
                    <br />
                    <xsl:for-each select="author">
                        <xsl:call-template name="author"/>
                    </xsl:for-each>
                        <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>

                        <xsl:if test="url/text()">
                            <xsl:variable name="referenceURL">
                                <xsl:value-of select="url/text()" />
                            </xsl:variable>
                            <xsl:text  disable-output-escaping='yes'>&lt;</xsl:text>
                            <a href="{$referenceURL}"><xsl:value-of select="sks:trimURL($referenceURL)"/></a>
                            <xsl:text  disable-output-escaping='yes'>&gt;</xsl:text><xsl:text>, </xsl:text>
                            <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
                        </xsl:if>

                        <xsl:choose>
                            <xsl:when test="publisher/@month!='' and publisher/@day!=''">
                                <xsl:variable name="refdate">
                                    <xsl:value-of select="concat(publisher/@year,'-',publisher/@month,'-',publisher/@day)" />
                                </xsl:variable>
                                <xsl:value-of select="concat(format-date($refdate, '[D01] [MNn] [Y0001]', 'ru', (), ()),' г.')" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(publisher/@name,', ',publisher/@year,' г.')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    <!-- </p> -->
                    <xsl:text  disable-output-escaping='yes'>&lt;/td&gt;</xsl:text>                    
                    <xsl:text  disable-output-escaping='yes'>&lt;tr&gt;</xsl:text> 
                </xsl:for-each>
                <xsl:text  disable-output-escaping='yes'>&lt;/table&gt;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:for-each>
    </xsl:template> 

    <!-- 
    #
    #   Шаблон обработки автора
    #
     -->
    <xsl:template name="author">
        <xsl:variable name="firstname" select="@firstname"/>
        <xsl:variable name="lastname" select="@lastname"/>
        <xsl:variable name="middlename" select="@middlename"/>
        <xsl:if test="@firstname != '' or @lastname != ''">
            <xsl:choose>
                <xsl:when test="@middlename=''">
                    <xsl:value-of select="concat(substring($firstname,1,1),'. ',$lastname,', ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(substring($firstname,1,1),'. ',substring($middlename,1,1),'. ',$lastname,', ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:value-of select="organization" />
        <xsl:if test="not(position() = last())">
            <xsl:text  disable-output-escaping='yes'>&lt;br /&gt;</xsl:text>
        </xsl:if>
    </xsl:template> 

    <!-- вставка CSS-файла -->
    <xsl:template name="insertCSS">
        <style type="text/css">
            <xsl:value-of select="unparsed-text('../css/ufr.css', 'utf-8')" disable-output-escaping="yes"/>
        </style>
    </xsl:template>

    <!-- 
    #   Изменение шрифта: _курсив_ и *полужирный*
    #   Листинг кода, часть кода
    -->

    <xsl:template match="//codesample">
            <p class="element-syntax">
                <xsl:apply-templates/>
            </p>
    </xsl:template>

<xsl:template match="//code">
        <code><!-- <xsl:value-of select="." /> --><xsl:apply-templates/></code>
    </xsl:template> 

    <!-- 
    # ПОЛУЖИРНЫЙ И КУРСИВ (ASCII STYLE)
    -->
    <xsl:template match="//nobr">
        <nobr>
            <span class="nowrap"><xsl:apply-templates/></span>
        </nobr>
    </xsl:template>

    <xsl:template match="//it">
        <span style="font-style:oblique">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//bf">
        <span style="font-weight:700">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//definition">
    <dl>
        <xsl:for-each select="term">
            <dt><xsl:value-of select="@name" /></dt>
            <dd><xsl:apply-templates/></dd>
        </xsl:for-each>
    </dl>
    </xsl:template>

    <xsl:template match="//abbr">
        <xsl:if test="@title">
            <xsl:variable name='abbr-title' select='@title'/>
            <abbr title='{$abbr-title}'><xsl:value-of select="."/></abbr>
        </xsl:if>
        <abbr><xsl:value-of select="."/></abbr>
    </xsl:template> 

    <xsl:template match="//acronym">
        <acronym><xsl:value-of select="."/></acronym>
    </xsl:template> 

    <!-- KEYWORD as it described in RFC2119 -->
    <xsl:template match="//keyword">
        <span class="rfc2119">
            <xsl:value-of select="." />
        </span>
    </xsl:template> 

    <xsl:template match="//block">
        <p class="block">
            <xsl:apply-templates/>
        </p>
    </xsl:template>


<!-- 
#
# Вставка SVG
# <svg file=file.svg/>
# Требование к файлу - обрезка и небольшой размер.
#
-->

<xsl:template match="//figure/svg">
    <!-- <xsl:variable name="fig_num">
        <xsl:number level="any" count="figure|svg" format="1"/>
    </xsl:variable>
    <a id="{concat('pic',$fig_num)}"><div> -->
            <xsl:text disable-output-escaping='yes'>&lt;object class="svg" data="</xsl:text>
            <xsl:value-of select="@file"/>
            <xsl:text disable-output-escaping='yes'>" type="image/svg+xml"&gt;&lt;/object&gt;</xsl:text>
        <!-- <p class="center"><xsl:text>Рисунок&#160;</xsl:text>
         <xsl:value-of select="$fig_num" /><xsl:text>. </xsl:text><xsl:value-of select="@name" />
         </p></div></a> -->
</xsl:template>

<!--
# Вставка пустых строк
# blankLines = 5 - количество
# без атрибута вставит одну
-->
<xsl:template match="//vspace[not(@blankLines)]">
  <br />
</xsl:template>

<xsl:template name="insert-blank-lines">
  <xsl:param name="no"/>
  <xsl:choose>
    <xsl:when test="$no &lt;= 0">
      <br/>
    </xsl:when>
    <xsl:otherwise>
      <br/>
      <xsl:call-template name="insert-blank-lines">
        <xsl:with-param name="no" select="$no - 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="//vspace[@blankLines]">
  <xsl:call-template name="insert-blank-lines">
    <xsl:with-param name="no" select="@blankLines"/>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>