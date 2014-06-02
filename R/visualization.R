#' Description: Draw regression curve with smoothed error bars 
#' based on the Visuprintally-Weighted Regression by Solomon M. Hsiang; see
#' http://www.fight-entropy.com/2012/07/visually-weighted-regression.html
#' The R implementation is based on Felix Schonbrodt's code from 
#' http://www.nicebread.de/visually-weighted-watercolor-plots-new-variants-please-vote/
#'
#' Arguments:
#'   @param formula formula
#'   @param data data
#'   @param title title
#'   @param B number bootstrapped smoothers
#'   @param shade plot the shaded confidence region?
#'   @param shade.alpha shade.alpha: should the CI shading fade out at 
#'          the edges? (by reducing alpha; 0 = no alpha decrease, 
#'	    0.1 = medium alpha decrease, 0.5 = strong alpha decrease)
#'   @param spag plot spaghetti lines?
#'   @param mweight should the median smoother be visually weighted?
#'   @param show.lm should the linear regresison line be plotted?
#'   @param show.median show median smoother
#'   @param median.col median color
#'   @param show.CI should the 95\% CI limits be plotted?
#'   @param method the fitting function for the spaghettis; default: loess
#'   @param bw define a default b/w-palette (TRUE/FALSE)
#'   @param slices number of slices in x and y direction for the shaded
#'     region. Higher numbers make a smoother plot, but takes longer to
#'     draw. I wouldn'T go beyond 500
#'   @param palette provide a custom color palette for the watercolors
#'   @param ylim restrict range of the watercoloring
#'   @param quantize either "continuous", or "SD". In the latter case, 
#'     we get three color regions for 1, 2, and 3 SD (an idea of John Mashey)
#'   @param .progress Progress information for ddply
#'   @param ... further parameters passed to the fitting function, 
#'     in the case of loess, for example, "span = .9", or 
#'     "family = 'symmetric'"
#'
#' Returns:
#'   @return ggplot2 object
#'
#' @export 
#'
#' @import plyr
#' @import RColorBrewer
#' @importFrom reshape melt
#' @import ggplot2
#'
#' @examples \dontrun{library(sorvi); library(plyr); library(RColorBrewer); 
#'   	     	      library(reshape); library(ggplot2); data(iris); 
#'		      p <- regression_plot(Sepal.Length ~ Sepal.Width, iris)}
#' @aliases vwReg
#' @references See citation("microbiome") 
#' @author Based on the original version from Felix Schonbrodt. 
#'         Modified by Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @keywords utilities

