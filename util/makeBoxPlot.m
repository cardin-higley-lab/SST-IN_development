function plbx = makeBoxPlot(x, g, varargin)

% MAKEBOXPLOT creates a customized box plot with specified (or default) labels and colors.
% 
% Inputs:
% - x: a numeric vector containing the data to be plotted.
% - g: a numeric vector specifying the grouping variable.
% Optional Name-Value Pairs:
% - 'Labels': a cell array of strings specifying the labels for each box. Default is numbered labels.
% - 'Color': a cell array of strings specifying the colors for each box. Default is MATLAB default colors.
% - 'GroupOrder': a cell array of strings specifying the order of groups. Default is MATLAB default: sorts 
% character and string grouping variables in the order they initially appear in the data, categorical grouping 
% variables by the order of their levels, and numeric grouping variables in numeric order.
%
% Outputs: 
% - plbx: a handle to the box plot object.
%
% Usage:
% plbx = makeBoxPlot(x, g) % with default labels and colors
% plbx = makeBoxPlot(x, g, 'Color', bxColor) % with specified colors
% plbx = makeBoxPlot(x, g, 'Labels', bxLabel) % with specified labels
% plbx = makeBoxPlot(x, g, 'Labels', bxLabel, 'Color', bxColor) % with both
% plbx = makeBoxPlot(x, g, 'Labels', bxLabel, 'Color', bxColor, 'GroupOrder', bxGroupOrder); 
%
% written by Katie Ferguson, Yale University, 2023

% Default values
bxLabel = {};
bxColor = 'b'; % Default color
bxGroupOrder = []; 


% Parse varargin for optional arguments
for i = 1:2:length(varargin)
    if strcmp(varargin{i}, 'Labels')
        bxLabel = varargin{i+1};
    elseif strcmp(varargin{i}, 'Color')
        bxColor = varargin{i+1};
    elseif strcmp(varargin{i}, 'GroupOrder')
        bxGroupOrder = varargin{i+1};
    end
end

% If bxLabel is not provided, generate default labels
if isempty(bxLabel)
    if iscategorical(g)
        bxLabel = categories(g);
    else 
        uniqueG = unique(g);
        bxLabel = arrayfun(@num2str, uniqueG, 'UniformOutput', false);
    end
end


% Create the box plot
if isempty(bxGroupOrder)
plbx = boxplot(x, g, ...
    'symbol', '', 'Labels', bxLabel, 'Color', bxColor);
else
    plbx = boxplot(x, g, ...
    'symbol', '', 'Labels', bxLabel, 'Color', bxColor, 'GroupOrder', bxGroupOrder);
end

hold on;

% Remove the caps on the whiskers
set(findobj(plbx, 'Tag', 'Upper Adjacent Value'), 'Visible', 'off');
set(findobj(plbx, 'Tag', 'Lower Adjacent Value'), 'Visible', 'off');


% adjust colors, highlight median
h=findobj('LineStyle','--'); set(h, 'LineStyle','-');
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'), get(h(j),'YData'), h(j).Color, 'FaceAlpha', .5);
end
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','linewidth',2);

