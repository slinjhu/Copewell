# Copewell Project

## About
This project holds the data for Copewell project. 

- **Home page**: <http://slinjhu.github.io/Copewell>

## Studies
### 1. `Copewell/transformation`
- **Precondition**: Raw data files in the `Copewell/data/` folder. All data files must be in csv format with the filename meaning measure ID. The file takes the following form: 

```
fips   value
1001   1.234
1002   4.321
...    ...
```
Also we need the `list.xlsx` file. The direction column will be used to adjust direction of scaled data. 

- Try various transformation methods and print a list of their results, and then use `./main_scale.m` to transform data and adjust direction. 

- **Postcondition**: Scaled and direction-adjusted data will be saved in the `Copewell/data_scaled/` folder. Each data file has the same file name and format as its corresponding raw data file aforementioned. 

### 2. `Copewell/statistics`
- **Precondition**: Finished data transformation.
- **Postcondition**: Print `./data_scaled.html` and `./data/html` 

### 3. `Copewell/subdomain`
- **Precondition**: Finished data transformation
- **Postcondition**: Print `./index.html` and print covariance matrix, correlation plots, and calculate Cronbach's alpha. 

### 4. `Copewell/aggregate`
- **Precondition**: Finished data transformation. `./sys/list.csv` file containing domain and subdomain information. 
- **Postcondition**: 
   - Save each domain data to `Copewell/data_domain` folder as a csv file. 
   - Save each subdomain data to `Copewell/data_subdomain` folder as a csv file. 
   - Save all domain data to `Copewell/data_domain/all.csv`. 

### 5. `Copewell/solve`
Solve and ODE model and print results. 

- **Precondition**: Finished aggregation.
- **Postcondition**: The code will save results to `./results/`, and the user needs to mannually rename the folder to `result_uniform`, `result_pandemic` or `result_earthquake`