regression_plot <- function(formula, data, title="", B=1000, shade=TRUE, shade.alpha=.1, spag=FALSE, mweight=TRUE, show.lm=FALSE, show.median = TRUE, median.col = "white", show.CI=FALSE, method=loess, bw=FALSE, slices=200, palette=colorRampPalette(c("#FFEDA0", "#DD0000"), bias=2)(20), ylim=NULL, quantize = "continuous",  .progress = "none", ...) {

  # Circumvent warnings
  . <- NULL
  aes <- NULL

  # ------------------

  # Circumvent global variable binding warnings
  x <- NA
  y <- NA
  dens.scaled <- NA
  alpha.factor <- NA
  value <- NA
  group <- NA
  M <- NA
  w3 <- NA
  UL <- NA
  LL <- NA

  # ------------------

  IV <- all.vars(formula)[2]
  DV <- all.vars(formula)[1]
  data <- na.omit(data[order(data[, IV]), c(IV, DV)])

  if (bw) palette <- colorRampPalette(c("#EEEEEE", "#999999", "#333333"), bias=2)(20)

  message("Computing boostrapped smoothers ...")
  newx <- data.frame(seq(min(data[, IV]), max(data[, IV]), length=slices))
  colnames(newx) <- IV
  l0.boot <- matrix(NA, nrow=nrow(newx), ncol=B)
  l0 <- method(formula, data)
  for (i in 1:B) {
    data2 <- data[sample(nrow(data), replace=TRUE), ]
    data2 <- data2[order(data2[, IV]), ]

    if (class(l0)=="loess") {
      m1 <- method(formula, data2, control = loess.control(surface = "i", statistics="a", trace.hat="a"), ...)
    } else {
      m1 <- method(formula, data2, ...)
    }
      l0.boot[, i] <- predict(m1, newdata=newx)
    }

    # compute median and CI limits of bootstrap
    CI.boot <- adply(l0.boot, 1, function(x) quantile(x, prob=c(.025, .5, .975, pnorm(c(-3, -2, -1, 0, 1, 2, 3))), na.rm=TRUE))[, -1]
    colnames(CI.boot)[1:10] <- c("LL", "M", "UL", paste0("SD", 1:7))
    CI.boot$x <- newx[, 1]
    CI.boot$width <- CI.boot$UL - CI.boot$LL

    # scale the CI width to the range 0 to 1 and flip it (bigger numbers = narrower CI)
    CI.boot$w2 <- (CI.boot$width - min(CI.boot$width))
    CI.boot$w3 <- 1-(CI.boot$w2/max(CI.boot$w2))

    message("convert bootstrapped spaghettis to long format")
    b2 <- melt(l0.boot)
    b2$x <- newx[,1]
    colnames(b2) <- c("index", "B", "value", "x")

    p1 <- ggplot(data, aes_string(x=IV, y=DV)) + theme_bw()
    if (shade) {
       quantize <- match.arg(quantize, c("continuous", "SD"))

       if (quantize == "continuous") {
       	  message("Computing density estimates for each vertical cut ...")
      	  flush.console()
      	  if (is.null(ylim)) {
          min_value <- min(min(l0.boot, na.rm=TRUE), min(data[, DV], na.rm=TRUE))
          max_value <- max(max(l0.boot, na.rm=TRUE), max(data[, DV], na.rm=TRUE))
          ylim <- c(min_value, max_value)
      }

      # vertical cross-sectional density estimate
      d2 <- ddply(b2[, c("x", "value")], .(x), function(df) {
        res <- data.frame(density(df$value, na.rm = TRUE, n = slices, from=ylim[[1]], to=ylim[[2]])[c("x", "y")])

        colnames(res) <- c("y", "dens")
        return(res)
      }, .progress=.progress)

      maxdens <- max(d2$dens)
      mindens <- min(d2$dens)
      d2$dens.scaled <- (d2$dens - mindens)/maxdens

      ## Tile approach
      d2$alpha.factor <- d2$dens.scaled^shade.alpha
      p1 <- p1 + geom_tile(data=d2, aes(x=x, y=y, fill=dens.scaled, alpha=alpha.factor)) + scale_fill_gradientn("dens.scaled", colours=palette) + scale_alpha_continuous(range = c(0.001, 1))
    }   

    if (quantize == "SD") {
      message("Polygon approach")
      SDs <- melt(CI.boot[, c("x", paste0("SD", 1:7))], id.vars="x")
      count <- 0
      d3 <- data.frame()
      col <- c(1,2,3,3,2,1)
      for (i in 1:6) {
        seg1 <- SDs[SDs$variable == paste0("SD", i), ]
	seg2 <- SDs[SDs$variable == paste0("SD", i+1), ]
	seg <- rbind(seg1, seg2[nrow(seg2):1, ])
	seg$group <- count
	seg$col <- col[i]
	count <- count + 1
	d3 <- rbind(d3, seg)
     }

     p1 <- p1 + geom_polygon(data=d3, aes(x=x, y=value, color=NULL, fill=col, group=group)) + scale_fill_gradientn("dens.scaled", colours=palette, values=seq(-1, 3, 1))
     }
  }

  message("Build ggplot figure ...")
  flush.console()
  if (spag==TRUE) {
    p1 <- p1 + geom_path(data=b2, aes(x=x, y=value, group=B), size=0.7, alpha=10/B, color="darkblue")
  }

  if (show.median) {
    if (mweight) {
      p1 <- p1 + geom_path(data=CI.boot, aes(x=x, y=M, alpha=w3^3), size=.6, linejoin="mitre", color=median.col)
    } else {
      p1 <- p1 + geom_path(data=CI.boot, aes(x=x, y=M), size = 0.6, linejoin="mitre", color=median.col)
    }
  }

  # Confidence limits
  if (show.CI) {
    p1 <- p1 + geom_path(data=CI.boot, aes(x=x, y=UL, group=B), size=1, color="red")
    p1 <- p1 + geom_path(data=CI.boot, aes(x=x, y=LL, group=B), size=1, color="red")
  }

  # plain linear regression line
  if (show.lm) {
    p1 <- p1 + geom_smooth(method="lm", color="darkgreen", se=FALSE)
  }

  p1 <- p1 + geom_point(size=1, shape=21, fill="white", color="black")

  if (title != "") {
    p1 <- p1 + ggtitle(title)
  }

  p <- p1 + guides(color = "none") # + opts(legend.position="none")

  p 

}





