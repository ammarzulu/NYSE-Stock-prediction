# NYSE-Stock-prediction
This project covers predicting the next day's direction of movement for the index of NYSE based
on various sets of initial variables. I found and analyzed the relevant data:
Article: CNNpred: CNN-based stock market prediction using a diverse set of variables,
Expert Systems with Applications,Volume 129,2019,Pages 273-285, Link:
https://www.sciencedirect.com/science/article/abs/pii/S0957417419301915?casa_token=
X4geTnwiPW0AAAAA:glja7HHWTT2byFbUuJtn_Sii2oOKfZtQHTX8wOtXQQbLK7ZxAa2
L60LPC0EFBGwlJO8bliq9
Authors: Ehsan Hoseinzade, Saman Haratizadeh
For this prediction task, I had 81 potential predictors of the Closing Price for representing each
day of each index. Some of these variables are index-specific while the rest are general
economic variables and are replicated for every index in the data set. This set of predictors can
be categorized in eight different groups: primitive variables, technical indicators, world stock
market indices, the exchange rate of U.S. dollar to the other currencies, commodities, data from
big companies of the U.S. markets, future contracts and other useful variables.
This data is from the period of Jan 2010 to Nov 2017. It had 1985 observations, including those
with missing values. After omitting them, I was left with 1114 observations. The first 80% of the
data is used for training the model and the last 20% is the test data. The value being analyzed
was “Close” that is the closing price of NYSE. I dropped the columns “date” and column 59 as it
was not identified as the potential predictors
