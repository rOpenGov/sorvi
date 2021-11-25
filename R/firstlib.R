# When one has weighed the sun in the balance, and measured the
# steps of the moon, and mapped out the seven heavens star by star,
# there still remains oneself. Who can calculate the orbit of his own
# soul? - Oscar Wilde 

#' @importFrom utils read.csv

.onAttach <- function(lib, pkg)
{

  # This may help with encodings in Mac/Linux
  # Sys.setlocale(locale = "UTF-8")
  # Sys.setlocale(locale = "WINDOWS-1252")

  packageStartupMessage("sorvi - Tools for Finnish Open Data.\nCopyright (C) 2010-2021 Leo Lahti, Juuso Parkkinen, Juuso Haapanen, Einari Happonen, Jussi Paananen, Joona Lehtomaki and Pyry Kantanen \n\nhttp://github.com/ropengov/sorvi \n\n Hard sciences are successful because they deal with soft problems; \n soft sciences are struggling because they deal with hard problems.\n-                        Von Foerster\n")

}