#' Visualize a matrix with one or two-way color scale. 
#' TODO: one-way color scale
#' 
#' This function is used for fast investigation of matrix objects; standard visualization choices are made
#' automatically; fast and easy-to-use but does not necessarily provide optimal visualization.
#'
#' @param mat matrix
#' @param type String. Specifies visualization type. Options: "oneway" (color scale ranges from white to dark red; the color can be changed if needed); "twoway" (color scale ranges from dark blue through white to dark red; colors can be changed if needed)
#' @param midpoint middle point for the color plot: smaller values are shown with blue, larger are shown with red in type = "twoway"
#' @param palette Optional. Color palette.
#' @param colors Optional. Colors.
#' @param col.breaks breakpoints for the color palette
#' @param interval interval for palette color switches
#' @param plot.axes String. Indicates whether to plot x-axis ("x"), y-axis ("y"), or both ("both").
#' @param row.tick interval for plotting row axis texts
#' @param col.tick interval for plotting column axis texts
#' @param cex.xlab use this to specify distinct font size for the x axis
#' @param cex.ylab use this to specify distinct font size for the y axis
#' @param xlab optional x axis labels
#' @param ylab optional y axis labels
#' @param limit.trunc color scale limit breakpoint
#' @param mar image margins
#' @param ... optional parameters to be passed to function 'image', see help(image) for further details
#' @return A list with the color palette (colors), color breakpoints (breaks), and palette function (palette.function)
#' @export
#' @references See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples library(sorvi)
#'           mat <- rbind(c(1,2,3,4,5), c(1, 3, 1,1,1), c(4,2,2,1,2)); 
#'	     plot_matrix(mat, "twoway", midpoint = 3) 
#'
#' @keywords utilities

plot_matrix <- function (mat, type = "twoway", midpoint = 0, 
	      	        palette = NULL, colors = NULL, col.breaks = NULL, interval = .1, 
			plot.axes = "both",
			row.tick = 1, col.tick = 1, 
			cex.xlab = .9, cex.ylab = .9, 
			xlab = NULL, ylab = NULL,
			limit.trunc = 0, mar = c(5, 4, 4, 2), ...) {

  # Center the data and color breakpoints around the specified midpoint
  mat <- mat - midpoint

  if (length(col.breaks) == 0)  {
    m <- max(round(max(abs(mat)), limit.trunc) - interval, 0)
    mm <- m + interval/2
    vals <- seq(interval/2,mm,interval)
    # Set col.breaks evenly around zero
    col.breaks  <- c(-(m + 1e6), c(-rev(vals), vals), m+1e6)
  }
		  
  if (is.null(palette)) {
    my.palette <- colorRampPalette(c("blue", "white", "red"), space = "rgb")
  } else if (palette == "blue-black-red") {
    my.palette <- colorRampPalette(c("blue", "black", "red"), space = "rgb")
  } else if (palette == "blue-white-red") {
    my.palette <- colorRampPalette(c("blue", "white", "red"), space = "rgb")
  } else if (palette == "blue-white-yellow") {
    my.palette <- colorRampPalette(c("blue", "white", "yellow"), space = "rgb")
  } else if (palette == "blue-black-yellow") {
    my.palette <- colorRampPalette(c("blue", "black", "yellow"), space = "rgb")
  } else if (palette == "bw") {
    gray.palette <- function (int) {
      gray(seq(0,1,length=int))
    }
    my.palette <- gray.palette
  }

  # if mycolors is provided it overrides palette
  if (is.null(colors)) { colors <- my.palette(length(col.breaks) - 1) }
	   		      
  # transpose and revert row order to plot matrix in the same way it
  # appears in its numeric form
  par(mar = mar)
  image(t(mat[rev(seq(nrow(mat))),]), col = colors, xaxt = 'n', yaxt = 'n', zlim = range(col.breaks), breaks = col.breaks, ...)

  if (plot.axes == "both" || plot.axes == TRUE) {
    
    if (is.null(xlab)) {
      v <- seq(1, ncol(mat), col.tick) # take every nth index
      axis(1, at = seq(0,1,length = ncol(mat))[v], labels = colnames(mat)[v], cex.axis=cex.xlab, las=2, ...)    
    } else {
      axis(1, at = seq(0,1,length = ncol(mat)), labels = xlab, cex.axis=cex.xlab, las=2, ...)    
    }

    if (is.null(ylab)) {
      v <- seq(1, nrow(mat), row.tick) # take every nth index
      axis(2, at = seq(0,1,length = nrow(mat))[v], labels = rev(rownames(mat))[v], cex.axis=cex.ylab, las=2, ...)
    } else {  
      axis(2, at = seq(0,1,length = nrow(mat)), labels = ylab, cex.axis=cex.ylab, las=2, ...)
    }

  } else if (plot.axes == "x") {

    if (is.null(xlab)) {
      v <- seq(1, ncol(mat), col.tick) # take every nth index
      axis(1, at = seq(0,1,length = ncol(mat))[v], labels = colnames(mat)[v], cex.axis=cex.xlab, las=2)    
    } else {
      axis(1, at = seq(0,1,length = ncol(mat)), labels = xlab, cex.axis=cex.xlab, las=2)    
    }

  } else if (plot.axes == "y") {

    if (is.null(ylab)) {
      v <- seq(1, nrow(mat), row.tick) # take every nth index
      axis(2, at = seq(0, 1, length = nrow(mat))[v], labels = rev(rownames(mat))[v], cex.axis = cex.xlab, las = 2)
    } else {  
      axis(2, at = seq(0, 1, length = nrow(mat)), labels = ylab, cex.axis=cex.xlab, las=2)
    }
  }
  
  # Return default margins
  par(mar = c(5, 4, 4, 2) + 0.1)
 
  return(list(colors = colors, breaks = col.breaks + midpoint, palette.function = my.palette))
      	  
}


