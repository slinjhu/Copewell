clear, clc, close all
tspan = linspace(0, 12, 121); % unit: month
global var_list;
global Event0;
var_list = {'ER', 'CF', 'SC', 'PR', 'PreCF', 'PVID', 'PM'};

%% Solving
CF0 = 0.5;
Event0 = 0.5;
W0 = 0.5 * ones(length(var_list), 1);
W0(2) = CF0;
W0(5) = CF0;

% solving
[~, W ] = ode45( @fdW, tspan, W0);
CFlog = W(:,2);
% Resillience and Resistance
thisCF = CFlog;
thisCFrelative = thisCF / CF0;
Resilience = mean(thisCFrelative);

[CF_min, idx_min] = min(thisCF);
Resistance = CF_min / CF0;
thisCF = thisCF(idx_min: end) - CF_min;
thisCF = thisCF / (CF0 - CF_min);
if max(thisCF) > 0.5
    tHalf = interp1(thisCF, tspan(idx_min: end), 0.5);
else
    tHalf = 12;
end
RecoveryRate = 1/tHalf;

plot(tspan, CFlog)
axis([0, 12, 0, 1])
