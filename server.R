library(shiny)
library(streamgraph)
library(dplyr)
library(ggplot2)

energy_data <- read.csv("energy_data.csv", header=TRUE)

energy_type <- aggregate(. ~ MSN, energy_data,sum)
energy_type$StateCode<-NULL
tmp <- as.data.frame(t(energy_type[,-1]))
colnames(tmp)<-energy_type$MSN

tmp$year <- rownames(tmp)
tmp$year <- substr(tmp$year,2,5)
rownames(tmp)<-NULL
tmp$TEPRB<-NULL
tmp$TETCB<-NULL

colnames(tmp)<- c("coal","biomass","natural_gas","nuclear","crude_oil","renewable","renewable_other","year")
sum_energy = tmp
tmp<-tmp%>%tidyr::gather(type,value,-year) %>%group_by(year,type) %>% tally(wt=value)
tmp$n <-round(tmp$n/1000000,2)



# Define server logic 
shinyServer(function(input, output) {
  
  output$stream <- renderPlot({
    a<-input$yearRange[1] 
    b<-input$yearRange[2] 
    linedata<-tmp[tmp$year>a& tmp$year<b,]
    
    #str<-streamgraph(linedata,"type", "n", "year",offset="zero")
    #sg_axis_x(str,as.integer((b-a)/5))
    #sg_legend(str,show=TRUE, label="Type: ")
    p<-ggplot(linedata,aes(year,n,fill=type))+ geom_bar(stat="identity")+ylab("Capacity (Quadrillion BTU)")
    theme <- theme_update(axis.text.x = element_text(angle = 90,hjust = 1))
    p
    })
  
  output$pie <-renderPlot({
    selyear = input$year
    tmp2<-tmp[tmp$year ==selyear,]
    pct <- round(tmp2$n/sum(tmp2$n)*100)
    lbls <- paste(tmp$type,pct)
    lbls <- paste(lbls, "%",sep="")
    pie(tmp2$n,labels = lbls)})
  
  output$line <-renderPlot({
    a<-input$yearRange[1] 
    b<-input$yearRange[2] 
    linedata<-tmp[tmp$year>a& tmp$year<b,]
    ggplot(data=linedata,aes(x=year,y=n,group=type,color=type))+geom_line(size=2)+ylab("capacity (quadrillion BTU)")+scale_x_discrete(breaks=seq(a,b,as.integer((b-a)/5)))
  })
  output$st_production<-renderText({
    state_data <-energy_data[energy_data$StateCode==input$sel_state,]
    state_data<-state_data[paste("X",input$sel_year,sep="")]
    paste("Production:",state_data[8,1],"Billion BTU")
  })
  
  output$st_consumption<-renderText({
    state_data <-energy_data[energy_data$StateCode==input$sel_state,]
    state_data<-state_data[paste("X",input$sel_year,sep="")]
    paste("Consumption:",state_data[9,1],"Billion BTU")
  })
  
  output$state_barplot <-renderPlot({
    state_data <-energy_data[energy_data$StateCode==input$sel_state,]
    state_data<-state_data[paste("X",input$sel_year,sep="")]
    quantity<-state_data[-c(8,9),]
    type<-c("coal","biomass","natural_gas","nuclear","crude_oil","renewable","renewable_other")
    type<-c(type,type)
    state<-c(rep(input$sel_state,7),rep("national_average",7))
    
    avg_data<-sum_energy[sum_energy$year==input$sel_year,]
    avg_data$year<-NULL
    avg_data<-avg_data/50
    
    for (i in 1:7){
      quantity=c(quantity,avg_data[1,i])
    }
    dta<-cbind.data.frame(type,state,quantity)
    dta$quantity<-dta$quantity/1000
    ggplot(dta,aes(type,quantity,fill=state))+geom_bar(position="dodge",stat="identity")+ylab("capacity (Trillion BTU)")
  })
  
})
