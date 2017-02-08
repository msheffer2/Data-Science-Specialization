## Data Science Specialization Final Report

The files in this repository were used as my Capstone submission for the Johns Hopkins Data Science Specialization.  

The courses in the specialization didn't offer a lot of new material in regards to modeling, but at the time I decided to take the specialization I was trying to ween myself off of SAS and onto R full time.  The courses in the specilation were great for forcing my hand in that way!

There were specific requirements for the Capstone project that differ from how I might typically work but the final 
[Captone Report](https://github.com/msheffer2/Data-Science-Specialization/blob/master/report/Capstone_Report.pdf)  offers a good overview of the material covered.  Although I didn't need to perform so many models (I ended up performing 12 predictive algorithms for the report), I personally tend to try a lot of different algorithms in my own work so it only seemed natural to try many things here too.  

Technically, the PDF Captsone Report was all that was required but I also submitted a github repository for those interested in seeing my syntax, which I've recreated here.  This repository includes most of the datafiles required to replicate this work (excluding the original Yelp datasets, due to file size and general availability elsewhere) and all of the saved outputs generated via the syntax files.  In addition to the markdown document used to create the final PDF report, 7 syntax files are provided describing the workflow.

### R syntax files I used to generate the material necessary for the report, including:
* [01 - Codeup.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/01%20-%20Codeup.R) -- takes two of the Yelp Review datasets and manipulates them in prepration for later use
* [02 - Buidling the DTM.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/02%20-%20Building%20the%20DTM.R) -- creates a corpus from the reviews, cleans it, and outputs a document-term matrix appropriate for use as predictors in the models to follow
* [03 - EDA.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/03%20-%20EDA.R) -- A subset of the exploratory data analysis performed for the project; only EDA used in the final report are included 
* [04 - Five Star Models.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/04%20-%20Five%20Star%20Models.R) -- syntax for conducing the 6 different models predicting if a rating is a 5-star rating or not 
* [05 - One Star Models.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/05%20-%20One%20Star%20Models.R) -- syntax for conducing the 6 different models predicting if a rating is a 1-star rating or not
* [06 - Compiling Model Results.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/06%20-%20Compiling%20Model%20Results.R) -- this small file simply combines the various outputs into tables that show the predictive accuracy of the 12 models; the tables are used in the final report
* [07 - Variable Importance.R](https://github.com/msheffer2/Data-Science-Specialization/blob/master/07%20-%20Variable%20Importance.R) -- a few analyses to understand what words drive rating; problematically, the naive bayes was the most accurate but NB models don't lend themselves well to describing what predictors are important, so results from the C5.0 model are used as a proxy

### All of this work should be entirely replicable and should offer a pretty good idea of my workflow and how I like to organize my files.

### Notes:
* Larger data files have been compressed and split using 7-zip for reproducibility
* Although the model syntax files are set up as if they can be run from start to finish, it's not likely to be used in this way due to the considerable amount of time required to run the models.
