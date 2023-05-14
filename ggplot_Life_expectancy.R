install.packages('glue')
install.packages("tidyverse")
install.packages("RColorBrewer")
install.packages('ggrepel')
install.packages('ggplot2')
install.packages('polycor')
install.packages('corrplot')
install.packages('grid')
install.packages('gridExtra')
install.packages('dplyr')
install.packages('data.table')

library(glue)
library(tidyverse)
library(RColorBrewer)
library(ggrepel)
library(ggplot2)
library(polycor)
library(corrplot)
library(grid)
library(gridExtra)
library(dplyr)
library(data.table)

#Please see the README file 
#lead the database using file explorer window

df <- read.csv(file.choose(), stringsAsFactors = TRUE)
setnames(df, old = c('Hepatitis_B','Measles', 'Polio', 'Diphtheria'), new = c('Hepatitis_B_vacc','Measles_vacc','Polio_vacc','Diphtheria_vacc'))
levels(df$Country)[match("Gambia, The",levels(df$Country))] <- "The Gambia"
df$Adult_mortality <- round(df$Adult_mortality, digit = 1) 

#Region boxplot

ggplot(data = df[df$Year %in% c(2000,2005,2010,2015),], 
       aes(x = Region, y = Life_expectancy, color = Region)) +
  
  geom_boxplot(outlier.colour = NA) + 
  
  geom_jitter(aes(size = GDP_per_capita), alpha = 0.65) +
  
  facet_grid(.~factor(Year, levels=c(2000, 2005,2010,2015))) +
  
  labs(title = "Life expectancy in the countries of each region",
       tag ="Point size based on GDP\nper capita (USD)") +
  
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        plot.tag.position = c(0.88,0.8),
        plot.tag = element_text(hjust = 0, size=11),
        text=element_text(size=12,  family="Arial"),
        plot.title = element_text(hjust = 0.5),
        panel.grid.major=element_blank()) +
  
  guides(size = FALSE) + ylab('Life expectancy') +
  
  scale_size_continuous(range = c(1,6)) + 
  
  scale_color_manual(values = c("#FF3333", "#CC9900", "#00BFC4", "#00BE67", "#FF61CC", "#0066CC", "#996699", "#7CAE00",'#CC3300'))

#2 Region boxplot

ggplot(data = df[df$Year %in% c(2000,2005,2010,2015),], 
       aes(x = as.factor(Year), y = Life_expectancy)) +
  
  geom_boxplot(outlier.colour = NA)  +
  
  geom_jitter(aes(size = Population_mln, color = as.factor(Year)), alpha = 0.65) +
  
  facet_grid(.~Region) + 
  
  labs(title = "Life expectancy in the countries of each region with point size based on population",
       tag ="Point size based\non Population_mln") +
  
  guides(size = FALSE, color=guide_legend(title="Year")) +
  
  scale_size_continuous(range = c(1,8)) +
  
  theme(plot.tag.position = c(0.94,0.3),
        plot.tag = element_text(hjust =0, size=11),
        text=element_text(size=12,  family="Arial"),
        plot.title = element_text(hjust = 0.5),
        panel.grid.major=element_blank()) +
  
  xlab('Year') + ylab('Life expectancy') 

#correlation matrix based on whole df

corr_matrix <- hetcor(df[,-c(1,2)])
corr_matrix <- as.matrix(corr_matrix)
corr_matrix <- round(corr_matrix, 2)

corrplot(corr_matrix, method="color", addCoef.col = "black", outline = T, number.cex=0.7, 
         tl.col = "black", col=brewer.pal(n = 9, name = "RdBu"), title = 'Correlation matrix', mar=c(0,0,2,0))

#correlation for each Region
#area = Region to invastigate, col_name = variable to invastigate in geom line plots, info = additional info included in title

