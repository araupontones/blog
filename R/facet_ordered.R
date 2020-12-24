## chart goles por decada FC Barcelona


# library(rio)
# library(ggtext)
# library(grid)
# library(tidyverse)
# library(tidytext)
# 
# dir_data = "data"

#Define directories
#dir_clean = "clean_data"

df_goles = import(file.path(dir_data,"la_liga_goles_historico.rds"))

#extrafont::loadfonts(device = 'win')

df_goles_Barcelona = df_goles %>%
  filter(Team == "FC Barcelona",
         decada >="80's") %>%
  group_by(decada, Team_rival) %>%
  summarise(goles_barca = sum(goals_scored)) %>%
  top_n(11) %>%
  arrange(-goles_barca) %>%
  mutate(label = if_else(row_number() <=3, as.character(goles_barca), "")) %>%
  ungroup() %>%
  mutate(decada = as.factor(decada),
         Team_rival = reorder_within(Team_rival, goles_barca, decada))

plot_facet = ggplot(
  data = df_goles_Barcelona,
  aes(Team_rival,
      goles_barca,
      fill = decada)
  
) +
#Bars ----------------------------------------------------------------------
  geom_col(
    show.legend = F
    ) +
  
#Facet ---------------------------------------------------------------------
  facet_wrap(
    ~decada, scales = "free_y"
    ) +
#Labels --------------------------------------------------------------------
  geom_text(
    aes(label = label),
    hjust = 1,
    color = "white",
    family = "F.C. BARCELONA"
    )+
  coord_flip() +
#Captions ------------------------------------------------------------------
  scale_x_reordered() +
  ggtitle("Teams against which F.C Barcelona has scored more goals") +
  labs(x = "",
       y = "Goals",
       caption = '**Chart:** Andres Arau |  **Data:** {_engsoccerdata_}',
       subtitle = "By decade"
       )+
#Colors ----------------------------------------------------------------------
  scale_fill_manual(
    values = c("#A50044", "#004D98", "#EDBB00",  "#DB0030")
    ) +
#Theme ----------------------------------------------------------------------
  theme(
    plot.background = element_rect(fill = alpha("#181733",.9)),
    panel.background = element_blank(),
    panel.grid = element_blank(),
    strip.background = element_blank(),
    strip.text = element_text(color = "#FDC52C", hjust = 0, family = "F.C. BARCELONA", size = 18),
    axis.text = element_text(family = "F.C. BARCELONA", color = "white", size = 10),
    axis.title = element_text(family = "F.C. BARCELONA", size = 20, color = "#FDC52C", hjust = .35, margin = margin(t=10)),
    axis.ticks = element_blank(),
    plot.caption = element_markdown(color = "white", size = 12, margin = margin(t = 20), family = "F.C. BARCELONA"),
    plot.title = element_markdown(color = "#FDC52C", size = 20, family = "F.C. BARCELONA", margin = margin( b = 8), 
                                  hjust = 1.32),
    
    
    plot.subtitle = element_markdown(color = "#FDC52C", size = 16, family = "F.C. BARCELONA", 
                                     margin = margin( b = 10), 
                                     hjust = -0.3)
    
    
  )

#plot_facet




