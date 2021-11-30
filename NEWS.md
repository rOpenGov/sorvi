# sorvi 0.8.17 (2021-11-30)

### NEW FEATURES

- New function: `get_ifpi_charts()` for scraping data from Musiikkituottajat - IFPI Finland ry charts

# sorvi 0.8.16 (2021-11-25)

### NEW FEATURES

- New function: `cran_downloads()` for getting information about package downloads and optionally visualizing them
- New function: `gh_issue_stats()` for downloading information about opened issues and pull requests from different repositories

### MINOR IMPROVEMENTS

- Using GitHub Actions for testing and building pkgdown website with rogtemplate, rendering README.md file
- Overall package cleaning and fixing warnings, errors and notes

### DEPRECATED AND DEFUNCT

- Removed hetu-related functions, tests and examples in vignette (now in separate hetu-package)

### DOCUMENTATION FIXES

- Option "eval=false" in vignette examples that relied on GitHub as a data repository; GitHub seemed to deny connections when data was downloaded several times during vignette rebuilding

# sorvi 0.8 (2017-03-02)
- Get data from GitHub

# sorvi 0.7.24 (2015-06-22)
- Removed get_postal_code_info
- Removed get_province_info  

# sorvi 0.7.24 (2014-06-04)

- Rewritten the package and moved many functions to other packages
- Updated vignette
 
# sorvi 0.4.03 (2013-09-29)

- Submitted to CRAN

# sorvi 0.4.01 (2013-09-29)

- Cleaned from warnings and errors in package conversion

# sorvi 0.2.03 (2012-10-26)

- Fixed problems in GetLukiot(), GetOikotie(), and GetHRIaluejakokartat(), includes some temporary fixes

# sorvi 0.2.00 (2012-10-24)

- Minor fixed in maps.R and HKK.R

# sorvi 0.1.83 (2012-09-03)
  
- Fixed a bug with handling years in hetu-function.

# sorvi 0.1.82 (2012-08-31)
  
- Added functions hetu and valid.hetu for processing Finnish personal identification numbers.

# sorvi 0.1.81 (2012-08-14)

- MML data Kunta.FI field updated: Lansi-Turunmaa -> Parainen; Pedersoren kunta -> Pedersore
- added R/datavaalit.R

# sorvi 0.1.79 (2012-08-08)

- removed data/ directory, moved rda files in beta.datavaalit.fi/storage/louhos and 
- added LoadData function

# sorvi 0.1.73 (2012-07-09)

- Removed several dependencies and made them marginal (see wiki for description)

# sorvi 0.1.71 (2012-05-12)

- GetMunicipalityInfo modified 
- added ConvertMunicipalityNames function
- added GetParliamentaryElectionData function
- GetMunicipalityInfoMML 
- GetMunicipalityInfoStatFi
- elections*.R functions added for datavaalit

# sorvi 0.1.59 (2012-03-10)

- Added functions GetOmakaupunki, GetPalvelukartta, GetThemeMap
- Joined files googlemaps.R and OpenStreetMap.R to file maps.R

# sorvi 0.1.58 (2012-03-06)

- XML removed from dependencies

# sorvi 0.1.57 (2012-02-28)

- added Seutukunta in MML data (via bug fix in GetShapeMML)
- spdep added to dependencies (required by GenerateMapColours)
- added function GenerateMapColours

# sorvi 0.1.55 (2012-02-26)

- GetMunicipalityInfo function updated: now retrieving comprehensive municipality-level information from Tilastokeskus and Maanmittauslaitos into a single table
- Added options to PlotShape function
  
# sorvi 0.1.54 (2012-02-26)

- Added loaders.R (for loading external data into .rda-files)
- HKK.R (including GetHKK) rewritten, major changes:
  - XLConnect no longer required
  - GetHKK returns a single SpatialPolygonsDataFrame instead a list of them
  - new function SplitSpatial splits a Spatial*DataFrame object into a list of individual objects based on a splitter field
- Updated presidentti2012_PKS_20120201.R to reflect changes in HKK.R

# sorvi 0.1.53 (2012-02-26)
- replaced RBGL with RColorBrewer in dependencies

# sorvi 0.1.51 (2012-02-26)

- replaced RBGL with RColorBrewer in dependencies

# sorvi 0.1.50 (2012-02-23)

- added stringOperations.R (Strip function)
 
# sorvi 0.1.49 (2012-02-13)

- added package name in front of rgdal and XML functions (XML::function) to handle warnings in package build
- removed special characters from vaalit.R

# sorvi 0.1.48 (2012-02-12)

- Added functions: GetVaalipiiri, GetElectionResultsPresidentti2012
- XML removed from dependencies (problems with R-forge Windows builds)
- px.R -> tilastokeskus.R

# sorvi 0.1.47 (2012-02-03)

- function PlotMatrix added
- RBGL added to dependencies, this is required by PlotMatrix

# sorvi 0.1.46 (2012-02-02)
  
- added matrixOperations.R: CenterData and UnitScale functions
- added functions for analyzing the Finnish presidential election data from Helsingin Sanomat in vaalit.R
- removed maakunta.R source file and removed function GetMaakuntainfo and merged with GetProvinceInfo
- in FindProvince function argument name change: municipality.list -> municipalities

# sorvi 0.1.44 (2011-12-31)

- updated GetShapeMML and documentation, and recreated MML.rda

# sorvi 0.1.43 (2011-12-29)

- GoogleStyleGuide issues completed
- examples updated
- vignette updated
- GitHub taken into use for release version

# sorvi 0.1.42 (2011-12-27)

- get.population.register -> GetPopulationRegister
- preprocess.px -> GetPXTilastokeskus
- shape2sorvi -> ReadShape
- visualize.shape -> PlotShape
- Added internal function is.url

