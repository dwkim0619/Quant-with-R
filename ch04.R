library(rvest)
library(httr)

# 네이버 금융 속보 ----
url = 'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258'
data = GET(url)
print(data)

data_title <- data %>%
  read_html(encoding = 'EUC-KR') %>%
  html_nodes('dl') %>%
  html_nodes('.articleSubject') %>%
  html_nodes('a') %>%
  html_attr('title')

data_title

# 한국거래소 상장공시시스템 ---

library(httr)
library(rvest)

Sys.setlocale("LC_ALL", "English")

url <- 'https://dev-kind.krx.co.kr/disclosure/todaydisclosure.do'
data <- POST(url, body = 
               list(
                 method = 'searchTodayDisclosureSub',
                 currentPageSize = '15',
                 pageIndex = '1',
                 orderMode = '0',
                 orderStat = 'D',
                 forward = 'todaydisclosure_sub',
                 chose = 'S',
                 todayFlag = 'N',
                 selDate = '2018-12-28'
               ))

data <- read_html(data) %>%
  html_table(fill = TRUE) %>%
  .[[1]]
Sys.setlocale("LC_ALL", "Korean")

data

# 네이버 금융 주식티커 ----
