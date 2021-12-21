library(tidyverse)

# get list of all articles -------------------------------------------------
library(rvest)

pages <- str_c("https://www.glossa-journal.org/articles/?page=", 1:72)

map(pages, function(page){
  read_html(page) %>%
    html_nodes("div.row div.col.m10.s12 a") %>%
    html_attr("href") %>%
    str_subset("article")
}) %>%
  unlist() ->
  artcile_links

beepr::beep()

# get xml link -------------------------------------------------------------
map_chr(artcile_links, function(article_page){
  read_lines(str_c("https://www.glossa-journal.org", article_page)) %>%
    str_subset("Download XML") %>%
    str_extract('galley/\\d*/') %>%
    str_c("download/") %>%
    str_c(article_page, .)
}) %>%
  str_subset("galley") %>%
  str_remove_all("/(pub)?id") %>%
  str_replace("/91/", "/5471/")->
  links

beepr::beep()

# get glosses --------------------------------------------------------------
library(xml2)
map_dfr(links, function(link){
  # print(link)
  tryCatch(
    read_xml(str_c("https://www.glossa-journal.org", link)) %>%
      xml_find_first("back") %>%
      xml_find_first("sec") %>%
      xml_text(),
    error = function(e) "problem") ->
    result
  tibble(link, result)
}) ->
  results
beepr::beep()

results %>% write_csv("database_creation/glossa.csv")

# analyze ------------------------------------------------------------------

results <- read_csv("database_creation/glossa.csv")

results %>%
  filter(str_detect(result, "="),
         !str_detect(link, "(5707)|(5091)")) %>%
  mutate(result = str_remove_all(result, "Abbreviations"),
         result = str_remove_all(result, "ABBREVIATIONS"),
         result = str_remove_all(result, "Glossing"),
         result = str_remove_all(result, "The following glosses are used in this paper: "),
         result = str_remove_all(result, "The following abbreviations and glosses are used in this paper: "),
         result = str_remove_all(result, "We use the following glosses: "),
         result = str_remove_all(result, "Sign language abbreviations:"),
         result = str_replace_all(result, "\\s{2,}", " "),
         result = str_replace_all(result, "’", "’;"),
         result = str_remove_all(result, "Standard abbreviations have been taken from the Leipzig Rules"),
         result = str_split(result, "[,;]"),
         length = map_dbl(result, length)) %>%
  ggplot(aes(length))+
  geom_histogram()+
  theme_bw()+
  theme(text = element_text(size = 15))+
  annotate(geom = "text", label = "the longest glosses\nlist was found in\n[Gutzmann, et al. 2020]",
           x = 50, y = 20, size = 6)+
  annotate(geom = "segment", x = 50, y = 13, xend = 57, yend = 2,
           arrow = arrow(length = unit(0.3, "cm")))+
  labs(x = "number of glosses", y = "",
       caption = "based on 406 articles from Glossa")+
  scale_x_continuous(breaks = 0:6*10)
ggsave("length of the glosses list.png")


results %>%
  filter(str_detect(result, "="),
         !str_detect(link, "(5707)|(5091)")) %>%
  mutate(result = str_remove_all(result, "Abbreviations"),
         result = str_remove_all(result, "ABBREVIATIONS"),
         result = str_remove_all(result, "Glossing"),
         result = str_remove_all(result, "The following glosses are used in this paper: "),
         result = str_remove_all(result, "The following abbreviations and glosses are used in this paper: "),
         result = str_remove_all(result, "We use the following glosses: "),
         result = str_remove_all(result, "Sign language abbreviations:"),
         result = str_replace_all(result, "\\s{2,}", " "),
         result = str_replace_all(result, "’", "’;"),
         result = str_remove_all(result, "Standard abbreviations have been taken from the Leipzig Rules"),
         result = str_split(result, "[,;]"),
         length = map_dbl(result, length)) %>%
  unnest_longer(result) %>%
  mutate(result = str_remove_all(result, "^\\s"),
         nch = nchar(result)) %>%
  filter(str_count(result, "=") < 2,
         nch < 80) ->
  for_analysis


for_analysis %>%
  filter(str_detect(result, "=")) %>%
  mutate(gloss = str_split(result, " = "),
         definition = map(gloss, 2) %>% as.character(),
         gloss = map(gloss, 1) %>% as.character()) %>%
  count(gloss, definition, sort = TRUE) %>%
  write_csv("database_creation/glossa_extracted.csv")

# after this I go through the file and change it manually

# save file as rds ---------------------------------------------------------
glosses <- read_csv("database_creation/glossa_extracted.csv")
save(glosses, file="data/glosses.RData", compress='xz')

