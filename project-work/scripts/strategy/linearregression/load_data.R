library(quantmod)
symbol<-'SPY'
options("getSymbols.warning4.0"=FALSE)
startDate <- '2005-01-30'
endDate<- '2014-06-30'
getSymbols(Symbols = symbol,index.class  = 'POSIXct',
           from =startDate,to = endDate,adjust=FALSE)

for(asset in symbol){
    assign(x=asset,value= adjustOHLC(get(asset),use.Adjusted = TRUE))
}

LRC <- function(x,n){
    regression <- function(dataBlock){
        fit <-lm(dataBlock~seq(1,length(dataBlock),1))
        return(last(fit$fitted.values))
    }
    result<-rollapply(x,width=n,regression,align="right",by.column=FALSE)
    return(result)
}

myTheme<-chart_theme()
myTheme$col$up.col<-'lightgreen'
myTheme$col$dn.col<-'pink'
data<- LRC(Cl(get(symbol)),20)


rm(list=ls())

library(FinancialInstrument)
library(TTR)
library(blotter)
library(quantstrat)
library(lattice)

.blotter <- new.env()
.strategy <- new.env()
Sys.setenv(TZ="UTC")
STRATEGY<-'LRC'
PORTOLIO.NAME<-'PORTFOLIO.LRC.STOP'
ACCOUNT.NAME<-'AC.LRC.STOP'

try(rm.strat(PORTOLIO.NAME))

symbol<-c('SPY')
currency("USD")
stock(primary_id = symbol,currency = "USD",multiplier = 1)
Sys.setenv(TZ="UTC")

initDate <- '2004-12-31'
startDate <- '2005-01-30'
endDate<- '2014-06-30'

initEq <- 1e6

options("getSymbols.warning4.0"=FALSE)
getSymbols(Symbols = symbol,index.class  = 'POSIXct',
           from =startDate,to = endDate,adjust=TRUE)