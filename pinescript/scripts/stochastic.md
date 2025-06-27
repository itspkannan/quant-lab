# Slow Stochastics

## Guidlness

1. Momemtum Indicator - range from 0 to 100.
2. Calculation
    - Period : 14 
    - Two lines %K and %D 
        * ![img](http://latex.codecogs.com/svg.latex?%5C%25K%3D100%2A%5Cfrac%7BC-L_%7B14%7D%7D%7BH_%7B14%7D-L_%7B14%7D%7D)
        * ![img](http://latex.codecogs.com/svg.latex?Slow%7B%5C%25K%7D%3Dsma_%7B3%7D%28%5C%25K%29)
        * ![img](http://latex.codecogs.com/svg.latex?Slow%7B%5C%25D%7D%3Dsma_%7B3%7D%28Slow%5C%25K%29)
3. Oversold less than equal to 30. 
    - Donot initiate new short position below 30.
4. Overbought greater than equal to 70.
    - Donot initiate new long position above 70.

## Crossover Signals

- When the two lines cross in the overbought or oversold region
- Sell Signal occurs when decreasing %K line crosses below the %D line.
- Buy Signal occures when increasing %K crosses above the %D line.


## Divergence
- Stoctastic makes a new higher low in oversold zone and price makes a lower low.
- Stochastic makes a new lower high in overbought zone and price makes a higher high.
- This comparison ignored in a embedded stochastic zone.

## Embedded Stochastic Mode

1. When embedded the trend continues and every correction to the trend pro's generally enter a new position until embedded mode is lost.
2. Embedded mode is not considered when time frame in analysis is either Week or Month. Usually used for analysis for daily time frames.
3. Embedded Bullish Mode 
    * %K and %D line is above 80 for 3 consecutive days.
    * Once %K line crosses below 80, then embedded bullish mode is lost and market has one day to recover the embedded mode.
    * Once market losses the embedded mode, the price action is to move to 18 day moving average of close.
4. Embedded Bearish Mode
    * %K and %D line is above 20 for 3 consecutive days.
    * Once %K line crosses below 20, then embedded bearish mode is lost and market has one day to recover the embedded mode.
    * Once market losses the embedded mode, the price action is to move to 18 day moving average of close.


## Reference 
1. IRA Epstein Training Video, End of Day Financial/Metala/Agricultural Video
2. Slow Stochastic - https://www.fidelity.com/learning-center/trading-investing/technical-analysis/technical-indicator-guide/slow-stochastic
3. Stochastic - https://www.fmlabs.com/reference/default.htm?url=StochasticOscillator.htm

