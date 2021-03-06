# TODO: Add comment
# 
# Author: tiffn_000
###############################################################################


MKT <- function(input){
	if(!require(Kendall)){
		install.packages("Kendall")
		library(Kendall)
	}
#
	if (missing(input))
		stop("Input data is required.")
	
	if(length(input[[1]])==6){
		
		MKL <- vector("list",6)
		names(MKL) <- names(input$daydf)
		for(i in 1:6){
			MKL[[i]] <- vector("list",2)
			names(MKL[[i]]) <- c("MKTday", "MKTvol")
			MKL[[i]][[1]] <- MannKendall(input$daydf[[i]]$dayfracabove)
			MKL[[i]][[2]] <- MannKendall(input$voldf[[i]]$volfracabove)
		}
		return(MKL)
	} else {
		MKday <- MannKendall(input$daydf$dayfracabove)
		MKvol <- MannKendall(input$voldf$volfracabove)
		out <- list(MKTday=MKday, MKTvol=MKvol)
		return(out)
	}
}

FracAboveExtract <- function(input){
	if(!require(Kendall)){
		install.packages("Kendall")
		library(Kendall)
	}
#
	if (missing(input))
		stop("Input data is required.")
	
	if(length(input[[1]])==6){
		
		FracAbove <- vector("list",6)
		names(FracAbove) <- names(input$daydf)
		for(i in 1:6){
			FracAbove[[i]] <- vector("list",4)
			names(FracAbove[[i]]) <- c("FracAboveday", "FracAbovevol", "VolAbvMAF","startyear")
			FracAbove[[i]][[1]] <-input$daydf[[i]]$dayfracabove
			FracAbove[[i]][[2]] <-input$voldf[[i]]$volfracabove
			FracAbove[[i]][[3]] <-input$voldf[[i]]$volabvMAF
			FracAbove[[i]][[4]] <-input$daydf[[i]]$startyear
		}
		return(FracAbove)
	} else {
		FracAboveday <- input$daydf$dayfracabove
		FracAbovevol <- input$voldf$volfracabove
		VolAbvMAF <- input$voldf$volabvMAF
		startyear <- input$daydf$startyear
		out <- list(FracAboveday=FracAboveday, FracAbovevol=FracAbovevol, VolAbvMAF=VolAbvMAF, startyear=startyear)
		return(out)
	}
}
