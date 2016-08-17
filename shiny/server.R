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
library(rgdal)	
polyCV <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\Thesis_maps",
		layer = "CV_huc", verbose = FALSE)
markGauge <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\sample_figures",
		layer = "active_93", verbose = FALSE)


function(input, output, session) {

#updateNavbarPage()	
	
# Map under the "Metrics" tab	
	output$busmap <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6)%>%
#						addMarkers(~long,~lat,popup=~as.character(site_no))
						addPolygons(data = polyCV,
								stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
						addCircleMarkers(data = markGauge,
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
				leafletProxy("busmap", data=markGauge) %>% clearPopups()
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
	output$map_Trends <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
					addPolygons(data = polyCV,
							stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
					addCircleMarkers(data = markGauge,
							radius = 5,
							color = "blue",
							stroke = FALSE, fillOpacity = 0.5,
							layerId = ~site_no)
		})

# DRAFT! Labeling "Trends" map with gauge number	

#showGaugePopup <- function(event) {
#		selectedGauge <- gauges$site_no[id]
#	content <- as.character(tagList(
#					tags$h4(paste("USGS ",event$id))
#			))
#	leafletProxy("map_Trends") %>% addPopups(lng=event$lng, lat=event$lat, popup=content)
#}
	observe({
			leafletProxy("map_Trends", data=markGauge) %>% clearPopups()
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

# Maps under the "Maps" tab
# full record map under "MAPS" tab
	output$map_full <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
						addPolygons(data = polyCV,
								stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
						addCircleMarkers(data = markGauge,
								radius = 5,
								color = "blue",
								stroke = FALSE, fillOpacity = 0.5,
								layerId = ~site_no)
			})
	
				
# post-impairment record map under "MAPS" tab
	output$map_pi <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
						addPolygons(data = polyCV,
								stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
						addCircleMarkers(data = markGauge,
								radius = 5,
								color = "blue",
								stroke = FALSE, fillOpacity = 0.5,
								layerId = ~site_no)
			})	

# Map under "STARR">"STARR" tab
	output$map_STARR <- renderLeaflet({
				leaflet(gauges) %>%
						addTiles(
								urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
								attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
						) %>%
						setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
						addPolygons(data = polyCV,
								stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
						addCircleMarkers(data = markGauge,
								radius = 5,
								color = "blue",
								stroke = FALSE, fillOpacity = 0.5,
								layerId = ~site_no)
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
					setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
					addPolygons(data = polyCV,
							stroke = TRUE, weight = 2, fillOpacity = 0.4, smoothFactor = TRUE) %>%
					addCircleMarkers(data = markGauge,
							radius = 5,
							color = "blue",
							stroke = FALSE, fillOpacity = 0.5,
							layerId = ~site_no)
		})		

# Maps under the "Allocation & Demand" tab (this shp file won't work on map_ad1)
	library(rgdal)	
	all_dem <- readOGR(dsn="C:\\Users\\kmstone5\\Google Drive\\SRA_Kathleen\\shiny_stuff\\sample_figures",
				layer = "all_dem", verbose = FALSE)

	output$map_ad1 <- renderLeaflet({
			leaflet(gauges) %>%
					addTiles(
							urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
							attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
					) %>%
					setView(lng = -120.42, lat = 37.52, zoom = 6) %>%
				addPolygons(data = all_dem,
							stroke = TRUE, fillOpacity = 0.5, smoothFactor = TRUE)
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
