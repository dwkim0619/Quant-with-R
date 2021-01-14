url.aapl = "https://www.quandl.com/api/v3/datasets/WIKI/AAPL/data.csv?api_key=xw3NU3xLUZ7vZgrz5QnG"
data.appl = read.csv(url.aapl)

head(data.appl)

# 3.2 getSymbols()를 이용한 다운로드 ----

library(quantmod)
getSymbols('AAPL')

head(AAPL)

# Adjusted는 배당이 반영된 수정주가를 의미
chart_Series(Ad(AAPL))

# 애플 ----
data <- getSymbols('AAPL',
                   from = '2019-01-01',
                   to = '2020-12-31',
                   auto.assign = FALSE)
head(data)

chart_Series(Ad(data))

# 삼성전자 ----
getSymbols('005930.KS',
           from = '2020-01-01',
           to = '2020-12-31')
tail(Ad(`005930.KS`))

# 국내 종목은 종종 수정주가에 오류가 발생하는 경우가 많아서 
# 배당이 반영된 값보다는 단순 종가(Close) 데이터를 사용하기를 권장
chart_Series(Cl(`005930.KS`))

# 셀트리온 ----
getSymbols('068760.KS',
           from = '2020-01-01',
           to = '2020-12-31')
tail(Cl(`068760.KS`))

chart_Series(Cl(`068760.KS`))

# FRED(미국 연방준비은행) 미 국채 10년물 금리 ----
getSymbols('DGS10', 
           # from = '2020-01-01',
           # to = '2020-12-31',
           src = 'FRED')
tail(DGS10)

chart_Series(DGS10)

# 원/달러 환율 ----
getSymbols('DEXKOUS', src = 'FRED')
head(DEXKOUS)

chart_Series(DEXKOUS)