chart_Series(x = get(symbol),subset="2014::", symbol = symbol,name = symbol,theme=myTheme)
add_SMA(n=20,col ="blue",lwd=2,on = 1)
add_TA(x =data,name="LRC",col ="red",lwd=2,on = 1)
legend(2,193,legend=c("LRC","SMA"),lwd=c(2,2),col=c("red","blue"),bty="n")


strategy(STRATEGY,store=TRUE)

add.indicator(strategy = STRATEGY,name='LRC',
              arguments=list(x=quote(Cl(mktdata)),n=20),
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
stopLossPercent<-0.045
LONG.STOPLOSS.RULE<-"LE_LRCSMA_STOPLOSS_EXIT"

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
         label=LONG.STOPLOSS.RULE)

#-------------------------------------------------------------------------------
# trailing stop
#-----------------------------------------------------------------------------

trailingStopPercent<-0.07
LONG.TRAILINGSTOP.RULE<-"LE_LRCSMA_TRAILINGSTOP_EXIT"


add.rule(strategy = STRATEGY,name="ruleSignal",
         arguments=list(sigcol=LONG.EXIT.SIGNAL,
                        replace=FALSE,
                        sigval=TRUE,
                        orderqty='all',
                        TxnFees='evalTxnFees',
                        ordertype='stoptrailing',
                        tmult=TRUE,
                        threshold=quote(trailingStopPercent),
                        orderside='long',
                        orderset=LONG.ORDERSET.NAME),
         type="chain",parent=LONG.ENTRY.RULE,
         label=LONG.TRAILINGSTOP.RULE)

#-------------------------------------------------------------------------------
# Take Profit
#-----------------------------------------------------------------------------

takeProfit<-0.15
LONG.TAKEPROFIT.RULE<-"LE_LRCSMA_TAKEPROFIT_EXIT"

add.rule(strategy = STRATEGY,name="ruleSignal",
         arguments=list(sigcol=LONG.ENTRY.SIGNAL,
                        replace=FALSE,
                        sigval=TRUE,
                        orderqty='all',
                        TxnFees='evalTxnFees',
                        ordertype='limit',
                        tmult=TRUE,
                        threshold=quote(takeProfit),
                        orderside='long',
                        orderset=LONG.ORDERSET.NAME),
         type="chain",parent=LONG.ENTRY.RULE,
         label=LONG.TAKEPROFIT.RULE)


chart.Posn(Portfolio = PORTOLIO.NAME,symbols=symbol)
close<-Cl(get(symbol))
add_TA(SMA(close,n=30),col="blue",on=1,lwd=2)
add_TA(LRC(close,n=20),col="darkgreen",on=1,lwd=2)

accountDetails<-getAccount(Account = ACCOUNT.NAME)