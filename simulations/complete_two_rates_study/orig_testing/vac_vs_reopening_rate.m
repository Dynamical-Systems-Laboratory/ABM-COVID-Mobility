%
% Total cases and total deaths vs. reopening rate
% Loads and plots the final numbers vs. the reopening rate 
%

clear; close all

% Input
% Town population
n_pop = 79205;
% Number of independent simulations in each set
num_sim = 100;
% Common file name
mname = 'dir';

% Files to consider
dir_names = dir([mname, '_*']);
dir_names = {dir_names.name};
ndirs = length(dir_names);
% Extract the numbers in file endings (these are reopening rates)
str=sprintf('%s#%s#', dir_names{:});
num = sscanf(str, [mname,'_%d-%f#']);
% Numbers to consider
vac_num = sort(unique(num(1:2:end)));
re_num = sort(unique(num(2:2:end)));
% For array sizes
n_vac = length(vac_num);
n_re = length(re_num);

% These will be average values over all realizations
total_cases = zeros(n_vac, n_re);
total_deaths = zeros(n_vac, n_re);

% x (reopening) and y (vaccination) axes
reopening_rates = re_num;
vac_rates = vac_num;

for ii = 1:n_vac
    for jj = 1:n_re
        % Name of the directory, this may crash if the numbers are not in
        % the same format as the ones in the directory name
        str = sprintf('%f',re_num(jj));
        str = regexprep(str,'([1-9])[0]+','$1');
        dname = sprintf([mname,'_%d-%s'], vac_num(ii), str);
        fprintf('Processing: %s\n', dname)
        temp = load([dname,'/fixed_vac_var_reopening.mat']);
        % Averages over all realizations
        total_deaths(ii,jj) = mean(temp.tot_deaths(:,end));
        total_cases(ii,jj) = mean(temp.tot_infected(:,end));
    end
end

%
% Plot results from all simulations
%

% Plot settings

% Color for the largest value in the heatmap
max_clr = [0.64, 0.08, 0.18];
% Number of colors to use (lowest is white)
clr_points = 20;

plot_title = 'Total deaths';
ylimits = [0,450];
% Contours
clevels = [50 150 200 300 350];
cb_ticks = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450];
cb_tick_labels = {'0', '50', '100', '150', '200', '250', '300', '350', '400', '450'};
plot_heatmap(reopening_rates, vac_rates, total_deaths, 1, plot_title, max_clr, clr_points, ylimits(2), 1, n_pop, cb_ticks, cb_tick_labels, clevels)

plot_title = 'Total infected';
ylimits = [0,50000];
% Contours
clevels = [5000, 15000, 25000, 35000, 45000];
cb_ticks = [0, 0.5e4, 1e4, 1.5e4, 2e4, 2.5e4, 3e4, 3.5e4, 4e4, 4.5e4, 5e4];
% cb_tick_labels = {'0', '5,000', '10,000', '15,000', '20,000', '25,000', '30,000', '35,000','40,000', '45,000', '50,000'};
% These are actually x10^4
cb_tick_labels = {'0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5','4', '4.5', '5'};
plot_heatmap(reopening_rates, vac_rates, total_cases, 2, plot_title, max_clr, clr_points, ylimits(2), 1, n_pop, cb_ticks, cb_tick_labels, clevels)


function plot_heatmap(x, y, values, i, ylab, max_clr, clr_points, clim, use_percent, n_pop, cb_ticks, cb_tick_labels, clevels)

    % Create figure
    figure1 = figure(i);
   
    % Convert to %
    x = x'*100;
    
    % Convert number of residents to percent population
    if use_percent
        y = y/n_pop*100;
    end
    
    % First check the acutal limits, then restrict ColorLimits - otherwise
    % biased
%     h = heatmap(x,y,values,'Title', ylab, 'CellLabelColor','none');
    h = heatmap(x,y,values,'Title', ylab, 'CellLabelColor','none', 'ColorLimits', [0,clim], ...
        'InnerPosition',[0.177438591597373 0.191765170084011 0.6530877241921 0.708234829915988]);
    
    % Create custom colormap
    colorMap = [linspace(1,max_clr(1),clr_points)', ...
                linspace(1,max_clr(2),clr_points)',...
                linspace(1,max_clr(3),clr_points)'];
    colormap(h, colorMap)
    h.GridVisible = 'off';
    
    % Labels
%     h.XLabel = 'Reopening rate, %/day';
%     if use_percent
%         h.YLabel = ['Vaccination rate,', newline, '%(population)/day'];
%     else
%         h.YLabel = 'Vaccination rate, people/day';
%     end
  
    % This should be preceeded by examining the range
    % Customize y ticks if using percents
    if use_percent
        % First check
        CustomYLabels = {'0.01', '0.02', '0.05', '0.1', '0.2', '0.5', '1', '2', '5'};
        h.YDisplayLabels = CustomYLabels;
    else
        h.YDisplayLabels = {'5', '50', '100', '250', '500', '750', '1,000', ...
                           '2,500', '5,000', '8,000'};
    end
    h.YDisplayData = flipud(h.YDisplayData); 
                    
    % Adjust colobar 
    hCB=h.NodeChildren(2);         
    hCB.Ticks = cb_ticks;
    hCB.TickLabels = cb_tick_labels;
      
    % Fonts
    h.FontName = 'SanSerif';
    h.FontSize = 28;
   
    % Size
    set(gcf,'Position',[200 500 950 750])
    
    % Contours
    hAx = axes('Position',h.Position,'Color','none'); 
    hold on
    [M,c] = contour(hAx,round(values),clevels, 'ShowText','on','LevelList',clevels);
    
    format short e
    
    clabel(M,c,'FontSize',22,'Color','k', 'FontName', 'SanSerif')
    
%     texth = clabel(M,c,'manual','FontSize',24,'Color','k', 'FontName', 'SanSerif')
  
%     for itn = 1:length(texth)
%         textstr=get(texth(itn),'UserData');
%         %textnum=str2num(textstr);
%         %textstrnew=num2str(textnum,'%.0e');
%         textstrnew=char(num2str(textstr,'%.0e'));
%         set(texth(itn),'String',textstrnew);
%     end
%     

%     c.YAxis.TickLabelFormat = '%,.0f';
    % To see what is available
%      [M,c] = contour(hAx,round(values),5, 'ShowText','on')
    c.LineWidth = 2.5;
    c.LineColor = 'k';
    axis(hAx,'tight');
    hold(hAx,'off');
    % Set the remaining axes properties
    set(hAx,'Color','none','XTick',zeros(1,0),'YTick',zeros(1,0));

    
 
end