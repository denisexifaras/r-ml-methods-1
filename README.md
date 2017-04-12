# r-ml-methods
Initial R code for running basic ml methods

# R

Go to: <a href="r-fiddle.org" target="_blank">r-fiddle.org</a>. 
The fiddle will begin a new session, which you can save and share with others. If you refresh the page, it is likely that it will still remember some of the commands that you have executed. If you wish to start with a clean slate, re-visit r-fiddle.org.

The top panel is an editor. The bottom panel is the console. Although you can type in code in the console directly, it is advisable to use the editor and the "run" button in order to be clear on when the code has finished executing. 

# The Data

The data lives in a public S3 bucket. It has already been scaled.

# Methods

The file `methods.R` has some code to get you started. You will see how to read in data, split it into `train` and `test` sets and how to run:
* a linear model
* decision trees
* random forests
* SVM
* neural networks

You will also find code for making predictions on the `test` set, make a plot of `predicted` vs `original` values, and calculate the Mean Square Error (MSE). 

The objective is to modify the code in order to minimise the MSE.

*Warning* <small>even with a relatively small data set you might encounter big data problems. Start out small :)</small>