correlation <- function(area, col_name, reverse_color = F, info =''){
  
  df_temp <- df[df$Region == area,] 

  corr_matrix <- hetcor(df_temp[,-c(1,2)])
  corr_matrix <- as.matrix(corr_matrix)
  corr_matrix <- round(corr_matrix, 2)
  
  corrplot(corr_matrix, method="color", addCoef.col = "black", outline = T, number.cex=0.7, 
           tl.col = "black", col=brewer.pal(n = 9, name = "RdBu"), title = glue('Correlation matrix - {area}'),
           mar=c(0,0,2,0))  
  
  locator(1)
  
  #this part of function creates facet_wrap line plots for every country of each Region. Color based on choosen variable (col_name), 
  #for example high number of HIV incidents in Lesotho country will cause dark blue color line, while Tunisia with low number
  #of incidents will be presented by light blue line
  
  ggplot(data = df_temp, aes(x=Year, y=Life_expectancy, color = {{col_name}})) +
    
    labs(title = glue('Life expectancy in each country in {area}, {info}')) +
    
    geom_rect(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = 'aliceblue', alpha = 0.06) +
    
    geom_line(size = 1.1) +  facet_wrap(~fct_reorder(Country, Life_expectancy, .desc = TRUE)) + 
    
    geom_point(data = df_temp[df_temp$Year == 2015,], size = 2) +
    
    geom_text(data = df_temp[df_temp$Year == 2015,], aes(label = round(Life_expectancy)), size=4, hjust = 0.5, vjust = 1.5, fontface='bold') +
    
    theme(panel.grid.minor = element_blank(), panel.grid.major=element_line(color="gray58"), 
          axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5), 
          legend.position = c(0.98,0.02), legend.key.height= unit(0.4, 'cm'), legend.title = element_text(size = 10),
          plot.title = element_text(hjust = 0.5)) +
    
    ylab('Life expectancy')  +
    
    
    if(reverse_color == T){
      scale_color_continuous(trans = 'reverse')
    }
}


correlation('Africa', Incidents_HIV, reverse_color = T, info = 'line color based on Incidents of HIV per 1000 population aged 15-49')
correlation('Asia', Diphtheria_vacc, info = 'line color based on % of Diphtheria vacc. among 1-year-olds')
correlation('Central America and Caribbean', Hepatitis_B_vacc, info = 'line color based on % of Hepatitis_B vacc. among 1-year-olds')
correlation('European Union', Thinness_ten_nineteen_years, reverse_color = T, info = 'line color based on prevalence of thinness among adolescents aged 10-19 years')
correlation('Rest of Europe', Adult_mortality, reverse_color = T, info = 'line color based on BMI')
correlation('Middle East', Thinness_five_nine_years, reverse_color = T, info = 'line color based on prevalence of thinness among children aged 5-9 years')
correlation('North America', Incidents_HIV, reverse_color = T, info = 'line color based on Incidents of HIV per 1000 population aged 15-49')
correlation('Oceania', Schooling, info = 'line color based on average years that people aged 25+ spent in formal education')
correlation('South America', BMI, reverse_color = T, info = 'line color based on BMI')


#closer look at Poland

df_pl <- df[df$Country ==  'Poland', -c(1,2)][order(df[df$Country == 'Poland',]$Year),]

#empty vector that will store indexes of columns with 0 sd, so those variables will not be included in corr plot
zero_sd_cols <- c() 

#catching columns with 0 sd
for(i in seq(1, ncol(df_pl))){
  
  if(sd(df_pl[,i]) == 0)
    zero_sd_cols <- c(zero_sd_cols, i)  
}

df_pl <- df_pl[, -zero_sd_cols]

corr_matrix <- hetcor(df_pl)
corr_matrix <- as.matrix(corr_matrix)
corr_matrix <- round(corr_matrix, 2)

corrplot(corr_matrix, method="color", addCoef.col = "black", outline = T, number.cex=0.7, 
         tl.col = "black", col=brewer.pal(n = 9, name = "RdBu"))

#creating variable list, variables sorted by absolute value of Life_expectancy correlation coeff.
#this list will be used in loops - plots presenting highest correlated variables will be printed first  
variables_list <- names(sort(abs(corr_matrix['Life_expectancy', colnames(corr_matrix) != c('Year','Life_expectancy')] ), decreasing = TRUE))

