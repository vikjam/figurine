library(rvest)
library(ggvis)
library(stringr)

wiki.prison      <- read_html("http://en.wikipedia.org/wiki/List_of_countries_by_incarceration_rate")
wiki.prison.data <- wiki.prison                 %>%
                        html_nodes("table")     %>%
                        html_nodes("table")     %>%
                        .[[2]]                  %>%
                        html_table(fill = TRUE)

colnames(wiki.prison.data) <- c("country", "incar.rate")

wiki.prison.data$country[grep("United States of America", wiki.prison.data$country)]           <- "United States"
wiki.prison.data$incar.rate <- str_match(wiki.prison.data$incar.rate, "([0-9]+)(?!.*[0-9])")[, 2]
wiki.prison.data$incar.rate <- as.numeric(wiki.prison.data$incar.rate)

wiki.gdp.capita      <- read_html("http://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita")
wiki.gdp.capita.data <- wiki.gdp.capita         %>%
                            html_nodes("table") %>%
                            html_nodes("table") %>%
                            .[[1]]              %>%
                            html_table()

wiki.gdp.capita.data <- wiki.gdp.capita.data[ , 2:3]
colnames(wiki.gdp.capita.data) <- c("country", "gdp.per.capita")
wiki.gdp.capita.data$gdp.per.capita <- as.numeric(gsub(",", "", wiki.gdp.capita.data$gdp.per.capita))

wiki.murder.rate      <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_intentional_homicide_rate")
wiki.murder.rate.data <- wiki.murder.rate       %>%
                            html_nodes("table") %>%
                            html_nodes("table") %>%
                            .[[2]]              %>%
                            html_table()

wiki.murder.rate.data           <- wiki.murder.rate.data[ , 1:2]
colnames(wiki.murder.rate.data) <- c("country", "murder.rate")

wiki.merge <- merge(wiki.prison.data, wiki.gdp.capita.data, by.x = "country", by.y = "country")
wiki.merge <- merge(wiki.merge, wiki.murder.rate.data, by = "country")

p <- wiki.merge                                                         %>%
        ggvis( ~log(gdp.per.capita), ~log(incar.rate), key := ~country) %>%
        layer_points()                                                  %>%
        add_tooltip(function(df) df$country)
