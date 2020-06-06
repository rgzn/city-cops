# city-cops

Scripts to scrape data on city police budgets
- _scrape.R_:  code to scrape city-data.com
- _nv.rds_: example dataset (Nevada)

## Issues:
- Connection will be blocked by host if you make too many requests
- Numbers and dates scraped from web still interpreted as chr vectors instead of numerics or datetimes

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
# A tibble: 326 x 9
   Function  `Full-time emplo… `Monthly full-t… `Average yearly… `Part-time empl… `Monthly part-t… date_str city  state
   <chr>     <chr>             <chr>            <chr>            <chr>            <chr>            <chr>    <chr> <chr>
 1 Correcti… 69                $393,180         $68,379          12               $18,111          March 2… Cars… Neva…
 2 Police P… 65                $419,167         $77,385          0                $0               March 2… Cars… Neva…
 3 Judicial… 63                $368,178         $70,129          5                $9,902           March 2… Cars… Neva…
 4 Firefigh… 59                $475,073         $96,625          5                $2,682           March 2… Cars… Neva…
 5 Streets … 49                $268,154         $65,670          0                $0               March 2… Cars… Neva…
 6 Financia… 34                $191,263         $67,505          5                $4,189           March 2… Cars… Neva…
 7 Police -… 30                $170,473         $68,189          7                $7,832           March 2… Cars… Neva…
 8 Other Go… 29                $155,354         $64,284          5                $5,917           March 2… Cars… Neva…
 9 Other an… 29                $141,163         $58,412          4                $5,146           March 2… Cars… Neva…
10 Health    28                $155,853         $66,794          9                $17,413          March 2… Cars… Neva…
```
