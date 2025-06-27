xyplot(accountDetails$summary,type="h",col=4)

equity<-accountDetails$summary$End.Eq

plot(equity,main="LRC Equity Curve")








chart.ME(Portfolio=PORTOLIO.NAME, Symbol=symbol, type='MAE', scale='percent')
chart.ME(Portfolio=PORTOLIO.NAME, Symbol=symbol, type='MAF', scale='percent')




equity.curve <- getAccount(Account = ACCOUNT.NAME)$summary$End.Eq

returns.ns <- Return.calculate(equity.curve,"log")

table.AnnualizedReturns(returns.ns,geometric = FALSE)
table.AnnualizedReturns(returns.ns,geometric = TRUE)


charts.PerformanceSummary(returns.ns,wealth.index=TRUE,geometric = FALSE,
                          colorset="blue",xlab="",
                          main="LRC Performance ",minor.ticks=FALSE)