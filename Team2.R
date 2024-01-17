library(tidyverse)
library(RPostgres)

#CREATE THE DATABASE----
#_create a connection to database----
con <- dbConnect(
  drv = dbDriver('Postgres'), 
  dbname = 'hotel23a_02',
  host = 'db-postgresql-nyc1-44203-do-user-8018943-0.b.db.ondigitalocean.com', 
  port = 25061,
  user = 'proj23a_02', 
  password = 'AVNS_qCgYhpeUHjaaWIap6_N'
)

#_create customers table----
stmt <- 'CREATE TABLE customers (
          customer_id int,
          cust_name varchar(50),
          contact_info varchar(20),
          PRIMARY KEY(customer_id)
        );'
dbExecute(con, stmt)  

#_create restaurants table----
stmt <- 'CREATE TABLE restaurants (
          restaurants_id int,
          restaurants_name varchar(100),
          cuisine_type varchar(50),
          operation_hrs varchar(50),
          PRIMARY KEY(restaurants_id)
        );'
dbExecute(con, stmt)  

#_create reservations table----
stmt <- 'CREATE TABLE reservations (
          reservation_id varchar(50),
          restaurants_id int,
          customer_id int,
          dat_time timestamp,
          num_people int,
          PRIMARY KEY(reservation_id),
          FOREIGN KEY(restaurants_id) REFERENCES restaurants,
          FOREIGN KEY(customer_id) REFERENCES customers
        );'
dbExecute(con, stmt) 

#******************----
#EXTRACT----
#_read source data----
setwd("C:\\Users\\kaidi\\OneDrive\\Desktop\\MSAA\\5310\\Project\\dining\\Database")
df <- read_csv('dining_hotel.csv')

#******************----
#TRANSFORM----
#_gather the begin and end times----
# Place each in a column called 'date_time'
#   along with a new column called 'status' which
#   will contain either 'begin' or 'end'.
df$dat_time = paste(df$date, df$time, sep = ' ')
df = df[-c(21:22), -c(6:7)]

#******************----
#LOAD----
#_load customers table----
df1 <- df %>% 
  select(cust_name, contact_info) %>% 
  distinct()

df2c <- bind_cols('customer_id' = 1:nrow(df1), df1)

dbWriteTable(
  conn = con,
  name = 'customers',
  value = df2c,
  row.names = FALSE,
  append = TRUE
)

#_load restaurants table----
df1 <- df %>% 
  select(restaurants_name, cuisine_type, operation_hrs) %>% 
  distinct()

df2b <- bind_cols('restaurants_id' = 1:nrow(df1), df1)

dbWriteTable(
  conn = con,
  name = 'restaurants',
  value = df2b,
  row.names = FALSE,
  append = TRUE
)

#_load reservations table----
df1 <- df %>% 
  select(reservation_id, restaurants_name, cust_name, dat_time,
         num_people) %>% 
  distinct()

df2br <- df1 %>% 
  inner_join(df2b) %>% 
  inner_join(df2c) %>% 
  select(reservation_id, restaurants_id, customer_id, dat_time,
         num_people)

dbWriteTable(
  conn = con,
  name = 'reservations',
  value = df2br,
  row.names = FALSE,
  append = TRUE
)

#******************----
#END----


#Create database for accomodations
library(RPostgres)

#Connections----
con <- dbConnect(
  drv = dbDriver('Postgres'),
  dbname = 'hotel23a_02',
  host = 'db-postgresql-nyc1-44203-do-user-8018943-0.b.db.ondigitalocean.com',
  port = 25061,
  user = 'proj23a_02',
  password = 'AVNS_qCgYhpeUHjaaWIap6_N',
  sslmode = 'require'
)

#_create acco table----
drop_stmt <- "DROP TABLE IF EXISTS accommodations;"
dbExecute(con, drop_stmt)
stmt <- 'CREATE TABLE accommodations (
          accom_id int,
          base_price int,
          accom_view varchar(50),
          accom_type varchar(50),
          PRIMARY KEY(accom_id)
        );'
dbExecute(con, stmt)  

base_price <- data.frame(base_price = c(600, 850, 1000, 1250, 1650, 3500))
accom_type <- data.frame(accom_type = c('Two Queens', 'One King', 'One-BR Suite', 'Deluxe Room', 'Executive Room', 'Presidential Room'))
accom_view <- data.frame(accom_view = c('Interior', 'Sky View', 'Sand Dune', 'Desert Safari', 'Desert Safari', 'Desert Bunker'))
df1 <- bind_cols(base_price, accom_type, accom_view)
df <- bind_cols('accom_id' = 1:nrow(df1), df1) 

dbWriteTable(
  conn = con,
  name = 'accommodations',
  value = df,
  row.names = FALSE,
  append = TRUE
)




