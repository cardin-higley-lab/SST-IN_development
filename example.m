% example.m 
% 
% This script reproduces Figure 1 C-F from Wang and Ferguson et al., 2024.
% It runs the function plot_percent_visually_responsive for two different
% cell types ('SOM' and 'PN') to generate the corresponding figures.
%
% Inputs:
%   - cellType: The cell type used in the analysis ('SOM' or 'PN').
%               This input is passed to the plot_percent_visually_responsive function
%               to load and process the relevant data.
%
% Outputs:
%   - The script generates two figures for each cell type, showing the percentage of visually
%     responsive cells for across different age groups.
%

cellType = 'SOM';   
plot_percent_visually_responsive(cellType); 

cellType = 'PN';   
plot_percent_visually_responsive(cellType); 