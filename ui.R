# TODO: Add comment
# 
# Author: kmstone5
###############################################################################

library(shinydashboard)
library(leaflet)

shinyUI(navbarPage("Water Available for Ag-GB",
				
				tabPanel("Metrics",
						
						fluidRow(
								column(width = 6,
										box(width = NULL, solidHeader = TRUE,
												leafletOutput("busmap", height = 600)
										),
										box(width = NULL,
												uiOutput("numVehiclesTable")
										)
								),
								
								sidebarPanel(width = 6, status = "warning",
										selectInput("metric1", "Select metric",
												choices = c("Magnitude" = 1, "Duration" = 2, "Intra-annual frequency" = 3,
														"Timing" = 4, "Inter-annual frequency" = 5, "Average total flow" = 6),
												selected = "1"),
										uiOutput("metric1choice"),
										
										selectInput("metric2", "Select time period",
												choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
												selected = "1"),
										uiOutput("metric2choice"),
										
										radioButtons("metric3", "Select record length",
												c("Full record" = 1,
														"Post-impairment record" = 2), selected = 1),
										
										radioButtons("metric4", "Select water year type",
												c("Average" = 1,
														"All water year types" = 2), selected = 1),
										
										actionButton("selection", "Submit"),
										p(class = "text-muted",
												br(),
												"Source data updates every 30 seconds."
										)
								),
								mainPanel(width = 12,
										box(width = NULL, status = "warning",
												plotOutput("plot_d")
										)
								)
						)),
				tabPanel("Trends"),
				tabPanel("Maps",
						fluidRow(
								absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
										draggable = TRUE, top = 300, left = "auto", right = 20, bottom = "auto",
										width = "auto", height = "auto",
										h2("Map parameter selection"),	
										selectInput("metric", "Select metric",
												choices = c("Magnitude" = 1, "Duration" = 2, "Intra-annual frequency" = 3, "Timing" = 4, "Inter-annual frequency" = 5),
												selected = "1"),
										uiOutput("metricchoice"),
										
										selectInput("timeperiod", "Select time period",
												choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
												selected = "1"),
										uiOutput("timeperiodchoice"),
										
										selectInput("yeartype", "Select water year type",
												choices = c("All" = 1, "Above normal" = 2,"Below normal" = 3, "Critical" = 4,
														"Dry" = 5,"Wet" = 6),
												selected = "1"),
										uiOutput("wateryearchoice"),
										
										actionButton("selection", "Submit"),
										p(class = "text-muted",
												br(),
												"Source data updates every 30 seconds."
										)
								),
								column(width=6, h2("FULL RECORD LENGTH"),
										box("(insert full record length map)", width = NULL, solidHeader = TRUE)
								),
								column(width=6, h2("POST-IMPAIRMENT RECORD LENGTH"),
										box("(insert post-impairment record length map)", width = NULL, solidHeader = TRUE)
								)
						)),
				
				navbarMenu("STARR",
						tabPanel("STARR"),
						tabPanel("OMR")),
				tabPanel("Allocation & Demand"),
				tabPanel("About"),
				id = "nav", theme = "bootstrap.css"))

