---
title: "sorvi tutorial"
author: rOpenGov core team
date: "2017-03-03"
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
government data. Your
[contributions](http://ropengov.github.io/contribute/), [bug reports
and other feedback](https://github.com/ropengov/sorvi) are welcome!


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
* [Generic synonyme converter](#synonymes) (Synonyymit)

[Finnish personal identification number (HETU)](#hetu) (Henkilotunnuksen kasittely)  

See also [other rOpenGov packages](http://ropengov.github.io/projects), in particular:

 * [gisfin](https://github.com/rOpenGov/gisfin/) Visualization of Finnish geographic information 
 * [helsinki](https://github.com/rOpenGov/helsinki/) Helsinki open data tools 
 * [sotkanet](https://github.com/rOpenGov/sotkanet/) THL Sotkanet database on health and demography
 * [pxweb](https://github.com/rOpenGov/pxweb/) PX-Web interface to access data fom Statistics Finland and other PX-Web compliant sources
 * [finpar](https://github.com/rOpenGov/finpar/) Finnish parliament data


## <a name="installation"></a>Installation

We assume you have installed [R](http://www.r-project.org/). If you
use [RStudio](http://www.rstudio.com/ide/download/desktop), change the
default encoding to UTF-8. Linux users should also install
[CURL](http://curl.haxx.se/download.html).

Install the stable release version in R:


```r
install.packages("sorvi")
```

Development version for developers:


```r
library(devtools)
install_github("ropengov/sorvi")
```

Test the installation by loading the library:


```r
library(sorvi)
```


We recommend setting the UTF-8 encoding:


```r
Sys.setlocale(locale="UTF-8") 
```

```
## [1] ""
```

Brief examples of the package tools are provided below. Further
examples are available in [Louhos-blog](http://louhos.wordpress.com)
and in our [Rmarkdown blog](http://louhos.github.io/archive.html).


## <a name="provinces"></a>Province information (Maakunnat)


### <a name="provincetranslations"></a>Finnish-English translations

**Finnish-English translations for province names**:


```r
translations <- load_sorvi_data("translation_provinces")
print(head(translations))
```

```
##                 English         Finnish
## 1         Åland Islands      Ahvenanmaa
## 2         South Karelia   Etelä-Karjala
## 3 Southern Ostrobothnia Etelä-Pohjanmaa
## 4      Southern Savonia      Etelä-Savo
## 5                Kainuu          Kainuu
## 6       Tavastia Proper      Kanta-Häme
```

Convert the given terms (for now, using tools from the bibliographica R package):


```r
# install_github("ropengov/bibliographica")
library(bibliographica) # Get some synonyme mapping tools
translated <- bibliographica::map(c("Varsinais-Suomi", "Lappi"), translations, from = "Finnish", to = "English", keep.names = TRUE)
head(translated)
```

```
##  Varsinais-Suomi            Lappi 
## "Finland Proper"        "Lapland"
```

## <a name="municipality"></a>Municipality information

Finnish municipality information is available through Statistics
Finland (Tilastokeskus; see
[pxweb](https://github.com/ropengov/pxweb) package) and Land Survey
Finland (Maanmittauslaitos). The row names for each data set are
harmonized and can be used to match data sets from different sources,
as different data sets may carry different versions of certain
municipality names.

### <a name="mml"></a>Land Survey Finland (municipality information)

Source: [Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu). See also the [gisfin](https://github.com/ropengov/gisfin) package for further Finnish GIS data sets.


```r
municipality.info.mml <- get_municipality_info_mml()
library(knitr)
kable(municipality.info.mml[1:2,])
```



|   | Kohderyhma| Kohdeluokk|AVI |Maakunta |Kunta |AVI_ni1                                   |AVI_ni2                                            |Maaku_ni1       |Maaku_ni2         |Kunta_ni1       |Kunta_ni2 |Kieli_ni1 |Kieli_ni2 |AVI.FI                                    |Kieli.FI |Maakunta.FI     |Kunta.FI        |
|:--|----------:|----------:|:---|:--------|:-----|:-----------------------------------------|:--------------------------------------------------|:---------------|:-----------------|:---------------|:---------|:---------|:---------|:-----------------------------------------|:--------|:---------------|:---------------|
|3  |         71|      84200|2   |02       |284   |Lounais-Suomen aluehallintovirasto        |Regionförvaltningsverket i Sydvästra Finland       |Varsinais-Suomi |Egentliga Finland |Koski Tl        |N_A       |Suomi     |N_A       |Lounais-Suomen aluehallintovirasto        |Suomi    |Varsinais-Suomi |Koski.Tl        |
|6  |         71|      84200|4   |06       |508   |Länsi- ja Sisä-Suomen aluehallintovirasto |Regionförvaltningsverket i Västra och Inre Finland |Pirkanmaa       |Birkaland         |Mänttä-Vilppula |N_A       |Suomi     |N_A       |Länsi- ja Sisä-Suomen aluehallintovirasto |Suomi    |Pirkanmaa       |Mänttä-Vilppula |


## <a name="conversions"></a>Conversions


### <a name="municipality2province"></a>Municipality-Province mapping

**Map all municipalities to correponding provinces**


```r
m2p <- municipality_to_province() 
head(m2p) # Just show the first ones
```

```
##           Koski.Tl    Mänttä-Vilppula          Äänekoski 
##  "Varsinais-Suomi"        "Pirkanmaa"      "Keski-Suomi" 
##             Ähtäri               Akaa           Alajärvi 
## "EtelÃ¤-Pohjanmaa"        "Pirkanmaa" "EtelÃ¤-Pohjanmaa"
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
kable(head(municipality_ids)) # just show the first entries
```



|          |id  |name            |
|:---------|:---|:---------------|
|3         |284 |Koski.Tl        |
|6         |508 |Mänttä-Vilppula |
|Äänekoski |992 |Äänekoski       |
|Ähtäri    |989 |Ähtäri          |
|Akaa      |020 |Akaa            |
|Alajärvi  |005 |Alajärvi        |


### <a name="synonymes"></a>Synonyme conversions

Generic conversion of synonymes into harmonized terms.

First, get a synonyme-name mapping table. In this example we harmonize Finnish municipality names that have multiple versions. But the synonyme list can be arbitrary.


```r
f <- system.file("extdata/municipality_synonymes.csv", package = "sorvi")
synonymes <- read.csv(f, sep = "\t")		 
```

Validate the synonyme list and add lowercase versions of the terms:


```r
synonymes <- bibliographica::check_synonymes(synonymes, include.lowercase = TRUE)
```

Convert the given terms from synonymes to the harmonized names:


```r
harmonized <- bibliographica::map(c("Mantta", "Koski.Tl"), synonymes)
head(harmonized)
```

```
## [1] "Mäntta"   "Koski Tl"
```


## <a name="hetu"></a>Personal identification number (HETU)

**Extracting information from a Finnish personal identification number**


```r
library(sorvi)
hetu("111111-111C")
```

```
##          hetu gender personal.number checksum       date day month year
## 1 111111-111C   Male             111        C 1911-11-11  11    11 1911
##   century.char
## 1            -
```

The function accepts also vectors as input, returning a data frame:


```r
library(knitr)
kable(hetu(c("010101-0101", "111111-111C")))
```



|hetu        |gender | personal.number|checksum |date       | day| month| year|century.char |
|:-----------|:------|---------------:|:--------|:----------|---:|-----:|----:|:------------|
|010101-0101 |Female |              10|1        |1901-01-01 |   1|     1| 1901|-            |
|111111-111C |Male   |             111|C        |1911-11-11 |  11|    11| 1911|-            |

**Extracting specific field**


```r
hetu(c("010101-0101", "111111-111C"), extract = "gender")
```

```
## [1] "Female" "Male"
```

**Validate Finnish personal identification number:**


```r
valid_hetu("010101-0101") # TRUE/FALSE
```

```
## [1] TRUE
```





### TODO

[TODO list of further data
sources](https://github.com/rOpenGov/sorvi/blob/master/vignettes/todo-datasets.md)


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
##   Einari Happonen and Jussi Paananen (rOpenGov 2010-2017).  sorvi:
##   Finnish open data toolkit for R.  URL:
##   http://github.com/rOpenGov/sorvi
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
## Many thanks for all contributors!
```

## Session info

This vignette was created with


```r
sessionInfo()
```

```
## R version 3.3.1 (2016-06-21)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 16.10
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
## [1] bibliographica_0.2.31 sorvi_0.8.13          tibble_1.2           
## [4] knitr_1.15.1         
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.9.3      magrittr_1.5       munsell_0.4.3     
##  [4] tm_0.6-2           colorspace_1.3-0   R6_2.2.0          
##  [7] highr_0.6          stringr_1.1.0      plyr_1.8.4        
## [10] dplyr_0.5.0        tools_3.3.1        babynames_0.2.1   
## [13] parallel_3.3.1     grid_3.3.1         data.table_1.10.0 
## [16] gtable_0.2.0       genderdata_0.5.0   DBI_0.5-1         
## [19] lazyeval_0.2.0     assertthat_0.1     NLP_0.1-9         
## [22] tidyr_0.6.1        reshape2_1.4.2     ggplot2_2.2.1     
## [25] stringdist_0.9.4.2 slam_0.1-38        evaluate_0.10     
## [28] stringi_1.1.3      gender_0.5.1       scales_0.4.1
```

To call in the statistician after the experiment is done may be no more than asking him to perform a post-mortem examination: he may be able to say what the experiment died of. ~ Sir Ronald Aylmer Fisher




