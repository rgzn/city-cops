library(tidyverse)
library(rvest)
library(janitor)

# Data scrap of city-data.com for local govt budgets
# @imaginary_nums 2020

# Input: url to state page
# Value: Tibble of city urls
get_city_urls <- function(url) {
  city_nodes <- url %>% 
    read_html %>% 
    html_nodes(xpath = '//*[@id="cityTAB"]') 
  
  urls <- city_nodes %>% 
    html_nodes("a") %>% 
    html_attr("href") %>% 
    as_tibble() %>% 
    rename(URL = value) %>% 
    filter(URL %>% str_detect("html")) %>% 
    mutate(URL = paste0("http://www.city-data.com/city/", URL))
  
  # city_nodes %>% 
  #   first %>% 
  #   html_table %>% 
  #   as_tibble %>% 
  #   select(Name, Population) %>% 
  #   filter()
  
  return(urls)
}

# Input: url to city page
# Value: Tibble of city payroll data
get_city_payroll <- function(url) {
  city_page <- read_html(url)
  citystate <- city_page %>% 
    html_nodes(xpath = '/html/body/div[3]/div[4]/h1/span')  %>% 
    html_text() %>% 
    str_split(pattern = ", ") %>% 
    unlist
  
  city_name <- citystate[1]
  state_name <- citystate[2]
  
  city_govt_node <- city_page %>% 
    html_node(xpath = '//*[@id="government-employment"]') 
  
  if (is.na(city_govt_node) ){
    return(NULL)
  }
  
  city_govt <- city_govt_node %>% 
    html_node("table") %>% 
    html_table %>% 
    as_tibble
  
  date <- city_govt[1,1] %>% 
    str_extract("\\(.*\\)") %>% 
    str_remove_all("[\\(\\)]")
  
  gov <- city_govt %>% tail(n = -1L) %>% 
    row_to_names(row_number = 1) %>% 
    mutate(date_str = date,
           city = city_name,
           state = state_name) 
  return(gov)
}

main_url<- "http://www.city-data.com/"
main_page <- read_html(main_url)

# Get URLS for each state
states <- main_page %>% 
  html_nodes(xpath = '//*[@id="tabs_by_category"]/div[3]') %>% 
  html_nodes("a") %>% 
  html_attr("href") %>% 
  as_tibble() %>% 
  rename(URL = value) %>% 
  filter(URL %>% str_detect("/city/"))

# Get URLS for each city
city_urls <- states$URL %>%
  map_df(get_city_urls) 

# Get budgets for entire country
city_budgets <- city_urls$URL %>% 
  map_df(get_city_payroll)

# get budgets, single state
nv_urls <- city_urls %>% 
  filter(URL %>% str_detect("Nevada.html")) 

nv_budgets <- nv_urls$URL %>% 
  map_df(get_city_payroll)


