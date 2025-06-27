# Scripts for Trading View 

These scripts were developed based on inputs from Ira Epstein - fundamentals of trading course

The folder contains pine scripts with the following technical analysis indicator for trading view.

1. Moving Average
2. Bollinger Bands
3. Swinglines
4. Slow Stochastics
5. Window Envelops

## Moving Average

**Script Name**: movingaverage.pine

**Study** :

1. SMA 3 period high
2. SMA 3 period low
3. SMA 18 peroid close
4. SMA 45 period close
5. SMA 100 period close
6. SMA 200 period close


## Bollinger Band


**Script Name**: bollingerband.pine

**Study**:

1. Two standard deviation of 18 period SMA.

## Singlines

**Script Name** : swinglines.pine

## Rules for Swing Line

1. Higher High Rule - Draw to the High 
2. Lower Low Rule - Draw to the low
3. Outside day up - Draw to the low
4. Outside Day down - Draw to the up
5. Inside Day  - Opposite of Previous Day

If there are two consecutive inside days, then rule of inside day is still the same draw to opposite of previous day.

Scenario One : Swing High Day1
1. First Day Higher High or Outside day down  - Draw to the high
2. Second Day Inside Day  - Opposite of previous day -  ie draw to the low of inside day
3. Third Day Inside Day  - Opposite of previous day -  ie draw to the high of inside day

Scenario two: Swing Low Day2
1. First Day Higher High or Outside day down  - Draw to the high
2. Second Day Inside Day  - Opposite of previous day -  ie draw to the low of inside day
3. Third Day Inside Day  - Opposite of previous day -  ie draw to the high of inside day
