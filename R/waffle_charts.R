
library(waffle)
library(xml2) #'for webscrapping 
library(zoo) #' for filling missing text


#' Scrap data from the Bureau of Labor statistics ------------------------------

#'Url to scrap
url = 'https://www.bls.gov/web/empsit/cpsee_e16.htm'

#' Read website
website = read_html(url)


#'Scrap table containing unemployment rates
table = rvest::html_table(website, fill = T)[[2]] 


#' Clean scrapped table--------------------------------------------------------

#'define col names
names(table) = paste(names(table), table[1,])


#'re-format, rename variables, and create variables for viz
table_clean = table %>%
  
  #' re-format to longer -----------------------------------
  pivot_longer(-1,
               names_to = "group",
               values_to = "unemployed"
  ) %>%
  #' rename variables -------------------------------------
  rename(age = names(.)[1]) %>%
  
  #'create variables for viz -------------------------------
  mutate(
    #'proportion unemployed
    unemployed = round(as.numeric(unemployed), digits = 0),
    
    #' proportion employed
    employed = 100 - unemployed,
    
    #'quarter
    quarter = str_extract(group, "3rd*.+"),
    
    #'race
    group = str_trim(str_remove_all(group, '3rd*.+')),
    group = str_replace(group, "Black or AfricanAmerican", "African American"),
    group = factor(group,
                   levels = c("African American", "Hispanic or Latino", "Asian", "White"  ),
                   ordered = T),
    
    #'sex
    sex = case_when(str_detect(age, 'Men') ~ 'Men',
                    str_detect(age, 'Women') ~ 'Women',
                    str_detect(age, 'Total') ~ 'Total'
    ),
    
    #' age group
    age = str_replace(age, "years and over", "+"),
    age = str_remove(age, "Total, | years")
  ) %>%
  
  #'filter period and sex of interest -------------------------------------
  filter(!is.na(unemployed),
         quarter == "3rd2020",
         group!='Total') %>%
  
  #'fill sex ------------------------------------------------------------ 
  mutate(sex = zoo::na.locf(sex)) %>%
  
  #'filter to total (both male and females)
  filter(sex == 'Total') %>%
  
  #' re-format to viz -------------------------------------------------
  pivot_longer(-c(age,group, quarter, sex),
               names_to = "color")



#' Create waffle plot

waffle_plot = ggplot(data = subset(table_clean, age =="16 +"),
       aes(
         fill = color,
         values = value
       )
) +
  #Waffle -------------------------------------------------------------------
geom_waffle(
  n_rows  = 10, size = 1, colour = 'white', flip = T
) +
  coord_equal() +
  facet_wrap(~group, ncol = 4, nrow = 1) +
  scale_fill_manual(
    values = c('#EDEDED', '#B30000'),
    #' show legend only for unemployed
    breaks = c("unemployed"),
    labels = c(" % unemployed (16 years and over)")
  ) +
  
  #Labels ----------------------------------------------------------------------
labs(y = "",
     x = "",
     title = 'Unemployment rates by race in the U.S.',
     subtitle= "3rd quarter, 2020",
     caption = "**Data:** U.S Bureau of Labor Statistics (Dec. 2020) | **Chart:** Andres Arau"
) +
  
  theme(
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    #text
    plot.title = element_markdown(size = 24, family = "Roboto", color = '#162127', margin = margin(t=-10)) ,
    plot.subtitle = element_markdown(size = 18, color = "black", hjust = 0, family = "Roboto", margin = margin(t =5, b=20)),
    plot.caption = element_markdown(hjust = .5, size = 12, family = 'Roboto', color ="#4D433A"),
    
    #legend
    legend.text = element_markdown(size = 14, family = "Roboto", color = 'black'),
    legend.position = 'top',
    legend.title = element_blank(),
    legend.margin = margin(b=20),
    
    #strip
    strip.background = element_blank(),
    strip.text = element_markdown(hjust = .5, size = 12, family = "Roboto")
  )