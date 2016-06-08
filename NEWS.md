CHANGES IN VERSION 0.7.24 (2015-06-22)
  o Removed get_postal_code_info
  o Removed get_province_info  

CHANGES IN VERSION 0.7.24 (2014-06-04)

 o Rewritten the package and moved many functions to other packages
 o Updated vignette
 
CHANGES IN VERSION 0.4.03 (2013-09-29)

 o Submitted to CRAN

CHANGES IN VERSION 0.4.01 (2013-09-29)

 o Cleaned from warnings and errors in package conversion

CHANGES IN VERSION 0.2.03 (2012-10-26)

 o Fixed problems in GetLukiot(), GetOikotie(), and GetHRIaluejakokartat(), includes some temporary fixes

CHANGES IN VERSION 0.2.00 (2012-10-24)

 o Minor fixed in maps.R and HKK.R

CHANGES IN VERSION 0.1.83 (2012-09-03)
  
  o Fixed a bug with handling years in hetu-function.

CHANGES IN VERSION 0.1.82 (2012-08-31)
  
  o Added functions hetu and valid.hetu for processing Finnish personal identification numbers.

CHANGES IN VERSION 0.1.81 (2012-08-14)

  o MML data Kunta.FI field updated: Lansi-Turunmaa -> Parainen;
    Pedersoren kunta -> Pedersore
  o added R/datavaalit.R

CHANGES IN VERSION 0.1.79 (2012-08-08)

  o removed data/ directory, moved rda files in beta.datavaalit.fi/storage/louhos and 
  o added LoadData function

CHANGES IN VERSION 0.1.73 (2012-07-09)

  o Removed several dependencies and made them marginal (see wiki for description)

CHANGES IN VERSION 0.1.71 (2012-05-12)

  o GetMunicipalityInfo modified 
  o added ConvertMunicipalityNames function
  o added GetParliamentaryElectionData function
  o GetMunicipalityInfoMML 
  o GetMunicipalityInfoStatFi
  o elections*.R functions added for datavaalit

CHANGES IN VERSION 0.1.59 (2012-03-10)

  o Added functions GetOmakaupunki, GetPalvelukartta, GetThemeMap
  o Joined files googlemaps.R and OpenStreetMap.R to file maps.R

CHANGES IN VERSION 0.1.58 (2012-03-06)

  o XML removed from dependencies

CHANGES IN VERSION 0.1.57 (2012-02-28)

  o added Seutukunta in MML data (via bug fix in GetShapeMML)
  o spdep added to dependencies (required by GenerateMapColours)
  o added function GenerateMapColours

CHANGES IN VERSION 0.1.55 (2012-02-26)

  o GetMunicipalityInfo function updated: now retrieving comprehensive 
    municipality-level information from Tilastokeskus and 
    Maanmittauslaitos into a single table
  o Added options to PlotShape function
  
CHANGES IN VERSION 0.1.54 (2012-02-26)

 o Added loaders.R (for loading external data into .rda-files)
 o HKK.R (including GetHKK) rewritten, major changes:
  - XLConnect no longer required
  - GetHKK returns a single SpatialPolygonsDataFrame instead a list of them
  - new function SplitSpatial splits a Spatial*DataFrame object into a list 
    of individual objects based on a splitter field
 o Updated presidentti2012_PKS_20120201.R to reflect changes in HKK.R

CHANGES IN VERSION 0.1.53 (2012-02-26)
 o replaced RBGL with RColorBrewer in dependencies

CHANGES IN VERSION 0.1.51 (2012-02-26)

  o replaced RBGL with RColorBrewer in dependencies

CHANGES IN VERSION 0.1.50 (2012-02-23)

 o added stringOperations.R (Strip function)
 
CHANGES IN VERSION 0.1.49 (2012-02-13)

 o added package name in front of rgdal and XML functions
   (XML::function) to handle warnings in package build
 o removed special characters from vaalit.R

