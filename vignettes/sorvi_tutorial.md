\VignetteEngine{knitr::knitr}
\VignetteIndexEntry{sorvi Markdown Vignette made with knitr}

<!--
Joissakin esimerkeissa tarvittavat riippuvuudet 
	<a href="http://trac.osgeo.org/gdal/wiki/DownloadSource">GDAL</a>, 
	<a href="http://freeglut.sourceforge.net/">freeglut</a>, 
	<a href="http://xmlsoft.org/downloads.html">XML</a>, 
	<a href="http://trac.osgeo.org/geos">GEOS</a> ja 
	<a href="http://trac.osgeo.org/proj">PROJ.4</a>. 

-->

Finnish open government data toolkit for R
===========

sorvi provides miscellaneous tools for Finnish open government data to
complement other [rOpenGov](http://ropengov.github.io/projects)
packages with a more specific scope. We also maintain a [todo
list of further data sources](https://github.com/rOpenGov/sorvi/blob/master/vignettes/todo-datasets.md) to be added; your
[contributions are
welcome](http://louhos.github.com/contact.html). For further
information, see the [home page](http://louhos.github.com/sorvi).


### Available data sources and tools

 * [Installation](#installation) (Asennus)
 * [Finnish population register](#populationregister) (Vaestorekisteri)
 * [Finnish postal codes](#postalcodes) (Postinumerodata)
 * [Finnish municipalities](#municipality) (Kuntatason informaatio)
 * [Finnish provinces](#provinces) (Maakuntatason informaatio)
 * [Translations](#translations) (Suomi-Englanti-kaannoksia)
 * [IP address geographic coordinates](#ip) (IP-osoitteen koordinaatit)
 * [Finnish personal identification number (HETU)](#hetu) (Henkilotunnuksen kasittely)
 * [Visualization tools](#visualization) (Visualisointirutiineja)


### <a name="installation"></a>Installation

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

We also recommend setting the UTF-8 encoding:


```r
Sys.setlocale(locale="UTF-8") 
```

Brief examples of the package tools are provided below. Further
examples are available in [Louhos-blog](http://louhos.wordpress.com)
and in our [Rmarkdown blog](http://louhos.github.io/archive.html).

### <a name="populationregister"></a>Finnish population register

Municipality-level population information from [Finnish population register](http://vrk.fi/default.aspx?docid=5127&site=3&id=0) (Vaestokeskus): 


```r
library(sorvi)
df <- get_population_register()
head(df)
```

```
##           Koodi     Kunta    Kommun  Male Female Total
## Äänekoski   992 Äänekoski Äänekoski 10187  10121 20308
## Ähtäri      989    Ähtäri    Etseri  3231   3222  6453
## Akaa        020      Akaa      Akaa  8452   8637 17089
## Alajärvi    005  Alajärvi  Alajärvi  5226   5214 10440
## Alavieska   009 Alavieska Alavieska  1420   1350  2770
## Alavus      010    Alavus    Alavus  4619   4634  9253
```


### <a name="postalcodes"></a>Postal codes

Finnish postal codes vs. municipalities table from
[Wikipedia](http://fi.wikipedia.org/wiki/Luettelo_Suomen_postinumeroista_kunnittain). The
municipality names are provided also in plain ascii without special
characters:


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



### <a name="municipality"></a>Municipality data

Finnish municipality information is available through Population
Registry (Vaestorekisterikeskus), Statistics Finland (Tilastokeskus)
and Land Survey Finland (Maanmittauslaitos). The row names for each
data set are harmonized and can be used to match data sets from
different sources, as different data sets may carry slightly different
versions of certain municipality names. 

**Land Survey Finland municipality information** ([Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)). 


```r
municipality.info.mml <- get_municipality_info_mml()
municipality.info.mml[1:2,]
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

**Statistics Finland municipality information** ([Tilastokeskus](http://pxweb2.stat.fi/Database/Kuntien%20perustiedot/Kuntien%20perustiedot/Kuntaportaali.px))


```r
library(pxR) # can be installed with install.packages("pxR")
library(reshape) # can be installed with install.packages("reshape")
municipality.info.statfi <- get_municipality_info_statfi()
municipality.info.statfi[1:2,]
```

```
##                Alue Maapinta-ala, km2 1.1.2013 Taajama-aste, % 1.1.2012
## Äänekoski Äänekoski                        884                     76.1
## Ähtäri       Ähtäri                        805                     61.9
##           Väkiluku 31.12.2013 Väkiluvun muutos, % 2012 - 2013
## Äänekoski               20077                            -0.9
## Ähtäri                   6271                            -1.4
##           0-14 -vuotiaiden osuus väestöstä, % 31.12.2013
## Äänekoski                                           17.3
## Ähtäri                                              15.1
##           15-64 -vuotiaiden osuus väestöstä, % 31.12.2013
## Äänekoski                                            60.2
## Ähtäri                                               59.1
##           65 vuotta täyttäneiden osuus väestöstä, % 31.12.2013
## Äänekoski                                                 22.4
## Ähtäri                                                    25.8
##           Ruotsinkielisten osuus väestöstä, % 31.12.2013
## Äänekoski                                            0.1
## Ähtäri                                               0.0
##           Ulkomaiden kansalaisten osuus väestöstä, % 31.12.2013
## Äänekoski                                                   1.1
## Ähtäri                                                      0.8
##           Kuntien välinen muuttovoitto/-tappio, henkilöä 2012
## Äänekoski                                                 -67
## Ähtäri                                                    -35
##           Syntyneiden enemmyys, henkilöä 2012
## Äänekoski                                 -14
## Ähtäri                                    -20
##           Perheiden lukumäärä 31.12.2012
## Äänekoski                           5570
## Ähtäri                              1807
##           Valtionveronalaiset tulot, euroa/tulonsaaja  2011
## Äänekoski                                             23540
## Ähtäri                                                21744
##           Asuntokuntien lukumäärä 31.12.2012
## Äänekoski                               9624
## Ähtäri                                  2957
##           Vuokra-asunnossa asuvien asuntokuntien osuus, % 31.12.2012
## Äänekoski                                                       26.0
## Ähtäri                                                          20.3
##           Rivi- ja pientaloissa asuvien asuntokuntien osuus asuntokunnista, % 31.12.2012
## Äänekoski                                                                           65.1
## Ähtäri                                                                              86.8
##           Kesämökkien lukumäärä 31.12.2012
## Äänekoski                             2551
## Ähtäri                                1354
##           Vähintään keskiasteen tutkinnon suorittaneiden osuus 15 vuotta täyttäneistä, % 31.12.2012
## Äänekoski                                                                                      64.0
## Ähtäri                                                                                         64.7
##           Korkea-asteen tutkinnon suorittaneiden osuus 15 vuotta täyttäneistä, % 31.12.2012
## Äänekoski                                                                              19.6
## Ähtäri                                                                                 20.0
##           Kunnassa olevien työpaikkojen lukumäärä 31.12.2011
## Äänekoski                                               7972
## Ähtäri                                                  2453
##           Työllisten osuus 18-74-vuotiaista, % 31.12.2012
## Äänekoski                                            52.5
## Ähtäri                                               54.4
##           Työttömyysaste, % 31.12.2012
## Äänekoski                         17.5
## Ähtäri                            11.6
##           Kunnassa asuvan työllisen työvoiman määrä 31.12.2012
## Äänekoski                                                 7390
## Ähtäri                                                    2410
##           Asuinkunnassaan työssäkäyvien osuus työllisestä työvoimasta, % 31.12. 2011
## Äänekoski                                                                       77.3
## Ähtäri                                                                          77.3
##           Alkutuotannon työpaikkojen osuus, % 31.12.2011
## Äänekoski                                            2.8
## Ähtäri                                               9.1
##           Jalostuksen työpaikkojen osuus, % 31.12.2011
## Äänekoski                                         43.7
## Ähtäri                                            27.7
##           Palvelujen työpaikkojen osuus, % 31.12.2011
## Äänekoski                                        52.5
## Ähtäri                                           62.0
##           Toimialaltaan tuntemattomien työpaikkojen osuus, % 31.12.2011
## Äänekoski                                                           1.0
## Ähtäri                                                              1.2
##           Taloudellinen huoltosuhde, työvoiman ulkopuolella tai työttömänä olevat yhtä työllistä kohti 31.12.2012
## Äänekoski                                                                                                    1.74
## Ähtäri                                                                                                       1.64
##           Eläkkeellä olevien osuus väestöstä, % 31.12.2012
## Äänekoski                                             28.5
## Ähtäri                                                31.8
##           Yritystoimipaikkojen lukumäärä 2012     Kunta
## Äänekoski                                 987 Äänekoski
## Ähtäri                                    478    Ähtäri
```


**List the province for each municipality in Finland:**

```r
# All municipalities
m2p <- municipality_to_province() 
head(m2p) # Just show the first ones
```

```
##           Äänekoski              Ähtäri                Akaa 
##       "Keski-Suomi"  "EtelÃ¤-Pohjanmaa"         "Pirkanmaa" 
##            Alajärvi           Alavieska              Alavus 
##  "EtelÃ¤-Pohjanmaa" "Pohjois-Pohjanmaa"  "EtelÃ¤-Pohjanmaa"
```

```r
# Selected municipalities
municipality_to_province(c("Helsinki", "Tampere", "Turku")) 
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```

```r
# Speeding up with predefined municipality info table:
m2p <- municipality_to_province(c("Helsinki", "Tampere", "Turku"), municipality.info.mml)
head(m2p)
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```

**Convert municipality codes and names** (see
help(convert_municipality_codes) for all options):


```r
# Municipality name to code
convert_municipality_codes(municipalities = c("Turku", "Tampere"))
```

```
##   Turku Tampere 
##   "853"   "837"
```

```r
# Municipality codes to names
convert_municipality_codes(ids = c(853, 837))
```

```
##       853       837 
##   "Turku" "Tampere"
```

```r
# Complete conversion table
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


### <a name="provinces"></a>Province information

Get Finnish province information from [Wikipedia](http://fi.wikipedia.org/wiki/V%C3%A4est%C3%B6tiheys):


```r
tab <- get_province_info_wikipedia()
head(tab)
```

```
##          Province  Area Population PopulationDensity
## 1         Uusimaa  9132    1550362             170.4
## 2 Varsinais-Suomi 10664     457789              42.9
## 3       Satakunta  7956     229360              28.8
## 4      Kanta-Häme  5199     169952              32.7
## 5       Pirkanmaa 12446     472181              37.9
## 6     Päijät-Häme  5127     199235              38.9
```

### <a name="translations"></a>Translations

**Finnish-English translations** for province names (we have not been able
to solve all encoding problems yet; suggestions very welcome!):


```r
translations <- load_sorvi_data("translations")
head(translations)
```

```
##   Ã\u0085land Islands         South Karelia Southern Ostrobothnia 
##          "Ahvenanmaa"      "EtelÃĪ-Karjala"    "EtelÃĪ-Pohjanmaa" 
##      Southern Savonia                Kainuu       Tavastia Proper 
##         "EtelÃĪ-Savo"              "Kainuu"         "Kanta-HÃĪme"
```


### <a name="ip"></a>IP Location

Geographic coordinates for a given IP-address from
[Data Science Toolkit](http://www.datasciencetoolkit.org/):


```r
ip_location("137.224.252.10")
```

```
## [1] "51.9667015075684" "5.66669988632202"
```

### <a name="hetu"></a>Personal identification number (HETU)

Extract information from a Finnish personal identification number:


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

Validate Finnish personal identification number:


```r
valid_hetu("010101-0101") # TRUE/FALSE
```

```
## [1] TRUE
```



### <a name="visualization"></a>Visualization tools

Line fit with confidence smoothers (if any of the required libraries
are missing, install them with the install.packages command in R):


```r
library(sorvi) 
library(plyr)
library(RColorBrewer)
library(reshape)
library(ggplot2)
data(iris)
p <- regression_plot(Sepal.Length ~ Sepal.Width, iris) 
print(p)
```

![plot of chunk regressionline](figure/regressionline.png) 




## Licensing and Citations

This work can be freely used, modified and distributed under the 
[Two-clause BSD license](http://en.wikipedia.org/wiki/BSD\_licenses).

Kindly cite the work as follows


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
## R version 3.1.0 (2014-04-10)
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
##  [1] sp_1.0-15          ggplot2_1.0.0      RColorBrewer_1.0-5
##  [4] sorvi_0.6.1        reshape_0.8.5      pxR_0.40.0        
##  [7] plyr_1.8.1         RJSONIO_1.2-0.2    reshape2_1.4      
## [10] stringr_0.6.2      knitr_1.6         
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.5   formatR_0.10    
##  [5] grid_3.1.0       gtable_0.1.2     labeling_0.2     lattice_0.20-29 
##  [9] MASS_7.3-33      munsell_0.4.2    proto_0.3-10     Rcpp_0.11.1     
## [13] scales_0.2.4     tools_3.1.0      XML_3.98-1.1
```




