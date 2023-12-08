# Loan Approval Prediction using Machine Learning
## Overview
This project focuses on predicting whether a customer is eligible for a loan approval or not. It involves data cleaning, exploratory data analysis, and the implementation of machine learning algorithms for classification.

## Libraries Used
- numpy: For numerical operations.
- pandas: For data manipulation and analysis.
- matplotlib and seaborn: For data visualization.
- sklearn: For machine learning algorithms.
## Dataset
The dataset is loaded from a CSV file named 'loan_data.csv', containing information about customers, such as gender, marital status, education, income, loan amount, credit history, and loan status.

## Data Exploration
The dataset is explored using various methods like info(), describe(), and isnull().sum() to understand its structure, types of variables, summary statistics, and identify missing values.

## Data Cleaning
Missing values are handled by imputing them with appropriate measures. Categorical variables are encoded, and outliers are visualized and addressed. The log transformation is applied to some features for normalization.

## Exploratory Data Analysis (EDA)
Exploratory data analysis involves visualizing the data through histograms, boxplots, and count plots to gain insights into the distribution of variables and their impact on loan approval.

## Model Training
The dataset is split into training and testing sets. Label encoding is applied to categorical variables. The machine learning models are implemented:

- Random Forest Classifier
- Naive Bayes Classifier
- Decision Tree Classifier
- K-Nearest Neighbors (KNN) Classifier
## Model Evaluation
The accuracy of each model is evaluated using the test dataset. The accuracy scores are as follows:

- Random Forest Classifier: 76.42%
- Naive Bayes Classifier: 82.93%
- Decision Tree Classifier: 73.98%
- K-Nearest Neighbors Classifier: 79.67%
## Conclusion
The Naive Bayes Classifier is chosen for the loan prediction system due to its highest accuracy metric (82.93%). This model can be further fine-tuned and deployed for real-world loan approval predictions.
