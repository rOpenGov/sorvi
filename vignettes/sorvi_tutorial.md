<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{sorvi Markdown Vignette made with knitr}

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
list](todo-datasets) of further data sources to be added; your
[contributions are
welcome](http://louhos.github.com/contact.html). For further
information, see the [home page](http://louhos.github.com/sorvi).


## Installation

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
Sys.setlocale(locale = "UTF-8")
```


Brief examples of the package tools are provided below. Further
examples are available in [Louhos-blog](http://louhos.wordpress.com)
and in our [Rmarkdown blog](http://louhos.github.io/archive.html).


### Personal identification number (HETU)

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
valid_hetu("010101-0101")  # TRUE/FALSE
```

```
## [1] TRUE
```


### Postal codes

Get Finnish postal codes vs. municipalities table from Wikipedia


```r
postal.code.table <- get_postal_code_info()
```

```
## Warning: incomplete final line found on
## 'http://fi.wikipedia.org/wiki/Luettelo_Suomen_postinumeroista_kunnittain'
```

```r
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


### IP Location

Get geographic coordinates for a given IP-address from
[datasciencetoolkit](http://www.datasciencetoolkit.org//ip2coordinates/):


```r
ip_location("137.224.252.10")
```

```
## [1] "51.9667015075684" "5.66669988632202"
```



### Municipality information

Finnish municipality information is available through Population
Registry (Vaestorekisterikeskus), Statistics Finland (Tilastokeskus)
and Land Survey Finland (Maanmittauslaitos). The row names for each
data set are harmonized and can be used to match data sets from
different sources, as different data sets may carry slightly different
versions of certain municipality names. Examples for each case:

Finnish municipality information from Land Survey Finland ([Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)). 


```r
municipality.info.mml <- get_municipality_info_mml()
municipality.info.mml[1:2, ]
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


Get information of Finnish provinces from Statistics Finland ([Tilastokeskus](http://pxweb2.stat.fi/Database/Kuntien%20perustiedot/Kuntien%20perustiedot/Kuntaportaali.px))


```r
municipality.info.statfi <- get_municipality_info_statfi()
```

```
## Error: could not find function "str_locate_all"
```

```r
municipality.info.statfi[1:2, ]
```

```
## Error: object 'municipality.info.statfi' not found
```


List the province for each municipality in Finland:

```r

# Specific municipalities
m2p <- find_province(c("Helsinki", "Tampere", "Turku"))
head(m2p)
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```

```r

# All municipalities
m2p <- find_province(municipality.info.statfi$Kunta)
```

```
## Error: object 'municipality.info.statfi' not found
```

```r

# Speeding up with predefined municipality info table:
m2p <- find_province(c("Helsinki", "Tampere", "Turku"), municipality.info.mml)
head(m2p)
```

```
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
```


Convert municipality codes and names:

```r
municipality_ids <- convert_municipality_codes()
head(municipality_ids)
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


Translate municipality names Finnish/English:


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


### Retrieve population register data

Municipality-level population information from [Vaestorekisterikeskus](http://vrk.fi/default.aspx?docid=5127&site=3&id=0):


```r
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


### Province information

Get information of Finnish provinces from Wikipedia:


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



### Visualization routines

Line fit with confidence smoothers:


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

Kindly cite the work, if appropriate, as 'Leo Lahti, Juuso Parkkinen,
Joona Lehtomaki et al. (2014). sorvi - R tools for Finnish open
government data. URL: http://louhos.github.com/sorvi'. A full list of
authors and contributors and contact information is
[here](http://louhos.github.com/contact).

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
## [1] ggplot2_0.9.3.1    reshape_0.8.5      RColorBrewer_1.0-5
## [4] plyr_1.8.1         sp_1.0-15          sorvi_0.4.30      
## [7] knitr_1.5         
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.5   formatR_0.10    
##  [5] grid_3.1.0       gtable_0.1.2     labeling_0.2     lattice_0.20-29 
##  [9] MASS_7.3-32      munsell_0.4.2    proto_0.3-10     pxR_0.40.0      
## [13] Rcpp_0.11.1      reshape2_1.4     RJSONIO_1.2-0.2  scales_0.2.4    
## [17] stringr_0.6.2    tools_3.1.0      XML_3.98-1.1
```





