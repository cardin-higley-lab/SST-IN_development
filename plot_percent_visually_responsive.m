function plot_percent_visually_responsive(cellType)

% PLOT_PERCENT_VISUALLY_RESPONSIVE plots the percentage of visually
% reponsive cells across days in two formats, an error bar plot and a
% grouped box plot, corresponding with Wang, Ferguson, et al., 2024, Fig. 1.
% 
% Inputs:
%   cellType: String specifying the type of cell (e.g., 'SOM', or 'PN').
%       The string is used to locate the appropriate data file/ 
%
% Requirements: 
%   - The data is saved in a 'percentVisResp' field inside a .mat file located
%      in the 'sample_data' directory. The file must follow the naming convention
%      'percent_vis_resp_<cellType>.mat'.
%   - The .mat file contains the following variables:
%       d.percentVisResp: Matrix of percentage of visually responsive cells.
%       d.age: Vector of age groups corresponding to each day.
%       d.recID: Table containing the recording IDs.
%       d.expType: String specifying the experiment type
%
% Output:
%   - The function creates two figures:
%       1. An error bar plot showing the percentage of visually responsive cells across days.
%       2. A grouped box plot comparing different age groups.
%
%
% Katie Ferguson, 2024
%

fileName = sprintf('percent_vis_resp_%s.mat', cellType); 
dirName = 'sample_data'; 

load(fullfile(dirName, fileName)); 

percVR = d.percentVisResp; 

opt = setFig1Options(d.expType); 

% make error bar plot across all days
makeErrorBarFig1(percVR, d.age, d.recID, opt)

% make box plot with grouped days
makeBoxPlotFig1(percVR, d.age, d.recID, opt); 


end


function makeErrorBarFig1(percVR, age, recID, opt)

% MAKEERRORBARFIG1 creates an error bar plot for visually responsive cells
% across individual ages
%
% Inputs:
%   percVR: Matrix of percentage of visually responsive cells
%   age: Vector of age groups (in days)
%   recID: Table containing the recording IDs.
%   opt: Struct containing figure and plot options (e.g., color, size, labels)

meanVR = mean(percVR, 1, 'omitnan'); 
semVR = std(percVR, [], 1, 'omitnan')./sqrt(sum(~isnan(percVR),1));

nRecs = size(recID, 1); 
x = repmat(age, nRecs, 1); 

figure(opt.f1); 

scatter(x, percVR, ...
    opt.scatter.size, 'filled', 'MarkerFaceColor', opt.color, 'MarkerEdgeColor', opt.color,...
        'MarkerFaceAlpha', opt.scatter.alpha,'MarkerEdgeAlpha', opt.scatter.alpha )
hold on; 

errorbar(age, meanVR, semVR, ...
    'o', 'Color', opt.color, 'CapSize', opt.errorbar.capsize , ...
    'MarkerSize', opt.errorbar.size, 'MarkerEdgeColor', opt.color, 'MarkerFaceColor', opt.color);

nAges = length(age); 
ageGroupStr = arrayfun(@(x) sprintf('P%d', age(x)), 1:nAges, 'un', 0); 
set(gca,'xtick', age, 'xticklabel', ageGroupStr);

title(opt.titleStr);
ylim(opt.ylim);
xlabel(opt.xlabel); 
ylabel(opt.ylabel); 

end

function makeBoxPlotFig1(data, age, recID, opt)

% MAKEBOXPLOTFIG1 creates a box plot for visually responsive cells
% grouped by age 
%
% Inputs:
%   percVR: Matrix of percentage of visually responsive cells
%   age: Vector of age groups (in days)
%   recID: Table containing the recording IDs.
%   opt: Struct containing figure and plot options (e.g., color, size, labels)

figure(opt.f2); 

ageGroups = reshape(age, opt.groupSize, [])';  
nGroups = size(ageGroups, 1); 
nRecs = size(recID, 1); 

ageGroupIdx = repelem(1:nGroups, opt.groupSize); 

dataGrouped = cell2mat(arrayfun(@(y) accumarray(ageGroupIdx', data(y, :)', [], @(x) mean(x, 'omitnan')), 1:nRecs, 'un', 0))'; 
gr = repmat(1:nGroups, nRecs, 1); 

ageStr = arrayfun(@(x) sprintf('P%d-%d', ageGroups(x,1), ageGroups(x,end)), 1:nGroups, 'un', 0); 

makeBoxPlot( dataGrouped(:), gr(:), 'Labels', ageStr, 'Color', opt.color);

title(opt.titleStr);
ylim(opt.ylim);
ylabel(opt.ylabel);
set(opt.f2, 'Position', opt.f2position); 


end

function opt = setFig1Options(expType)

% SETFIG1OPTIONS sets options for figure and plot formatting based on experiment type
%
% Inputs:
%   expType: String specifying the experiment type (e.g., 'SOM', 'PN')
%
% Outputs:
%   opt: Struct containing plot options such as colors, figure handles, and labels

opt.f1 = figure;
opt.f2 = figure;

if contains(expType, 'SOM')
    opt.color = [71,160,216]./255; 
elseif contains(expType, 'PN')
    opt.color = [0, 0, 0]; 
end

opt.ylim = [0 100]; 

opt.scatter.alpha = 0.2; 
opt.scatter.size = 20; 

opt.errorbar.size = 6; 
opt.errorbar.capsize = 0; 

opt.titleStr = expType; 
opt.xlabel = 'Age (days)'; 
opt.ylabel = '% Visually Responsive'; 

opt.groupSize = 3; 

opt.f2position = [600 350 335 400]; 


end

