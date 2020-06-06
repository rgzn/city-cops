# city-cops

Scripts to scrape data on city police budgets
- _scrape.R_:  code to scrape city-data.com
- _nv.rds_: example dataset (Nevada)

## Issues:
- Connection will be blocked by host if you make too many requests
- dates scraped from web still interpreted as chr vectors instead of datetimes

## Example Use:
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

## Example Output:
``` 
> nv_budgets
# A tibble: 326 x 9
   state  city      Function                 date_str   `Full-time_employe… `Part-time_employe… `Monthly_full-time_pay… `Average_yearly_full-tim… `Monthly_part-time_pay…
   <chr>  <chr>     <chr>                    <chr>                    <dbl>               <dbl>                   <dbl>                     <dbl>                   <dbl>
 1 Nevada Carson C… Correction               March 2016                  69                  12                  393180                     68379                   18111
 2 Nevada Carson C… Police Protection - Off… March 2016                  65                   0                  419167                     77385                       0
 3 Nevada Carson C… Judicial and Legal       March 2016                  63                   5                  368178                     70129                    9902
 4 Nevada Carson C… Firefighters             March 2016                  59                   5                  475073                     96625                    2682
 5 Nevada Carson C… Streets and Highways     March 2016                  49                   0                  268154                     65670                       0
 6 Nevada Carson C… Financial Administration March 2016                  34                   5                  191263                     67505                    4189
 7 Nevada Carson C… Police - Other           March 2016                  30                   7                  170473                     68189                    7832
 8 Nevada Carson C… Other Government Admini… March 2016                  29                   5                  155354                     64284                    5917
 9 Nevada Carson C… Other and Unallocable    March 2016                  29                   4                  141163                     58412                    5146
10 Nevada Carson C… Health                   March 2016                  28                   9                  155853                     66794                   17413
# … with 316 more rows
```
