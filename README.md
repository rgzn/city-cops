# city-cops

Scripts to scrape data on city police budgets

```
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


```
