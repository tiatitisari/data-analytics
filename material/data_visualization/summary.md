== Mind these questions ===
How do you choose an appropriate plot? 
How do you interpret common types of plots?
What are best practices for drawing plots? 

== Proceed the data === 
1. Calculating summary statistics mean, median, standard deviation 
2. Running models : linear and logistic regression 
3. Pick the plot : Scatter, bar, histogram 

== Type of Data ===
1. Continuous : usually numbers 
2. Categorical : usually text ( eye colors, countries, industry)
    a.nominal data -- e.g eye colors 
    b. ordinal data -- e.g survey strongly agree and disagree 
3. both : e.g time is continues and number depend on question want to answer
4. interval 

== Histograms === 
1. If you have a single continuous variable 
2. You want to ask questions about the shape of it's distribution 
3. Depend binwidth to see the shape of distribution 
4. Modality --> how many peaks? 
    a. unimodal : 1 peak 
    b. bimodal : 2 peaks 
    c. trimodal : 3 peaks 
5. Skewness of distribution
    a. left-skewed : extreme values on the left, skewer points leftwards 
    b. symmetric 
    c. right-skewed : extreme values on the right, skewer points rightwards 
6. Kurtosis: how many extreme values? 
    a. leptokurtic : narrow peak and lots of extreme values, important in finance  
    b. mesokurtic : bell curved from normal distribution 
    c. platykurtic : broad peak and few extreme values 

== Box plots == 
1. When you have a continuous variable, split by a categorical variable 
2. When you want to compare the distributions of the continuous variable for each category 
3. The line in the middle show median
4. the lowest line == lower quartile, the highest line == upper quartile. the length between the lowest line and highest line == inter quartile range 
5. whisker show extreme values 

== Scatter Plots == 
1. You have two continuous variables 
2. You want to answer questions about the relationship between the two variables 
3. Correlation : strong negative, weak negative, no correlation, weak positive, strong positive . You can draw trend lines to see the correlation, either straight line or curve line 

== Line Plots == 
1. You have two continuous variable 
2. You want to answer questions about their relationship 
3. Consecutive observations are connected somehow 

== Bar Plots == 
1. You have a categorical variable 
2. You want counts or percentages for each category 
3. You want another numeric score for each category, and need to include zero in the plot 

== Dot Plots ==
1. You have a categorical variable 
2. You want to display numeric scores for each category on a log scale or you want to display multiple numeric scores for each category 

--> Higher dimensions 
1. color (RGB, HCL hue-chroma-luminance), hue for qualitative, diverging to show above or below a midpoint using chroma or luminance 
2. size 
3. transparency 
4. shape
5. thickness 
6. line type (solid, dashes, dots)

--> When should you use a pair plot? 
1. You have up to ten variables (either continuous, categorical, or a mix)
2. You want to see the distribution for each variable 
3. You want to see the relationship between each pair of variables 

--> When you use a correlation heatmap? 
1. you have lots of continous variables 
2. you want to a simple overview of how each pair of variables is related 

---> When you use a parallel coordinates plot? 
1. You have lots of continuous variables. 
2. You want to find patterns accross these variables 
3. You want to visualize clusters of observations 

== pie plot == 
1. bar plot + polar coords 
2. Bar Plots always easier to interpret than pie plots 

== Measures of a good visualization == 
1. How many interesting insights can your reader get from the plot? 
2. How quickly can they get those insights? 
3. Remove Chartjunk : pictures, reflections, shadows, extra dimensions, colors/lines 