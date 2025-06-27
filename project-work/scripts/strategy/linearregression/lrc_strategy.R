#------------------------------------------------------------------------------------------------
# LRC
#------------------------------------------------------------------------------------------------
LRC <- function(x,n){
  
  regression <- function(dataBlock){
    fit <-lm(dataBlock~seq(1,length(dataBlock),1))
    return(last(fit$fitted.values))
  }
  return (rollapply(x,width=n,regression,align="right",by.column=FALSE))
}
#------------------------------------------------------------------------------------------------
# Fees Function
#------------------------------------------------------------------------------------------------

evalTxnFees<-function(TxnQty, TxnPrice, Symbol,brokerage=0.005,impactCost=0.05)
{
  txnCost<- abs(round(brokerage*(TxnPrice+impactCost)*TxnQty,2))*-1
  return(txnCost)
}
#------------------------------------------------------------------------------------------------
#  Initialization
#------------------------------------------------------------------------------------------------

initPortf(name = PORTOLIO.NAME,symbols = symbol,initDate=initDate)
initAcct(name = ACCOUNT.NAME,portfolios = PORTOLIO.NAME,initDate=initDate,initEq=initEq)
initOrders(portfolio = PORTOLIO.NAME,initDate=initDate)