CHANGES IN VERSION 0.1.48 (2012-02-12)

 o Added functions: GetVaalipiiri, GetElectionResultsPresidentti2012
 o XML removed from dependencies (problems with R-forge Windows builds)
 o px.R -> tilastokeskus.R

CHANGES IN VERSION 0.1.47 (2012-02-03)

 o function PlotMatrix added
 o RBGL added to dependencies, this is required by PlotMatrix

CHANGES IN VERSION 0.1.46 (2012-02-02)
  
 o added matrixOperations.R: CenterData and UnitScale functions
 o added functions for analyzing the Finnish presidential election data from
   Helsingin Sanomat in vaalit.R
 o removed maakunta.R source file and removed function GetMaakuntainfo
   and merged with GetProvinceInfo
 o in FindProvince function argument name change: municipality.list ->
   municipalities

CHANGES IN VERSION 0.1.44 (2011-12-31)

 o updated GetShapeMML and documentation, and recreated MML.rda

CHANGES IN VERSION 0.1.43 (2011-12-29)

 o GoogleStyleGuide issues completed
 o examples updated
 o vignette updated
 o GitHub taken into use for release version

CHANGES IN VERSION 0.1.42 (2011-12-27)

 o get.population.register -> GetPopulationRegister
 o preprocess.px -> GetPXTilastokeskus
 o shape2sorvi -> ReadShape
 o visualize.shape -> PlotShape
 o Added internal function is.url

CHANGES IN VERSION 0.1.41 (2011-12-27)

 o WMS functionality included
 o Added wms.R 
 o Added functions PreprocessWMS, GetWMSlayers, LoadWMSurl, 
   GetWMSraster and ListWMSurls
 o Added internal functions BuildService and GetCapabilities
 o Modified AllClasses.R
 o Added classes WMS and WMSLayer
 o Added example 20111127-OIVAwms.R

CHANGES IN VERSION 0.1.40 (2011-12-26)

 o get.geocode.GoogleMaps -> GetGeocodeGoogleMaps
 o get.staticmap.GoogleMaps -> GetStaticmapGoogleMaps
 o get.geocode.OpenStreetMap -> GetGeocodeOpenStreetMap
 o preprocess.PKS.aluejakokartat -> GetHRIaluejakokartat
 o preprocess.PKS.lukiot -> GetLukiot
 o getPresidentti2012Data -> GetPresidentti2012
 o load.migration.data -> GetWorldbankMigration
 o load.apurahat -> GetApurahat
 o preprocess.Oikotie -> GetOikotie
 o Removed datasets: Oikotie, PKS.lukiot (use Get-functions instead)
 o Added and updated examples and Louhos-articles

CHANGES IN VERSION 0.1.39 (2011-12-24)

  o get.postal.codes -> GetPostalCodeInfo
  o get.province.info -> GetProvinceInfo
  o get.municipality.info -> GetMunicipalityInfo
  o municipality2province -> FindProvince
  o get.hsy -> GetHSY
  o preprocess.shape.mml -> PreprocessShapeMML
  o Added internal function GetShapeMML to provide the details on
    original MML data preprocessing


CHANGES IN VERSION 0.1.38 (2011-12-22)

  o Changes to follow R Style Guide
  o get.gadm -> GetGADM; now converting all names into UTF-8; also
    some changes to output
  o gadm.position2region -> FindGADMPosition2Region; also some changes
    to output
  o Added internal function: ConvertGADMResolution

CHANGES IN VERSION 0.1.36 (2011-12-21)
  o get.gadm: alue -> map / fixed taso / added korvaa.skandit
  
CHANGES IN VERSION 0.1.34 (2011-12-20)

 o Roxygenization completed. The package documentation now generated
   for instance with library(devtools); document("pkg")