#' Visualize color scale for PlotMatrix output
#' NOTE: Experimental. To be tested thoroughly.
#' 
#' @param breaks breakpoints for colors
#' @param colors Optional. Colors.
#' @param m overrides breaks, mypalette and produces a plot that ranges (-m,m)
#' @param label.step step between label text plotting
#' @param interval interval for palette color switches
#' @param two.sided indicates one- or two-sided color palette
#' @param label.start start point for the labels
#' @param Nlab number of labels
#' @param palette.function palette color scale function
#' @param ndigits number of digits to plot
#' @param ... optional parameters to be passed to function 'axis', 
#'        see help(axis) for further detai
#' @return A list with the color palette (palette), 
#'         color breakpoints (breaks), 
#'         and palette function (palette.function)
#' @references See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples # Experimental 
#' #library(sorvi)
#' #mat <- rbind(c(1,2,3,4,5), c(1, 3, 1), c(4,2,2)); 
#' #pm <- plot_matrix(mat, "twoway", midpoint = 3); 
#' #plot_scale(pm$colors, pm$breaks)
#'
#' @keywords utilities

plot_scale <- function (breaks, colors = NULL, m = NULL, label.step = 2, interval=.1, two.sided = TRUE, label.start = 1.00, Nlab = 3, palette.function = NULL, ndigits = 2, ...) {

  if (two.sided) {
    
    if (length(m)>0) {
      breaks <- set_breaks(m, interval)
      image(t(as.matrix(seq(-mm, mm, length = 100))), col = colors, xaxt = 'n', yaxt = 'n', zlim = range(breaks), breaks=breaks)
    } else {
      image(t(as.matrix(breaks)), col = colors, xaxt = 'n',yaxt = 'n', zlim = range(breaks), breaks = breaks)
    }
  
    mm1 <- sort(breaks)[[2]]
    mm2 <- rev(sort(breaks))[[2]]
    
    tmp <- unlist(strsplit(as.character(mm1),"\\."))

    digit.step <-10^(-ndigits)
    labs <- round(seq(mm1, mm2, by = digit.step), ndigits)
    start.position <- which.min(abs(round(labs, ndigits) - (-label.start)))
    end.position <- length(labs) - 1 
    inds <- seq(start.position, end.position, length = Nlab)
      
    axis(2, at = seq(0, 1, length = Nlab), labels = labs[inds], las=2, ...)
  }

  if (!two.sided) {

    mm <- max(breaks) + 1e6 # infty
    m <- max(breaks)
 
    labs <- seq(0,m,label.step)
    #inds = sapply(labs,function(lab){min(which(lab<=breaks))})
    start.position <- which.min(abs(round(labs, ndigits) - (-label.start)))
    end.position <- which.min(abs(round(labs, ndigits) - (label.start)))
    inds <- seq(start.position,end.position,length=Nlab)  

    image(t(as.matrix(seq(0, m, length = 100))), col = colors, xaxt='n', yaxt='n', zlim=range(breaks), breaks=breaks)
    
    axis(2, at = seq(0, 1, length=Nlab), labels=labs[inds], las=2, ...)
  }
  
}


#' Set breaks for color palette. Internal function.
#'
#' @param mat data matrix or vector for which the breaks will be deterined 
#' @param interval interval of color breaks
#' @return A vector of breakpoints
#' @references See citation("sorvi") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#'
#' @keywords internal

set_breaks <- function (mat, interval=.1) {
  if (max(abs(mat))>1) {
    m <- floor(max(abs(mat)))
  } else {
    m <- round(max(abs(mat)),nchar(1/interval)-1)
  }

  mm <- m + interval/2
  vals <- seq(interval/2,mm,interval)
  # Note: the first and last values mimic infinity
  mybreaks  <- c(-(m+1e6),c(-rev(vals),vals),m+1e6)
  mybreaks
}



