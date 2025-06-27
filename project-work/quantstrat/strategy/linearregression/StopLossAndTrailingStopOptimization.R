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

#-------------------------------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------------------------------
LRC <- function(x,n){
    
    regression <- function(dataBlock){
        fit <-lm(dataBlock~seq(1,length(dataBlock),1))
        return(last(fit$fitted.values))
    }
    return (rollapply(x,width=n,regression,align="right",by.column=FALSE))
}
#-------------------------------------------------------------------------------------------------------
# Fees Function
#-------------------------------------------------------------------------------------------------------

evalTxnFees<-function(TxnQty, TxnPrice, Symbol,brokerage=0.005,impactCost=0.05)
{
    txnCost<- abs(round(brokerage*(TxnPrice+impactCost)*TxnQty,2))*-1
    return(txnCost)
}
#-------------------------------------------------------------------------------
#  Initialization
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
stopLossPercent<-0.4
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
# Trailing Loss
#-----------------------------------------------------------------------------
trailingStop<-0.07
LONG.TRAILINGSTOP.LABEL<-'LRCSMA_TRAILING_LONG'

add.rule(strategy = STRATEGY,
         name="ruleSignal",
         arguments=list(sigcol=LONG.EXIT.SIGNAL,
                        replace=FALSE,
                        sigval=TRUE,
                        tmult=TRUE,
                        orderqty='all',
                        threshold=quote(trailingStop),
                        TxnFees="evalTxnFees",
                        ordertype="stoptrailing",
                        orderside="long",
                        orderset=LONG.ORDERSET.NAME),
         type="chain",
         parent=LONG.ENTRY.RULE,
         label=LONG.TRAILINGSTOP.LABEL)
#-------------------------------------------------------------------------------

trailingStopPercent <- seq(0.04,0.08,by=0.005)

param.set<-'TRAILINGSTOPANDSTOPLOSS'

add.distribution(strategy = STRATEGY,
                 paramset.label = param.set,
                 component.type = "chain",
                 component.label = LONG.TRAILINGSTOP.LABEL,
                 variable = list( threshold = trailingStopPercent ),
                 label = LONG.TRAILINGSTOP.LABEL)

stopLossPercentRange <- seq(0.035,0.05,by=0.005)

add.distribution(strategy = STRATEGY,
                 paramset.label = param.set,
                 component.type = "chain",
                 component.label = LONG.STOPLOSS.LABEL,
                 variable = list( threshold = stopLossPercentRange ),
                 label = LONG.STOPLOSS.LABEL)


add.distribution.constraint(strategy = STRATEGY,
                            paramset.label = param.set,
                            distribution.label.1 = LONG.TRAILINGSTOP.LABEL,
                            distribution.label.2 = LONG.STOPLOSS.LABEL,
                            operator = '>',label="LRCSMA_TRAILINGSTOP_STOPLOSS")
#-------------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
if(Sys.info()['sysname']=="Windows")
{
    library(doParallel)
    #registerDoParallel(cores=detectCores())
    registerDoSEQ()
}
results <- apply.paramset(STRATEGY,
                          paramset.label=param.set,
                          portfolio.st=PORTOLIO.NAME,
                          account.st=ACCOUNT.NAME,
                          audit = NULL,
                          verbose=TRUE)

#-------------------------------
# get All tradeStats

tradeStats<-results$tradeStats

z <- tapply(X=tradeStats$Profit.To.Max.Draw,
            INDEX=list(tradeStats[[LONG.TRAILINGSTOP.LABEL]],tradeStats[[LONG.STOPLOSS.LABEL]]),
            FUN=median)
x <- as.numeric(rownames(z))
y <- as.numeric(colnames(z))

jpeg('StopLossAndTrailingStop.jpg')    

filled.contour(x=x,y=y,z=z,color = heat.colors,
               xlab="Trailing Stop",ylab="Stop Loss")

title("Return to MaxDrawdown")
dev.off()    

save(list = ls(all = TRUE), file= "StopLossAndTrailingStop.RData")
