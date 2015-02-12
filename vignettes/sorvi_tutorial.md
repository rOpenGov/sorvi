---
title: "sorvi tutorial"
author: rOpenGov core team
date: "2015-02-12"
output:
  html_document:
    theme: flatly
---
<!--
%\VignetteEngine{knitr::rmarkdown}
%\VignetteIndexEntry{sorvi Markdown Vignette}
%\usepackage[utf8]{inputenc}
-->



Finnish open government data toolkit for R
===========

This R package provides miscellaneous tools for Finnish open
government data to complement other
[rOpenGov](http://ropengov.github.io/projects) packages with a more
specific scope. We also maintain a [todo list of further data
sources](https://github.com/rOpenGov/sorvi/blob/master/vignettes/todo-datasets.md)
to be added; your
[contributions](http://louhos.github.com/contact.html) and [bug
reports and other feedback](https://github.com/ropengov/sorvi) are
welcome! For further information, see the [home
page](http://louhos.github.com/sorvi).



## Available data sources and tools

[Installation](#installation) (Asennus)  

[Finnish provinces](#provinces) (Maakuntatason informaatio)

* [Basic province information](#provinceinfo) (Area, Population, Population Density)
* [Finnish-English province name translations](#provincetranslations)  

[Finnish municipalities](#municipality) (Kuntatason informaatio)

* [Land Survey Finland](#mml) (Maanmittauslaitos / MML)

[ID conversion tools](#conversions)

* [Municipality-Postal code conversions](#postalcodes) (Kunnat vs. postinumerot)  
* [Municipality name-ID conversions](#municipalityconversions) (Kunnat vs. kuntakoodit)
* [Municipality-province conversions](#municipality2province) (Kunnat vs. maakunnat)

[Finnish personal identification number (HETU)](#hetu) (Henkilotunnuksen kasittely)  

[Visualization tools](#visualization) (Visualisointirutiineja)



## <a name="installation"></a>Installation

We assume you have installed [R](http://www.r-project.org/). If you
use [RStudio](http://www.rstudio.com/ide/download/desktop), change the
default encoding to UTF-8. Linux users should also install
[CURL](http://curl.haxx.se/download.html).

Install the stable release version in R:


```r
install.packages("sorvi")
```

Test the installation by loading the library:


```r
library(sorvi)
```

Development version for developers:


```r
library(devtools)
install_github("ropengov/sorvi")
```

We also recommend setting the UTF-8 encoding:


```r
Sys.setlocale(locale="UTF-8") 
```

Brief examples of the package tools are provided below. Further
examples are available in [Louhos-blog](http://louhos.wordpress.com)
and in our [Rmarkdown blog](http://louhos.github.io/archive.html).


## <a name="provinces"></a>Province information (Maakunnat)


### <a name="provinceinfo"></a>Basic data

Source: [Wikipedia](http://fi.wikipedia.org/wiki/V%C3%A4est%C3%B6tiheys)


```r
tab <- get_province_info_wikipedia()
head(tab)
```

```
##          Province PopulationDensity
## 1         Uusimaa             170.4
## 2 Varsinais-Suomi              42.9
## 3       Satakunta              28.8
## 4      Kanta-Häme              32.7
## 5       Pirkanmaa              37.9
## 6     Päijät-Häme              38.9
```

### <a name="provincetranslations"></a>Finnish-English translations

**Finnish-English translations for province names** (we have not been able
to solve all encoding problems yet; solutions welcome!):


```r
translations <- load_sorvi_data("translations")
head(as.matrix(translations))
```

```
##                       [,1]              
## Ã\u0085land Islands   "Ahvenanmaa"      
## South Karelia         "EtelÃĪ-Karjala"  
## Southern Ostrobothnia "EtelÃĪ-Pohjanmaa"
## Southern Savonia      "EtelÃĪ-Savo"     
## Kainuu                "Kainuu"          
## Tavastia Proper       "Kanta-HÃĪme"
```


## <a name="municipality"></a>Municipality information

Finnish municipality information is available through Statistics
Finland (Tilastokeskus; see
[stafi](https://github.com/ropengov/statfi) package) and Land Survey
Finland (Maanmittauslaitos). The row names for each data set are
harmonized and can be used to match data sets from different sources,
as different data sets may carry different versions of certain
municipality names.

### <a name="mml"></a>Land Survey Finland (municipality information)

Source: [Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu). 


```r
municipality.info.mml <- get_municipality_info_mml()
print(municipality.info.mml[1:2,])
```

```
##           Kohderyhma Kohdeluokk AVI Maakunta Kunta
## Äänekoski         71      84200   4       13   992
## Ähtäri            71      84200   4       14   989
##                                             AVI_ni1
## Äänekoski Länsi- ja Sisä-Suomen aluehallintovirasto
## Ähtäri    Länsi- ja Sisä-Suomen aluehallintovirasto
##                                                      AVI_ni2
## Äänekoski Regionförvaltningsverket i Västra och Inre Finland
## Ähtäri    Regionförvaltningsverket i Västra och Inre Finland
##                 Maaku_ni1         Maaku_ni2 Kunta_ni1 Kunta_ni2 Kieli_ni1
## Äänekoski     Keski-Suomi Mellersta Finland Äänekoski       N_A     Suomi
## Ähtäri    Etelä-Pohjanmaa Södra Österbotten    Ähtäri    Etseri     Suomi
##           Kieli_ni2                                    AVI.FI Kieli.FI
## Äänekoski       N_A Länsi- ja Sisä-Suomen aluehallintovirasto    Suomi
## Ähtäri       Ruotsi Länsi- ja Sisä-Suomen aluehallintovirasto    Suomi
##                Maakunta.FI  Kunta.FI
## Äänekoski      Keski-Suomi Äänekoski
## Ähtäri    EtelÃ¤-Pohjanmaa    Ähtäri
```


## <a name="conversions"></a>Conversions

### <a name="postalcodes"></a>Postal codes vs. municipalities

Source: [Wikipedia](http://fi.wikipedia.org/wiki/Luettelo_Suomen_postinumeroista_kunnittain). The municipality names are provided also in plain ascii without special characters:


```r
postal.code.table <- get_postal_code_info() 
head(postal.code.table)
```

```
##   postal.code municipality municipality.ascii
## 1       07230       Askola             Askola
## 2       07500       Askola             Askola
## 3       07510       Askola             Askola
## 4       07530       Askola             Askola
## 5       07580       Askola             Askola
## 6       07590       Askola             Askola
```


### <a name="municipality2province"></a>Municipality-Province mapping

**Map all municipalities to correponding provinces**


```r
m2p <- municipality_to_province() 
head(m2p) # Just show the first ones
```

```
##           Äänekoski              Ähtäri                Akaa 
##       "Keski-Suomi"  "EtelÃ¤-Pohjanmaa"         "Pirkanmaa" 
##            Alajärvi           Alavieska              Alavus 
##  "EtelÃ¤-Pohjanmaa" "Pohjois-Pohjanmaa"  "EtelÃ¤-Pohjanmaa"
```

**Map selected municipalities to correponding provinces:**


```r
municipality_to_province(c("Helsinki", "Tampere", "Turku")) 
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```

**Speed up conversion with predefined info table:**


```r
m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku"), municipality.info.mml)
head(m2p)
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```


### <a name="municipalityconversions"></a>Municipality name-ID conversion

**Municipality name to code**


```r
convert_municipality_codes(municipalities = c("Turku", "Tampere"))
```

```
##   Turku Tampere 
##   "853"   "837"
```

**Municipality codes to names**


```r
convert_municipality_codes(ids = c(853, 837))
```

```
##       853       837 
##   "Turku" "Tampere"
```

**Complete conversion table**


```r
municipality_ids <- convert_municipality_codes()
head(municipality_ids) # just show the first entries
```

```
##            id      name
## Äänekoski 992 Äänekoski
## Ähtäri    989    Ähtäri
## Akaa      020      Akaa
## Alajärvi  005  Alajärvi
## Alavieska 009 Alavieska
## Alavus    010    Alavus
```



## <a name="hetu"></a>Personal identification number (HETU)

**Extract information from a Finnish personal identification number:**


```r
library(sorvi)
hetu("111111-111C")
```

```
## $hetu
## [1] "111111-111C"
## 
## $gender
## [1] "Male"
## 
## $personal.number
## [1] 111
## 
## $checksum
## [1] "C"
## 
## $date
## [1] "1911-11-11"
## 
## $day
## [1] 11
## 
## $month
## [1] 11
## 
## $year
## [1] 1911
## 
## $century.char
## [1] "-"
## 
## attr(,"class")
## [1] "hetu"
```

**Validate Finnish personal identification number:**


```r
valid_hetu("010101-0101") # TRUE/FALSE
```

```
## [1] TRUE
```



## <a name="visualization"></a>Visualization tools

Line fit with confidence smoothers (if any of the required libraries
are missing, install them with the install.packages command in R):


```r
library(sorvi) 
library(plyr)
library(RColorBrewer)
library(ggplot2)
data(iris)
p <- regression_plot(Sepal.Length ~ Sepal.Width, iris) 
print(p)
```

![plot of chunk regressionline](figure/regressionline-1.png) 




## Licensing and Citations

This work can be freely used, modified and distributed under the 
[Two-clause BSD license](http://en.wikipedia.org/wiki/BSD\_licenses).


```r
citation("sorvi")
```

```
## 
## Kindly cite the sorvi R package as follows:
## 
##   (C) Leo Lahti, Juuso Parkkinen, Joona Lehtomaki, Juuso Haapanen,
##   Einari Happonen and Jussi Paananen (rOpenGov 2011-2014).  sorvi:
##   Finnish open government data toolkit for R.  URL:
##   http://ropengov.github.com/sorvi
## 
## A BibTeX entry for LaTeX users is
## 
##   @Misc{,
##     title = {sorvi: Finnish open government data toolkit for R},
##     author = {Leo Lahti and Juuso Parkkinen and Joona Lehtomaki and Juuso Haapanen and Einari Happonen and Jussi Paananen},
##     doi = {10.5281/zenodo.10280},
##     year = {2011},
##   }
## 
## Many thanks for all contributors! See:
## http://louhos.github.com/contact.html
```

## Session info

This vignette was created with


```r
sessionInfo()
```

```
## R version 3.1.2 (2014-10-31)
## Platform: x86_64-pc-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] ggplot2_1.0.0      RColorBrewer_1.1-2 plyr_1.8.1        
## [4] sorvi_0.7.15       reshape_0.8.5      knitr_1.9         
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.8     evaluate_0.5.5   formatR_1.0     
##  [5] grid_3.1.2       gtable_0.1.2     labeling_0.3     MASS_7.3-37     
##  [9] munsell_0.4.2    proto_0.3-10     Rcpp_0.11.4      reshape2_1.4.1  
## [13] scales_0.2.4     stringr_0.6.2    tools_3.1.2      XML_3.98-1.1
```




