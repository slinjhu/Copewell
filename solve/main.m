% Copyright by 2014 Johns Hopkins University.
clear, clc
if ~exist('results', 'dir')
    mkdir('results');
end
T = readtable('../data_domain/all.csv', 'ReadRowNames',true);
tspan = linspace(0, 12, 121); % unit: month
global var_list;
global Event0;
var_list = {'ER', 'CF', 'SC', 'PR', 'PreCF', 'PVID', 'PM'};
N = size(T,1);

%% Solving
Resistance = zeros(N, 1);
Resilience = zeros(N, 1);
RecoveryRate = zeros(N, 1);
CF0 = T{:,'CF'};
CFlog = zeros(N, length(tspan));
for i_county = 1%:N
    fprintf('>>> Calculating county %d\n', i_county);
    % For uniform and pandemic event, use constant Event0; For earthquake
    % event use Event0 from data. 
    Event0 = 0.5;
    %Event0 = T{i_county, 'Event'};
    
    W0 = zeros(length(var_list), 1);
    for i_var = 1:length(var_list)
        switch var_list{i_var}
            case {'PreCF'}
                W0(i_var) = CF0(i_county);
            case {'ER', 'PR'}
                W0(i_var) = 0.5;
            otherwise
                W0(i_var) = T{i_county, var_list{i_var}};
        end
    end
    % solving
    [~, W ] = ode45( @fdW, tspan, W0);
    CFlog(i_county, :) = W(:,2);
    % Resillience and Resistance
    thisCF = W(:,2);
    thisCFrelative = thisCF / CF0(i_county);
    Resilience(i_county) = mean(thisCFrelative);
    
    [CF_min, idx_min] = min(thisCF);
    Resistance(i_county) = CF_min / CF0(i_county);
    thisCF = thisCF(idx_min: end) - CF_min;
    thisCF = thisCF / (CF0(i_county) - CF_min);
    if max(thisCF) > 0.5
        tHalf = interp1(thisCF, tspan(idx_min: end), 0.5);
    else
        tHalf = 12;
    end
    RecoveryRate(i_county) = 1/tHalf;
end
plot(tspan, CFlog(1, :))
axis([0, 12, 0, 1])

%% Output results
! rm result/*.csv
save_data('Resilience (relative).csv', Resilience);
save_data('Resilience (absolute).csv', Resilience.*CF0);
save_data('Resistance.csv', Resistance);
save_data('RecoveryRate.csv', RecoveryRate);

for i = 11:10:121
    month = round((i-1)/10);
    filename = sprintf('Absolute CF at Month %02d.csv', month);
    save_data(filename, CFlog(:, i));
    filename = sprintf('Relative CF at Month %02d.csv', month);
    save_data(filename, CFlog(:, i)./CF0);
end

