# TODO: Add comment
# 
# Author: kmstone5
###############################################################################
#test
library(shinydashboard)
library(leaflet)

shinyUI(navbarPage("Water Available for Ag-GB",
				
				tabPanel("Metrics",
						
						fluidRow(
								column(width = 8,
										box(width = NULL, solidHeader = TRUE,
												leafletOutput("busmap", height = 600)
										),
										box(width = NULL,
												uiOutput("numVehiclesTable")
										)
								),
								
								sidebarPanel(width = 4, status = "warning",
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
				tabPanel("Trends",
						fluidRow(
								column(width=8,
										box(leafletOutput("map_Trends", height = 600), width = NULL, solidHeader = TRUE)
								),
								sidebarPanel(selectInput("timeperiod2", "Select time period",
												choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
												selected = "1"),
										uiOutput("timeperiodchoice2"), width = 4,
										actionButton("selection2", "Submit")),
								mainPanel(width = 12,
									box(width = NULL, status = "warning",
										plotOutput("plot_trend"))))),
				tabPanel("Maps",
						fluidRow(
								column(width=6, h2("Full Record Length"),
										box(leafletOutput("map_full", height = 700), width = NULL, solidHeader = TRUE)
								),
								column(width=6, h2("Post-Impairment Record Length"),
										box(leafletOutput("map_pi", height = 700), width = NULL, solidHeader = TRUE)
								),
								absolutePanel(id = "controls", fixed = TRUE,
										draggable = TRUE, top = 300, left = "auto", right = 20, bottom = "auto",
										wellPanel(width = "auto", height = "auto",
										h4("Map parameter selection"),	
										selectInput("metric", "Select metric",
												choices = c("Magnitude" = 1, "Duration" = 2, "Intra-annual frequency" = 3,
															"Timing" = 4, "Inter-annual frequency" = 5),
												selected = "1"),
										uiOutput("metricchoice"),
										
										selectInput("timeperiod", "Select time period",
												choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
												selected = "1"),
										uiOutput("timeperiodchoice"),
										
										radioButtons("wateryear", "Select water year type",
												c("Average" = 1, "All water year types" = 2), selected = 1),
										uiOutput("wateryearchoice"),
										
										actionButton("selection", "Submit"),
										p(class = "text-muted",
												br(),
												"Source data updates every 30 seconds."
										)
								), style = "opacity: 0.92"
								
						))),
				
				navbarMenu("STARR",
						tabPanel("STARR",
							fluidRow(
									column(width=8,
											box(leafletOutput("map_STARR", height = 700), width = NULL, solidHeader = TRUE)
									),
									sidebarPanel(selectInput("timeperiod1", "Select time period",
											choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
											selected = "1"),
											uiOutput("timeperiodchoice1"), width = 4,
									actionButton("selection1", "Submit")))),
					
						tabPanel("OMR",
								fluidRow(
										column(width=8,
												box(leafletOutput("map_OMR", height = 700), width = NULL, solidHeader = TRUE)
										),
										sidebarPanel(radioButtons("timeperiod3", "Select time period",
														choices = c("December to February" = 1, "November to April"),
														selected = "1"),
												uiOutput("timeperiodchoice3"), width = 4,
												actionButton("selection3", "Submit"))))),
				tabPanel("Allocation & Demand",
						fluidRow(
								column(width=6,
										box(leafletOutput("map_ad1", height = 700), width = NULL, solidHeader = TRUE)
								),
								column(width=6,
										box(leafletOutput("map_ad2", height = 700), width = NULL, solidHeader = TRUE)
								),
								absolutePanel(id = "controls", fixed = TRUE,
										draggable = TRUE, top = 150, left = "auto", right = 20, bottom = "auto",
										wellPanel(width = "auto", height = "auto",
										h4("Map parameter selection"),	
										selectInput("timeperiod3", "Select time period",
												choices = c("January" = 1, "February" = 2, "March" = 3, "April" = 4, "May" = 5,
														"June" = 6, "July" = 7, "August" = 8, "September" = 9,
														"October" = 10, "November" = 11, "December" = 12, "3-month" = 13,
														"6-month" = 14, "Hydrologic year" = 15),
												selected = "1"),
										actionButton("selection", "Submit")
										), style = "opacity: 0.92"
								))
						
						),
				tabPanel("About"),
				id = "nav", inverse = FALSE, theme = "bootstrap2.css", windowTitle = "Water Available for Ag-GB")) #I found this .css theme online at bootswatch.com

