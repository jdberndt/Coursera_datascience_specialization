#copy data and add labels to am factor variable
cars <- within(mtcars, {
        vs <- factor(vs, labels = c("V", "S"))
        am <- factor(am, labels = c("automatic", "manual"))
        cyl  <- ordered(cyl)
        gear <- ordered(gear)
        carb <- ordered(carb)
})

#what do the data look like
boxplot(mpg~am, cars)

#is the difference in mpg in a vs. m larger than chance
t.test(mpg~am, cars)

#what is the relationship
summary(lm(mpg~am, cars))

#what other variable may be correlated
anova(lm(mpg~., cars))

#what if we model the data using additional covariates
summary(lm(mpg~am+cyl+disp+wt, cars))

#how confident can we be in these estimated coefficients
confint(lm(mpg~am+cyl+disp+wt, cars))
