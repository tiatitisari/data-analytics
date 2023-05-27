== Definition == 
The practice and study of collecting and analyzing data 

== Two main branches of statistics== 
1. Descriptive/summary statistics - describing or summarizing our data 
2. inferential statistics - collect a sample of data, and apply the results to the population that the sample represents 

== Limitations of statistics == 
1. Statistics requires specific, measurable questions 
2. We can't use sttistics to find out why relationship exist 

== Measures of Center == 
1. Mean : sum of all values / count of all values
2. Median : middle value of given data 
3. Mode : most frequent value 
4. For extreme value avg more affected than median depends on the data, if the data assymetrical better use median as middle value

== Measures of spread == 
1. definition : how much variety of the data 
2. how to calculate: 
    a. Range : maximum - minimum 
    b. Variance : The distance a value to the mean (in square) divided by number of data
    c. Standard deviation : Root squared of variance. The closest standard deviation to zero the more closely clustered around the mean 
    d. Quartiles : splitting the data into four equal parts (0,25,50,75,100)
    e.IQR : 3rd quartile - 1st quartile >> less affected on extreme values 

== Probability and Distributions == 
1. Measuring Chance > P(event) = # ways event can happen/ total # of possible outcomes (within range 0% - 100%)
2. Independent Probability == Sampling with replacement, the probability will not change after event 
3. Conditional Probability == Sampling without replacement , the probability will change after previous event . Each pick dependent 
4. Probability distribution == Describe the probability of each possible outcome in a scenario. There are fair die which every probability has the same chance and uneven die if not every probability has the same chance 
    a. Help us to quantify risk and inform decision making 
    b. Used extensively in hypothesis testing : probability that the results occured by chance 
5. Law of Large Numbers as the size of your sample increases, the sample mean will approach the expected value/ theoterical mean (discrete uniform distribution)
6. Continuous Distributions : for continuous data type 

== Binomial Distribution == 
1. Probability distribution of the number of successes in a sequence of independent events 
2. n : number of events, p : the probability 
3. expected value = n x p 
4. Requirement : 
    a. there are sequence of independent events 
    b. produce binary outcomes 

== Normal Distribution == 
1. bell curved, symmetrical, area beneath the curve equal 1, never touch 0 even on the tail 
2. 68-95-99-point-seven rule. 68% of the curve represented by 1 standard deviation, 95% of the curve represented by 2 standard deviation, 99% of the curve represented by 3 standard deviation 
3. Lots of real-world data resembles a normal distribution. 
4. A normal distribuation is required of all hypothesis testing 
5. Skewness : 
    a. positive skewed : the curve on the right side of chart  
    b. negative skewed : the curve on the left side of chart 
6. Kurtosis: 
    a. leptokurtic : large peak around the mean and smaller standard deviation
    b. mesokurtic : normal distribution
    c. platykurtic : negative kurtoses, lower peak and higher standard deviation 

== The Central Limit Theorem == 
1. The sampling distribution of a statistic become closer to the normal distribution as the size of the sample increases 
2. Should be taking randomly and independent 
3. Minimum sample 30 

== The Poisson Distribution == 
1. Definition : Average # of events in a period is known but the time or space between events is random 
2. Calculate probability of some # of events occuring over a fixed period of time 
3. represent by lambda = average number of events per time interval 

== Hypothesis Testing == 
1. null hypothesis : Assume nothing 
2. Alternative hypothesis : There's a difference 
3. Workflow: 
    a. Define the target populations 
    b. Develop null and alternative hypothesis
    c. Collect or access sample data 
    d. Perform statistical test on sample data 
    e. Draw conclusion 
4. independent variable : unaffected by other data always in x axis 
5. dependent variable : affected by other data  

== Experiments ==   
1. Experiment : Treatment group, control group 
2. Randomization : Randomly assigned treatment/control without any characteristics. Known as randomized controlled trial. 
    a. Can be multiple treatment groups 
    b. A/B testing 
3. Blinding 
4. Double-blind randomized controlled trial 
5. Fewer opportunities for bias == more reliable conclusion about causation 

== Correlation == 
1. Pearson correlation coefficient : Quantifies the strength of a relationship between two variables, number between minus one and one. Only used for linear relationship 
2. Correlation not equal causation 
3. Cofounding variable : not measured but may affect the relationship between variables 

== Interpreting hypothesis test results == 
1. p- value : probability of achieving this result, assuming the null hypothesis is true 
2. To reduce the risk of drawing a false conclusion we need to set a probability threshold for rejecting the null hypothesis known as alpha or significance level. Valye 0,05 meaning there's 5% false conclusion. If p-value <= alpha then reject null hypothesis called statistically significant 
3. Type I/II error 
    a. Type I Error null hypothesis is True but rejected 
    b. Type II Error hypothesis is false but we accept null hypothesis 


