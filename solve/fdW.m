function dW = fdW(t, W)
% Copyright by 2014 Johns Hopkins University.
%% Acronyms
% CF: Community Functioning
% PVID: Population Vulnerability, Inequity, Deprivation
% SC: Social Cohesion
% ER: Emergency Management / External Resources
% PR: Preparadness
%%
isPandemic = true;

global var_list;
global Event0;
for i = 1:length(var_list)
    eval(sprintf('%s = max(W(%d), 0);', var_list{i}, i));
end

%% constant variables
Event_damage_rate_constant = 4;
ER_flow_rate_constant  = 1;
PR_flow_rate_constant = 1;
SC_flow_rate_constant   = 1;
CF_depletion_rate_constant = 5;



%% CF replenish
CF_drop = max( PreCF - CF, 0 );
SC_flow_rate = SC_flow_rate_constant * CF * SC * CF_drop;
PR_flow_rate = PR_flow_rate_constant * PR * CF_drop;
ER_flow_rate = ER_flow_rate_constant * ER * CF_drop;
CF_replenish_rate = SC_flow_rate + PR_flow_rate + ER_flow_rate;


%% CF depletion rate
if isPandemic
    tau = 2; % event peak (mean)
    sigma = 1; % event spead (std)
    coef = 1 / sqrt(2*pi*sigma^2);
    Event_t = Event0 * coef * exp(-(t-tau)^2 / (2*sigma^2));
else
    k = Event_damage_rate_constant;
    Event_t = Event0 * k * exp(-k * t);
end

Event_damage_rate =  Event_t * (PM + PVID)/2;

CF_depletion_rate = CF_depletion_rate_constant * CF * Event_damage_rate;

%% Derivatives
dSC = -SC_flow_rate;
dPR = - PR_flow_rate;
dER = - ER_flow_rate;
dCF = - CF_depletion_rate + CF_replenish_rate ;

dW = zeros(length(var_list), 1);
for i = 1:length(var_list)
    fieldname = var_list{i};
    switch fieldname
        case {'PreCF', 'PVID', 'PM'} % for constant values.
            dW(i) = 0;
        otherwise
            eval(sprintf('dW(%d) = d%s;', i, fieldname));
    end
end

