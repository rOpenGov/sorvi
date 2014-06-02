<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{sorvi Markdown Vignette made with knitr}
-->

Finnish open government data toolkit for R
===========

This is an R package for Finnish open government data. New
contributions are [welcome!](http://louhos.github.com/contact.html).

This work is part of the [rOpenGov](http://ropengov.github.com)
project.

We also maintain a [todo list](todo-datasets) of further data sources
to be added. Contributions welcome!

## Installation

General users (CRAN release version):


```r
install.packages("sorvi")
library(sorvi)
```

Developers (Github development version):


```r
install.packages("devtools")
library(devtools)
install_github("sorvi", "ropengov")
library(sorvi)
```

Further installation and development instructions can be found at the
project [home page](http://ropengov.github.com/sorvi). 


## Using the package

For further usage
examples, see [Louhos-blog](http://louhos.wordpress.com) and
[Datawiki](https://github.com/louhos/sorvi/wiki/Data).


### Personal identification number (HETU)

Extracting information from a Finnish personal identification number:


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

Validating Finnish personal identification number:


```r
valid_hetu("010101-0101") # TRUE/FALSE
```

```
## [1] TRUE
```

### Postal codes

Get Finnish postal codes vs. municipalities table from Wikipedia


```r
postal.code.table <- get_postal_code_info() 
head(postal.code.table)
```

### IP Location

Get geographic coordinates for a given IP-address from 
http://www.datasciencetoolkit.org//ip2coordinates/


```r
ip_location("137.224.252.10")
```

```
## [1] "51.9667015075684" "5.66669988632202"
```


### Municipality information

Finnish municipality information is available through Population
Registry (Vaestorekisterikeskus), Statistics Finland (Tilastokeskus)
and Land Survey Finland (Maanmittauslaitos). We provide separate
download routine for each data set. The row names are in harmonized
format and can be used to match data sets from different sources, as
different data sets may carry slightly different versions of certain
municipality names. Examples for each case:

Finnish municipality information from Land Survey Finland ([Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)). 


```r
municipality.info.mml <- get_municipality_info_mml()
municipality.info.mml[1:2,]
```

Get information of Finnish provinces from Statistics Finland ([Tilastokeskus](http://pxweb2.stat.fi/Database/Kuntien%20perustiedot/Kuntien%20perustiedot/Kuntaportaali.px))


```r
municipality.info.statfi <- get_municipality_info_statfi()
municipality.info.statfi[1:2,]
```

List the province for each municipality in Finland:

```r
# Specific municipalities
m2p <- find_province(c("Helsinki", "Tampere", "Turku")) 
head(m2p)

# All municipalities
m2p <- find_province(municipality.info.statfi$Kunta) 

# Speeding up with predefined municipality info table:
m2p <- find_province(c("Helsinki", "Tampere", "Turku"), municipality.info.mml)
head(m2p)
```

Convert municipality codes and names:

```r
municipality_ids <- convert_municipality_codes()
head(municipality_ids)
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

Plot matrix:


```r
mat <- rbind(c(1,2,3), c(1, 3, 1), c(4,2,2)); 
pm <- plot_matrix(mat, "twoway", midpoint = 2) 
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 

```r
# Plotting the scale
# sc <- plot_scale(pm$colors, pm$breaks)
```

## Licensing and Citations

This work can be freely used, modified and distributed under the 
[Two-clause BSD license](http://en.wikipedia.org/wiki/BSD\_licenses).

Kindly cite the work, if appropriate, as 'Leo Lahti, Juuso Parkkinen,
Joona Lehtomaki ym. (2014). sorvi - suomalainen avoimen datan
tyokalupakki. URL: http://louhos.github.com/sorvi)'. A full list of
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
## [1] ggplot2_1.0.0      reshape_0.8.5      RColorBrewer_1.0-5
## [4] plyr_1.8.1         sorvi_0.4.30       knitr_1.6         
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.5   formatR_0.10    
##  [5] grid_3.1.0       gtable_0.1.2     labeling_0.2     MASS_7.3-33     
##  [9] munsell_0.4.2    proto_0.3-10     pxR_0.40.0       Rcpp_0.11.1     
## [13] reshape2_1.4     RJSONIO_1.2-0.2  scales_0.2.4     stringr_0.6.2   
## [17] tools_3.1.0      XML_3.98-1.1
```