CHANGES IN VERSION 0.1.32 (2011-12-19)

 o Changed several R file names to more general ones (Juuso)
 o ROxygen fields added to googlemaps.R, HRI.R, koulut.R, kulttuuri.R, Oikotie.R, OpenStreetMap.R, vaalit.R, worldbank.R
 o Documented PKS.lukiot, Oikotie, and PKS.aluejakokartat data sets in data.documentation.R

CHANGES IN VERSION 0.1.31 (2011-12-18)

 o get.vaestorekisteri -> get.population.register
 o Roxygen fields added to HSY.R, mml.R, population.register.R, px.R,
   visualization.R
 o roxygen removed from dependencies
 o added data.documentation.R for Roxygen documentation of the sorvi
   data sets; documented MML and translations data sets

CHANGES IN VERSION 0.1.30 (2011-12-18)

 o get.gadm: argument name change: alue -> resolution
 o get.maakuntatiedot.R -> get.province.info.R
 o added sorvi-package.R
 o Roxygen fields added to gadm.R, get.postal.codes.R,
   get.province.info.R. Also moved urls in function arguments
   from within the functions where applicable
 o roxygen added to dependencies

CHANGES IN VERSION 0.1.29 (2011-12-11)

 o added vaalit.R which contains getPresidentti2012Data

CHANGES IN VERSION 0.1.28 (2011-12-09)

 o added HSY.R which contains get.hsy function; this was
 unintentionally missing from version 0.1.27

CHANGES IN VERSION 0.1.27 (2011-12-06)

 o added get.hsy function for automated retrieval of HSY data
 o removed HSY data
 o get.postinumerot -> get.postal.codes
 
CHANGES IN VERSIOn 0.1.26 (2011-12-05)

 o get.maakuntatiedot -> get.province.info
 o Added functions get.municipality.info, get.province.info,
 municipality2province

CHANGES IN VERSIOn 0.1.25 (2011-12-04)

 o Added HSY data

CHANGES IN VERSIOn 0.1.23 (2011-11-15)
 o Lisatty funktiot load.migration.data()

CHANGES IN VERSIOn 0.1.22 (2011-11-12)
 o Lisatty funktiot load.apurahat() ja load.maakuntakartta()
 
CHANGES IN?VERSION?0.1.14?(2011-10-30)
  o MML:n datat lisatty valmiiksi esikasiteltyna data(MML)-objektiin
    (data/MML.rda)
  o funktionimet muutettu englanninkielisiksi: hae -> get; putsaa ->
    preprocess

CHANGES IN?VERSION?0.1.13?(2011-10-24)
  o Dokumentointia paivitetty versiosta 0.1.11.

CHANGES IN?VERSION?0.1.11?(2011-10-23)
  o Juuson ensimmainen p?ivitys
  o Datoja: Oikotie, paakaupunkiseudun aluejakokartat, lukiot
  o Funktiot yll? olevian datojen muokkaamiseen
  o Funktioita RGoogleMapsin kayttoon
  o HUOM! Dokumentaatio osin puutteellista!

CHANGES IN VERSION 0.1.09 (2011-10-18)

  o mml.R Maanmittauslaitoksen datoille apufunktioita

CHANGES IN VERSION 0.1.08 (2011-10-18)

  o vignetteen esimerkkeja aineistohauista ym.
  o Maanmittauslaitoksen karttadatoja lisatty inst/extdata/Maanmittauslaitos/

CHANGES IN VERSION 0.1.04 (2011-10-09)

  o hae.postinumerot: Suomen kuntien ja postinumeroiden mappaamiseen
  o korvaa.skandit: apufunktio skandien kasittelyyn

CHANGES IN VERSION 0.1.03 (2011-10-09)

  o Valineita vaestorekisterikeskuksen datan screenscrapingiin
    (hae.vaestorekisteri) ja GADM-muotoisen karttadatan hakuun (hae.gadm)

CHANGES IN VERSION 0.1.01 (2011-10-06)

  o Eka versio