#dual axis plots, presenting percent change since 2000. Blue line represents Life_expectancy change, 
#red one represents variable from variables_list
#new column percent_ch1 stores information about percent change of variable from variables_list
#new column percent_ch2 stores information about percent change of Life_expectancy
#press enter to see next plot

for(variable in variables_list){
  
  nominator <- df_pl[,colnames(df_pl) == variable]
  
  df_pl = mutate(df_pl, percent_ch1 = ( nominator / df_pl[1, variable] -1) * 100)
  df_pl = mutate(df_pl, percent_ch2 = (Life_expectancy / df_pl[1,'Life_expectancy'] -1) * 100)
  
  print(
    ggplot(data = df_pl, aes(x = Year)) + 
      
      geom_rect(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = 'peachpuff2', alpha = 0.06) +
      
      geom_line(aes(y = percent_ch1), color = '#FF6666', size = 1.1) +
      
      geom_label(label=variable, x=-Inf, y=Inf, fill = '#FF6666', hjust = 0, vjust = 1) +
      
      geom_point(aes(y=percent_ch1), color = '#FF6666', size = 3) + 
      
      scale_y_continuous(n.breaks = 10) +
      
      geom_line(aes(y = percent_ch2), color = '#006699', size = 1.1) +
      
      geom_label(label='Life_expectancy', x=-Inf, y=Inf, fill = '#006699', hjust = 0, vjust = 2, color = 'white') +
      
      geom_point(aes(y=percent_ch2), color = '#006699',size = 3) + 
      
      labs(x = 'Year', y='% change since 2000', title = glue('{variable} vs Life_expectancy (percent change since 2000)')) +
      
      theme(panel.grid.major=element_line(color="gray58"), panel.grid.minor=element_blank(),
            axis.text.x = element_text(size=15), axis.text.y = element_text(size = 12)) +
      
      scale_y_continuous(n.breaks = 10))
      
  readline(prompt="Press enter to continue")
} 

#comparison of two plots, real values, no percent change
#press enter to see next plot

for(variable in variables_list){
  
  p <- ggplot(data = df_pl, aes(x=Year)) + 
    
    geom_rect(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = 'peachpuff2', alpha = 0.06) + 
    
    theme(panel.grid.major=element_line(colour="gray58"), axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12))
  
  plot1 <- p + geom_line(aes_string(y=variable), color = '#FF6666', size = 1.1) +
    
    geom_point(aes_string(y=variable), color = '#FF6666', size= 3) +
    
    geom_text_repel(data = df_pl[df_pl$Year == 2015,], aes_string( y = variable, label = variable) ,color = '#FF6666', size = 5, fontface='bold')
  
  plot2 <- p + geom_line(aes(y=Life_expectancy), color = '#006699', size = 1.1) + 
    
    geom_point(aes(y=Life_expectancy), color = '#006699', size= 3) +
    
    geom_text_repel(data = df_pl[df_pl$Year == 2015,], aes( y = Life_expectancy, label = Life_expectancy) ,color = '#006699', size = 5, fontface='bold')
  
  grid.arrange(plot1, plot2, ncol=2, top=textGrob(glue('{variable} vs Life_expectancy, real values')))
  
  readline(prompt="Press eneter to continue")
  
}


for(variable in variables_list){
  
  p <- ggplot(data = df_pl, aes_string(x='Life_expectancy', y=variable)) + 
    
    geom_rect(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = 'peachpuff2', alpha = 0.06)
  
  print(
    p + geom_point(color = 'orangered2', size = 4) + 
      
      geom_text_repel(aes(label = Year), color ='orangered2', fontface='bold') +
      
      geom_smooth() + 
      
      labs(title = glue('{variable} vs Life_expectancy scatter plot')) +
      
      theme(panel.grid.major=element_line(colour="gray58"), panel.grid.minor=element_blank(),
            plot.title = element_text(hjust = 0.5), axis.text.x = element_text(size = 12), 
            axis.text.y = element_text(size = 12))
  )
  
  readline(prompt="Press eneter to continue")
  
}




