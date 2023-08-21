## Test environments

* local macOS 13.5 install (aarch64-apple-darwin20 64-bit), R 4.3.1
* win-builder (devel and release)
* R-CMD-check workflow (macOS-latest, windows-latest, ubuntu-latest-devel, ubuntu-latest-release, ubuntu-latest-oldrel-1)

## R CMD check results

There were no ERRORs or WARNINGs. 

On win-builder check logs the following (possibly) invalid URLs are reported:

 URL: https://twitter.com/intent/follow?screen_name=ropengov
    From: README.md
    Status: 403
    Message: Forbidden
    
This is probably due to Twitter erroneously classifying traffic from win-builder as bot traffic and blocking it. No such error is reported on local tests.

## Downstream dependencies

There are currently no downstream dependencies for this package.