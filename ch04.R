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
# #contentarea > div.box_type_l > table.Nnavi > tbody > tr > td.pgRR > a
# #contentarea > div.box_type_l > table.type_2 > tbody > tr:nth-child(2) > td:nth-child(2) > a

library(httr)
library(rvest)
library(stringr)

data <- list()

# i = 0 은 코스피, i = 1 은 코스닥 종목
for (i in 0:1) {

  ticker <- list()

  # 최종 페이지 번호 찾아주기
  url = paste0("https://finance.naver.com/sise/",
               "sise_market_sum.nhn?sosok=", i, "&page=1")
  down_table <- GET(url)
  
  navi.final = read_html(down_table, encoding = 'euc-kr') %>%
    html_nodes(., '.pgRR') %>%
    html_nodes(., 'a') %>%
    html_attr(., 'href')
  
  navi.final <- navi.final %>% 
    strsplit(., '=') %>%
    unlist() %>%
    tail(., 1) %>%
    as.numeric()
  
  # 첫번째 부터 마지막 페이지까지 for loop를 이용하여 테이블 추출하기
  for(j in 1:navi.final) {
    
    url <- paste0("https://finance.naver.com/sise/",
                  "sise_market_sum.nhn?sosok=", i, "&page=", j)
    down_table <- GET(url)
    
    # 한글 오류 방지를 위해 영어로 로케일 언어 변경
    Sys.setlocale(locale = "English")
    
    table <- read_html(down_table, encoding = 'euc-kr') %>%
      html_table(fill = T)
    
    table <- table[[2]]
    
    # 한글을 읽기위해 로케일 언어 재변경
    Sys.setlocale(locale = "Korean")
    
    table[,ncol(table)] <-  NULL
    table <- na.omit(table)
    
    symbol <- read_html(down_table, encoding = 'euc-kr') %>%
      html_nodes(., 'tbody') %>%
      html_nodes(., 'td') %>%
      html_nodes(., 'a') %>%
      html_attr(., 'href')
    # head(symbol)
    
    symbol <- sapply(symbol, function(x) {
      str_sub(x, -6, -1)
    })
    
    # 종목명에 설정된 링크 /item/main.nhn?code=005930
    # 토론실에 설정된 링크 /item/board.nhn?code=005930 의 종목코드 중복
    symbol <- unique(symbol)
    
    # 종목명 테이블에 종목코드 추가
    table$N <- symbol
    colnames(table)[1] <- '종목코드'
    
    rownames(table) <- NULL
    # head(table)
    
    ticker[[j]] <- table
    
    Sys.sleep(0.5)
  }
  
  ticker <- do.call(rbind, ticker)
  data[[i + 1]] = ticker
}

# 코스피와 코스닥 테이블 묶기
# data = do.call(rbind, data)