# sorvi 0.1.41 (2011-12-27)

- WMS functionality included
- Added wms.R 
- Added functions PreprocessWMS, GetWMSlayers, LoadWMSurl, GetWMSraster and ListWMSurls
- Added internal functions BuildService and GetCapabilities
- Modified AllClasses.R
- Added classes WMS and WMSLayer
- Added example 20111127-OIVAwms.R

# sorvi 0.1.40 (2011-12-26)

- get.geocode.GoogleMaps -> GetGeocodeGoogleMaps
- get.staticmap.GoogleMaps -> GetStaticmapGoogleMaps
- get.geocode.OpenStreetMap -> GetGeocodeOpenStreetMap
- preprocess.PKS.aluejakokartat -> GetHRIaluejakokartat
- preprocess.PKS.lukiot -> GetLukiot
- getPresidentti2012Data -> GetPresidentti2012
- load.migration.data -> GetWorldbankMigration
- load.apurahat -> GetApurahat
- preprocess.Oikotie -> GetOikotie
- Removed datasets: Oikotie, PKS.lukiot (use Get-functions instead)
- Added and updated examples and Louhos-articles

# sorvi 0.1.39 (2011-12-24)

- get.postal.codes -> GetPostalCodeInfo
- get.province.info -> GetProvinceInfo
- get.municipality.info -> GetMunicipalityInfo
- municipality2province -> FindProvince
- get.hsy -> GetHSY
- preprocess.shape.mml -> PreprocessShapeMML
- Added internal function GetShapeMML to provide the details on original MML data preprocessing


# sorvi 0.1.38 (2011-12-22)

- Changes to follow R Style Guide
- get.gadm -> GetGADM; now converting all names into UTF-8; also some changes to output
- gadm.position2region -> FindGADMPosition2Region; also some changes to output
- Added internal function: ConvertGADMResolution

# sorvi 0.1.36 (2011-12-21)
- get.gadm: alue -> map / fixed taso / added korvaa.skandit
  
# sorvi 0.1.34 (2011-12-20)

- Roxygenization completed. The package documentation now generated for instance with library(devtools); document("pkg")

# sorvi 0.1.32 (2011-12-19)

- Changed several R file names to more general ones (Juuso)
- ROxygen fields added to googlemaps.R, HRI.R, koulut.R, kulttuuri.R, Oikotie.R, OpenStreetMap.R, vaalit.R, worldbank.R
- Documented PKS.lukiot, Oikotie, and PKS.aluejakokartat data sets in data.documentation.R

# sorvi 0.1.31 (2011-12-18)

- get.vaestorekisteri -> get.population.register
- Roxygen fields added to HSY.R, mml.R, population.register.R, px.R, visualization.R
- roxygen removed from dependencies
- added data.documentation.R for Roxygen documentation of the sorvi data sets; documented MML and translations data sets

# sorvi 0.1.30 (2011-12-18)

- get.gadm: argument name change: alue -> resolution
- get.maakuntatiedot.R -> get.province.info.R
- added sorvi-package.R
- Roxygen fields added to gadm.R, get.postal.codes.R, get.province.info.R. Also moved urls in function arguments from within the functions where applicable
- roxygen added to dependencies

# sorvi 0.1.29 (2011-12-11)

- added vaalit.R which contains getPresidentti2012Data

# sorvi 0.1.28 (2011-12-09)

- added HSY.R which contains get.hsy function; this was unintentionally missing from version 0.1.27

# sorvi 0.1.27 (2011-12-06)

- added get.hsy function for automated retrieval of HSY data
- removed HSY data
- get.postinumerot -> get.postal.codes
 
# sorvi 0.1.26 (2011-12-05)

- get.maakuntatiedot -> get.province.info
- Added functions get.municipality.info, get.province.info, municipality2province

# sorvi 0.1.25 (2011-12-04)

- Added HSY data

# sorvi 0.1.23 (2011-11-15)
- Lisatty funktiot load.migration.data()

# sorvi 0.1.22 (2011-11-12)
- Lisatty funktiot load.apurahat() ja load.maakuntakartta()
 
# sorvi 0.1.14 (2011-10-30)
- MML:n datat lisatty valmiiksi esikasiteltyna data(MML)-objektiin (data/MML.rda)
- funktionimet muutettu englanninkielisiksi: hae -> get; putsaa -> preprocess

#sorvi 0.1.13 (2011-10-24)
- Dokumentointia paivitetty versiosta 0.1.11.

#sorvi 0.1.11 (2011-10-23)
- Juuson ensimmainen paivitys
- Datoja: Oikotie, paakaupunkiseudun aluejakokartat, lukiot
- Funktiot yll? olevian datojen muokkaamiseen
- Funktioita RGoogleMapsin kayttoon
- HUOM! Dokumentaatio osin puutteellista!

# sorvi 0.1.09 (2011-10-18)

- mml.R Maanmittauslaitoksen datoille apufunktioita

# sorvi 0.1.08 (2011-10-18)

- vignetteen esimerkkeja aineistohauista ym.
- Maanmittauslaitoksen karttadatoja lisatty inst/extdata/Maanmittauslaitos/

# sorvi 0.1.04 (2011-10-09)

- hae.postinumerot: Suomen kuntien ja postinumeroiden mappaamiseen
- korvaa.skandit: apufunktio skandien kasittelyyn

# sorvi 0.1.03 (2011-10-09)

- Valineita vaestorekisterikeskuksen datan screenscrapingiin (hae.vaestorekisteri) ja GADM-muotoisen karttadatan hakuun (hae.gadm)

# sorvi 0.1.01 (2011-10-06)

- Eka versio

