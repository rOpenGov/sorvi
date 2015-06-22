## Test environments
* local ubuntu 15.04, R 3.2.0
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There were 3 NOTEs:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Leo Lahti <louhos@googlegroups.com>’

License components with restrictions and base license permitting such:
  BSD_2_clause + file LICENSE
File 'LICENSE':
  YEAR: 2010-2015
  COPYRIGHT HOLDER: Leo Lahti, Juuso Parkkinen, Joona Lehtomaki, Juuso Haapanen, Jussi Paananen, Einari Happonen

* checking package dependencies ... NOTE
  No repository set, so cyclic dependency check skipped

* checking top-level files ... NOTE
Non-standard files/directories found at top level:
  ‘cran-comments.md’ ‘NEWS.md’



## Resubmission
This is a resubmission. In this version I have:

* Removed the problematic wikipedia URLs from the vignettes and code

