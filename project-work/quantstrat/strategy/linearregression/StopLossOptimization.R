#---------------------------------------------------------------------------------------------------------
# Reference: http://gekkoquant.com/2013/09/29/linear-regression-curves-vs-bollinger-bands/
#-------------------------------------------------------------------------------------------------------
rm(list=ls())

library(FinancialInstrument)
library(TTR)
library(blotter)
library(quantstrat)
library(lattice)
library(doParallel)

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

#-------------------------------------------------------------------------------------------------------
# Main Strategy - Linear Regression curves
#-------------------------------------------------------------------------------------------------------
LRC <- function(x,n){
    
    regression <- function(dataBlock){
        fit <-lm(dataBlock~seq(1,length(dataBlock),1))
        return(last(fit$fitted.values))
    }
    return (rollapply(x,width=n,regression,align="right",by.column=FALSE))
}
#-------------------------------------------------------------------------------------------------------
# Fees Function - Brokerage + impact cost associated to Transaction price.
#-------------------------------------------------------------------------------------------------------

evalTxnFees<-function(TxnQty, TxnPrice, Symbol,brokerage=0.005,impactCost=0.05)
{
    txnCost<- abs(round(brokerage*(TxnPrice+impactCost)*TxnQty,2))*-1
    return(txnCost)
}
#-------------------------------------------------------------------------------
#  Initialization of Quantstart Data structures
#-----------------------------------------------------------------------------

initPortf(name = PORTOLIO.NAME,symbols = symbol,initDate=initDate)
initAcct(name = ACCOUNT.NAME,portfolios = PORTOLIO.NAME,initDate=initDate,initEq=initEq)
initOrders(portfolio = PORTOLIO.NAME,initDate=initDate)

#-------------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
strategy(STRATEGY,store=TRUE)

add.indicator(strategy = STRATEGY,name='LRC',
              arguments=list(x=quote(Cl(mktdata)),n=25),
              label='LRC')

add.indicator(strategy = STRATEGY,name='SMA',
              arguments=list(x=quote(Cl(mktdata)),n=30),
              label='SMA')

LONG.ENTRY.SIGNAL<-"LRC_GT_SMA_SIG"
LONG.EXIT.SIGNAL<-"LRC_LT_SMA_SIG"
LONG.ENTRY.RULE<-'L_ENTRY_LRC_SMA_RULE'
LONG.EXIT.RULE<-'L_EXIT_LRC_SMA_RULE'
LONG.ORDERSET.NAME<-'LRCLONGSMA'

add.signal(strategy = STRATEGY,name="sigCrossover",
           arguments=list(columns=c('LRC','SMA'),
                          relationship="gt"),
           label=LONG.ENTRY.SIGNAL)

add.signal(strategy = STRATEGY,name="sigCrossover",
           arguments=list(columns=c('LRC','SMA'),
                          relationship="lt"),
           label=LONG.EXIT.SIGNAL)

add.rule(strategy = STRATEGY,name="ruleSignal",
         arguments=list(sigcol=LONG.ENTRY.SIGNAL,
                        sigval=TRUE,
                        orderqty=100,
                        ordertype="market",
                        TxnFees=0,
                        orderside="long",
                        orderset=LONG.ORDERSET.NAME),
         type="enter",
         label=LONG.ENTRY.RULE)

add.rule(strategy = STRATEGY,name="ruleSignal",
         arguments=list(sigcol=LONG.EXIT.SIGNAL,
                        sigval=TRUE,
                        orderqty='all',
                        ordertype="market",
                        TxnFees="evalTxnFees",
                        orderside="long",
                        orderset=LONG.ORDERSET.NAME),
         type="exit",
         label=LONG.EXIT.RULE)



#-------------------------------------------------------------------------------
# Stop Loss
#-----------------------------------------------------------------------------
stopLossPercent<-0.0385
LONG.STOPLOSS.LABEL<-'LRCSMA_STOPLOSS_LONG'

add.rule(strategy = STRATEGY,
         name="ruleSignal",
         arguments=list(sigcol=LONG.EXIT.SIGNAL,
                        replace=FALSE,
                        sigval=TRUE,
                        tmult=TRUE,
                        orderqty='all',
                        threshold=quote(stopLossPercent),
                        TxnFees="evalTxnFees",
                        ordertype="stoplimit",
                        orderside="long",
                        orderset=LONG.ORDERSET.NAME),
         type="chain",
         parent=LONG.ENTRY.RULE,
         label=LONG.STOPLOSS.LABEL)


#-------------------------------------------------------------------------------

stopLossPercentRange <- seq(0.01,0.07,by=0.005)
param.set<-'STOPOPT'

add.distribution(strategy = STRATEGY,
                 paramset.label = param.set,
                 component.type = "chain",
                 component.label = LONG.STOPLOSS.LABEL,
                 variable = list( threshold = stopLossPercentRange ),
                 label = LONG.STOPLOSS.LABEL)

#-------------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
if(Sys.info()['sysname']=="Windows")
{
    registerDoSEQ()
}
else{
    registerDoParallel(cores=detectCores())
}
results <- apply.paramset(STRATEGY,
                          paramset.label=param.set,
                          portfolio.st=PORTOLIO.NAME,
                          account.st=ACCOUNT.NAME,
                          audit = NULL,
                          verbose=TRUE)

jpeg('stoploss.jpg')
plot(100*results$tradeStats[[LONG.STOPLOSS.LABEL]], results$tradeStats$Net.Trading.PL, type='b',
xlab='Stoploss %', ylab='Net.Trading.PL', main='LRC')
dev.off()    

save(list = ls(all = TRUE), file= "StopLoss.RData")
