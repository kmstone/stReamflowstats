# TODO: Add comment
# 
# Author: kmstone5
###############################################################################

library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(curl) # make the jsonlite suggested dependency explicit
library(ggplot2)
setwd("C:\\Users\\kmstone5\\git\\stReamflowstats\\shiny")



gauges <- read.csv("gauges.csv")
row.names(gauges)<- paste(gauges$site_no)

function(input, output, session) {
	
# Map under the "Metrics" tab	
	output$busmap <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6)%>%
#						addMarkers(~long,~lat,popup=~as.character(site_no))
						addCircleMarkers(~long,~lat,
								radius = 5,
								color = "blue",
								stroke = FALSE, fillOpacity = 0.5,
								layerId = ~site_no
						#popup = ~paste("USGS ",as.character(site_no))
						)
			})
	
# Labeling "Metrics" map with gauge number	
	showGaugePopup <- function(event) {
#		selectedGauge <- gauges$site_no[id]
		content <- as.character(tagList(
						tags$h4(paste("USGS ",event$id))
				))
		leafletProxy("busmap") %>% addPopups(lng=event$lng, lat=event$lat, popup=content)
	}
	
#	# When "Metrics" map is clicked, show a popup of plot below map
	observe({
				leafletProxy("busmap", data=gauges) %>% clearPopups()
				event <- input$busmap_marker_click
				if (is.null(event))
					return()
				
				isolate({
							##					leafletProxy("busmap") %>% addPopups(lng=event$lng,
							##							lat=event$lat, popup=c("blah"))
							d <- data.frame(x=seq(1,10,1),y=rnorm(10))
							plotd <- ggplot(d,aes(x,y)) + geom_point() + ggtitle(paste(event$id))
							#x <- c(1,2,3,4,5)
							#plotd <- hist(x, breaks = "Sturges", main = paste("Histogram of Specific Gauge"), xlab = "year", ylab = "value")
							output$plot_d <- renderPlot({
										plotd
									})
							showGaugePopup(event)
						})
			})		
# Map under the "Trends" tab
	library(rgdal)	
	trendPoint <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\Thesis_maps",
		layer = "CV_huc", verbose = FALSE)
	trendPoint2 <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\sample_figures",
			layer = "active_93", verbose = FALSE)
	output$map_Trends <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
					addPolygons(data = trendPoint,
							stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5) %>%
					addCircleMarkers(data = trendPoint2,
							radius = 5,
							color = "blue",
							stroke = FALSE, fillOpacity = 0.5,
							layerId = ~site_no)
		})		
	observe({
			leafletProxy("map_Trends", data=trendPoint2) %>% clearPopups()
			event <- input$map_Trends_marker_click
			if (is.null(event))
				return()
			
			isolate({
						##					leafletProxy("busmap") %>% addPopups(lng=event$lng,
						##							lat=event$lat, popup=c("blah"))
						d <- data.frame(x=seq(1,10,1),y=rnorm(10))
						plottrend <- ggplot(d,aes(x,y)) + geom_point() + ggtitle(paste(event$id))
						#x <- c(1,2,3,4,5)
						#plotd <- hist(x, breaks = "Sturges", main = paste("Histogram of Specific Gauge"), xlab = "year", ylab = "value")
						output$plot_trend <- renderPlot({
									plottrend
								})
						showGaugePopup(event)
					})
		})
	
# full record map under "MAPS" tab
	output$map_full <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6)
			})	
# post-impairment record map under "MAPS" tab
	output$map_pi <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6)
			})	

# Map under "STARR">"STARR" tab
	library(rgdal)	
	states <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\Thesis_maps",
				layer = "CV_huc", verbose = FALSE)
	output$map_STARR <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
						addPolygons(data = states,
								stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5)
			})		
# DRAFT! Labeling "STARR" map with classifications	
	showClassPopup <- function(event) {
		content <- as.character(tagList(
						tags$h4(paste("USGS ",event$id))
				))
		leafletProxy("map_STARR") %>% addPopups(popup=content)
	}
	
# Map under the "OMR" tab
	library(rgdal)	
#	trendPoint <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\trends\\trends_layer packages\\",
#		layer = "trends_full_dec_feb_vol", verbose = FALSE)
	output$map_OMR <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6) 
#			%>% addMarkers(data = trendPoint)
		})		

# Maps under the "Allocation & Demand" tab (this shp file won't work on map_ad1)
#	library(rgdal)	
#	alldem <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\sample_figures",
#				layer = "all_dem", verbose = FALSE)

	output$map_ad1 <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6) 
	#					%>%
	#				addPolygons(data = alldem,
	#						stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5)
		})	

	output$map_ad2 <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6)
		})	

}
