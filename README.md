# Understanding The Toronto Demographic Seeking Shelter Services For The Year 2024

## Overview

This paper aims to study the various factors that influence the daily service count of demographics that seek shelter services across Toronto. By examining the demographics, the type of shelter, and the various services it offers, we hope to better understand the key factors that influence these shelter service counts. We believe the results from this study can help us understand the key factors that influence the shelter service count and provide valuable information in better supporting shelters and developing policies to improve the homelessness situation in Toronto.

## File Structure

The repo is structured as follows:

- `data` contains all the data necessary provided by OpenData Toronto.
  - `data/00-simulated_data` contains a sample simulated dataset.
  - `data/01-raw_data` contains the raw data taken from OpenData Toronto. A link to the dataset can be found [here](https://open.toronto.ca/dataset/daily-shelter-overnight-service-occupancy-capacity/).
  - `data/02-analysis_data` contains the cleaned dataset that is used for analysis purposes. This folder also contains the split training and test data. All analysis data is saved as parquet files.
- `models` contains the Poisson and two negative binomial models for this study. These are saved in RDS format.
- `other` contains relevant sketches and LLM usage documentation.
  - `other/llm` contains a usage.txt file outlining the prompts used by ChatGPT to assist in the programming aspect of the project.
  - `other/sketches` contains an 'analysis_graphs.jpeg' and 'shelter_dataset.jpeg' outlining how we expect our dataset and graphs to look in this project.
- `paper` contains the files used to generate the paper.
  - `paper/paper.qmd` contains a Quarto document used to write the report and includes R components to generate graphs.
  - `paper/paper.pdf` contains the compiled pdf document per the Quarto document content.
  - `paper/references.bib` contains a bibliography document outlining all the relevant literature and R package references used in this project.
- `scripts` contains the R scripts used in this project.
  - `scripts/00-simulate_data.R` contains the R script used to simulate how our dataset could look like before downloading it from OpenData Toronto.
  - `scripts/01-test_simulated_data.R` contains the R script used to test the simulated dataset.
  - `scripts/02-download_data.R` contains the R script used to download the dataset from OpenData Toronto and save a CSV version.
  - `scripts/03-clean_data.R` contains the R script used to perform various data cleaning methods to create the final parquet data used for analysis. Training and test data are also created and saved as parquet files in this script.
  - `scripts/04-test_analysis_data.R` contains the R script used to test the analysis dataset.
  - `scripts/05-model_data.R` contains the R script used to create Bayesian models for our study. These models are trained on the testing data. These are saved as RDS in the models folder.
  - `scripts/06-test_models.R` contains the R script to test our models on the test dataset.


## How to run this project?

Please open the __quantitative-analysis-of-canada-shelters.Rproj__ file to run the project. It is recommended you have R and RStudio v4.4 installed on your machine. To compile the Quarto document, please navigate to the paper.qmd under the 'paper' folder and click __Render__.

## Important Note

Due to the large volume of data observations available from our dataset, the fitting of the models takes about 15 minutes in the `scripts/05-model_data.R`. Similarly, the Quarto document can take about 5-10 minutes to compute due to the extensive time taken by the `loo_compare()` function which performs several computations for each of the proposed models.

I thank you for your patience in waiting for the models to compute.

### How can I speed up the compute time of the models?

If you would like to speed up this process, please increase the `core` parameter in `loo()` to more than 2. Before you increase this, it is advised to check how many cores you have available on your machine by typing the following in the terminal: `parallel::detectCores()`. Please be sure to leave a few cores (a minimum of 2) as idle which will be used by your computer's Operating System (OS) in running your machine. Increasing cores to a large number will result in your computer slowing down significantly. Please use this with caution to avoid increased performance overhead on your machine.

## Statement on LLM usage

Aspects of the code and improving wordings in the report were done with the help of ChatGPT 4 and ChatGPT-4o daily free limit. The entire chat history with the LLM is available in other/llm/usage.txt.
