**Visualization of correlation between life expectancy and 16 variables, made using ggplot2 package** <br>
Dataframe contains variables described below: <br>
<pre>
 $ Country                    : Factor w/ 179 levels "Afghanistan",..
 
 $ Region                     : Factor w/ 9 levels "Africa","Asia",..
 
 $ Year                       : int  2015 2015 2007 2006 2012 2006 2015 2000 2001 2008 
 
 $ Infant_deaths              : num  11.1 2.7 51.5 32.8 3.4 9.8 6.6 8.7 22 15.3 ...
 <i>infant deaths per 1000 population</i>
 
 $ Under_five_deaths          : num  13 3.3 67.9 40.5 4.3 11.2 8.2 10.1 26.1 17.8 ...
 <i>deaths of children under five years old per 1000 population</i>
 
 $ Adult_mortality            : num  105.8 57.9 201.1 222.2 58 ...
 <i>deaths of adults per 1000 population</i>
 
 $ Alcohol_consumption        : num  1.32 10.35 1.57 5.68 2.89 ...
 <i>alcohol consumption that is recorded in liters of pure alcohol per capita with 15+ years old</i>
 
 $ Hepatitis_B_vacc           : int  97 97 60 93 97 88 97 88 97 97 ...
 <i>% of coverage of Hepatitis B (HepB3) immunization among 1-year-olds</i>
 
 $ Measles_vacc               : int  65 94 35 74 89 86 97 99 87 92 ...
 <i>% of coverage of Measles containing vaccine first dose (MCV1) immunization among 1-year-olds</i>
 
 $ BMI                        : num  27.8 26 21.2 25.3 27 26.4 26.2 25.9 27.9 26.5 ...
 <i>Body Mass Index. If BMI is 18.5 to <25, it falls within the healthy weight range</i>
 
 $ Polio_vacc                 : int  97 97 67 92 94 89 97 99 97 96 ...
 <i>% of coverage of Polio (Pol3) immunization among 1-year-olds</i>
 
 $ Diphtheria_vacc            : int  97 97 64 93 94 89 97 99 99 90 ...
 <i>% of coverage of Diphtheria tetanus toxoid and pertussis (DTP3) immunization among 1-year-olds</i>
 
 $ Incidents_HIV              : num  0.08 0.09 0.13 0.79 0.08 0.16 0.08 0.08 0.13 0.43 ...
 <i>Incidents of HIV per 1000 population aged 15-49</i>
 
 $ GDP_per_capita             : int  11006 25742 1076 4146 33995 9110 9313 8971 3708 2235 ...
 <i>GDP per capita in current USD</i>
 
 $ Population_mln             : num  78.53 46.44 1183.21 0.75 7.91 ...
 
 $ Thinness_ten_nineteen_years: num  4.9 0.6 27.1 5.7 1.2 2 2.3 2.3 4 2.9 ...
 <i>Prevalence of thinness among adolescents aged 10-19 years</i>
 
 $ Thinness_five_nine_years   : num  4.8 0.5 28 5.5 1.1 1.9 2.3 2.3 3.9 3.1 ...
 <i>Prevalence of thinness among children aged 5-9 years</i>
 
 $ Schooling                  : num  7.8 9.7 5 7.9 12.8 7.9 12 10.2 9.6 10.9 ...
 <i>Average years that people aged 25+ spent in formal education</i>
 
 $ Life_expectancy            : num  76.5 82.8 65.4 67 81.7 78.2 71.2 71.2 71.9 68.7 ...
 <i>Average life expectancy of both genders</i>
 </pre>
 
 **Dataset contains information about 179 countires from 2000-2015 period (2864 rows)** <br>
**After running belows code - please load the dataset using file explorer window** <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/290d5093-f226-4232-97c7-4d644e36a0f1)

First chunk of code creates boxplot comparison (using facet_grid), life expectancy in each region is compered every 5 years (2000, 2005, 2010, 2015 - one plot for one year). <br>
Points placed among the boxplots represents countries of each region, points size is based on GDP per capita. <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/c39ea7e5-4e05-45b3-8029-a4c49ca5f083) <br>

Second chunk of code creates boxplots too, but this time facet_grid splits the plots by Region - for easier comparison of each Regions changes over the years. <br> 
This time, points size is based on countries population.<br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/753517f3-a827-40ae-baca-954388790e15)

Next, correlation matrix is presented - correlation coefficients are based on the whole dataset.<br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/b6fd5668-b18c-40ef-847f-d46e3343a528)

After that, function **correlation** is created. It displays correlation matrix for choosen Region, but also creates additional line plots (facet_wrap is used)
that enable to compare life expectancy (and changes) in every country (one line plot describes one country, x = Year, y = life_expectancy). 
Color of the line is based on choosen variable for example high number of HIV incidents in Lesotho country will cause dark blue color line, while 
Tunisia with low number of incidents will be presented by light blue line. <br>
Line plots are sorted from highest to lowest life_expectancy in 2000.<br>

Function parameters: 
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/91009012-80d4-48cc-b77a-7b2def9517b2)
**area** - Region to invastigate (Africa or Asia...) <br>
**col_name** - variable affecting color line in line plots (for example 'Incidents_HIV') <br>
**reverse_color** - if False (deafult) - the lower the value of col_name, the darker the color of the line. Used with variables describing numer of vaccinations etc. <br>
If True - the higher the value of col_name, the darker the color of the line. Used with variables describing HIV incidents, thinness etc.<br>
**info** - string value, that is going to be attached to to plot title (using glue library). <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/5c886719-289c-4d1b-b815-b36b3563b29d) <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/de6a0af4-c267-4e8e-bf6e-4ad43246a796) <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/538c5851-6200-4ef5-990d-35220731df52) <br>

**After aboves exploration is done, we can take a closer look at Poland. All plots described below refer to Poland only.** <br>
Subset containing only data describing Poland is created. Columns containing same value are removed from dataframe. <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/638a9b6e-a616-4797-bb3d-b4be89c54864) <br>

Correlation matrix for Poland is shown, then vector called variables_list is created. variables_list stores names of variables sorted by highest absolute value 
of correlation coefficient. It will be used while looping: plots presenting variables with highest correlation coefficient will be printed first.
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/4ea883ff-e6c2-4404-9fb9-9aeb54640168) <br>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/dce19e03-672d-472f-b0b5-c62892bff194) <br>

Next, the plots presenting percent change since 2000 will be displayed - using loop over variable_list. Plot shows percent changes of life expectancy and choosen variable <br>
Using percent change axis should prevent user from getting wrong consulsions, which is a common problem with dual axis plots. <br>
**Please press enter to display the next plot (it is also mentioned in the console)** <b>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/e2133ef8-d806-4345-bf9a-1cd00ce97278) <br>

After invastigating percent changes, also the real value plots will be presented - one next the the other, again using loop over variable_list.
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/f3915b6b-3c19-47c2-8465-245e168fe8fe) <b>

Last presented plots are scatter plots - this time there is no Year as x axis. X axis describes life expectancy, while y axis refers to choosen variable. <b>
![image](https://github.com/Jakub12091/ggplot_life_expectancy_correlation_visualisation/assets/115424802/0ec71704-b80e-4451-b8c9-7db48fa55621)












