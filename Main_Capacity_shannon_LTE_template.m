close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Declaration of Main simulations paramteres
Area_x=1000; % Definition of Area in meters (x-axes)
Area_y=1000; % Definition of Area in meters (y-axes)
Number_MS=20; % Number of MS in the system
Number_BS=4;
NoOfSteps=1000; % Number of simulation steps
Step=1; % duration of one step
Speed_max=2; % Max speed [mps]
f=2; % carrier frequency in GHz
Pt=43;  %transmission power in dBm
BW = 20*10.^6;  % channel bandwidth
No_TTT_values=1;  % Max value of TTT
Signaling_overhead = 0.25;  % amount of signaling overhead (25%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NoHO=zeros(No_TTT_values,1);  % predefine parameter for HO count (for each TTT value)
TTT_value=zeros(Number_MS,1); % predefine TTT value for each MS

Serving_BS_SNR_help=zeros(Number_MS,2); 
Serving_BS_help=zeros(Number_MS,2);

Serving_BS=zeros(NoOfSteps,Number_MS);  % predefine parameter showing to which BS are MS attached during the simulation 
Serving_BS_SNR=zeros(NoOfSteps,Number_MS);

PosBS = [250 250 30; 250 750 30; 750 250 30; 750 750 30];

%PosMSinit=MS_position(Area_x,Area_y,Number_MS); % using function for generation of initial coordinates of MSs
%PosMS=movement_PRWMM(Number_MS,NoOfSteps,Step,Speed_max,Area_x,Area_y,PosMSinit); % function for generation of movement

load('MSposition_NoMSnew_20_NoSimStep_1000_capacity.mat')

% calculation of noise
N_W = (BW*4*10.^-12)/10.^9; % noise [W]
N_dBm = 10*log10(N_W/0.001); % noise [dBm]
N_RE = 7*12*100*20*100*(1-Signaling_overhead);  % total amount of REs/s available for data transmission (i.e., exluding overhead)

Capacity_per_MS_equalBW=zeros(NoOfSteps, Number_MS);    % predefine capacity of each MS in each sim step (equal capacity)
Capacity_per_MS_fairBW=zeros(NoOfSteps, Number_MS);    % predefine capacity of each MS in each sim step (fair capacity)
Capacity_per_MS_equalBW_LTE=zeros(NoOfSteps, Number_MS);    % predefine capacity of each MS in each sim step (equal capacity)
Capacity_per_MS_fairBW_LTE=zeros(NoOfSteps, Number_MS);    % predefine capacity of each MS in each sim step (fair capacity)
Capacity_all=zeros(NoOfSteps,4);    % predefined value for overall capacity (1st column = sum capacity for equal BW, 2nd column = equal capacity for fair BW)

NoMSconnected=zeros(NoOfSteps,Number_BS);  % Number of MS connected to each BS in each sim step

for DeltaT=1:No_TTT_values % for each step, we increase TTT by one
    
    Capacity_per_BS_equalBW=zeros(NoOfSteps, Number_BS);    % capacity of each MS in each sim step (equal capacity)
    Capacity_per_BS_fairBW=zeros(NoOfSteps, Number_BS);    % capacity of each MS in each sim step (fair capacity)
    Capacity_per_BS_equalBW_LTE=zeros(NoOfSteps, Number_BS);    % capacity of each MS in each sim step (equal capacity)
    Capacity_per_BS_fairBW_LTE=zeros(NoOfSteps, Number_BS);    % capacity of each MS in each sim step (fair capacity)
    
    for SimStep=1:NoOfSteps
        d = distance(Number_MS,Number_BS,PosMS,PosBS,SimStep);
        PL = pathloss(Number_MS,Number_BS,d,f);
        RSS = RSS_function(Number_MS,Number_BS,Pt,PL);
        SNR = SNR_function(Number_MS,Number_BS,PL,Pt,N_dBm);
        BS_assoc = BS_association(Number_MS,SNR);
        
        for j=1:Number_MS
            Serving_BS(SimStep,j)=BS_assoc(j,2);
            Serving_BS_SNR(SimStep,j)=BS_assoc(j,1);
            NoMSconnected(SimStep,BS_assoc(j,2))=NoMSconnected(SimStep,BS_assoc(j,2))+1;   % calculation how many MSs are connected to each BS
        end
        
        if SimStep>1
            for j=1:Number_MS
                if  Serving_BS(SimStep,j)~=Serving_BS(SimStep-1,j) && Serving_BS_help(j,1)==0   % checking if BS would be change for DeltaT=0
                    Serving_BS_help(j,1)=Serving_BS(SimStep-1,j);  % index of serving station 
                    Serving_BS_help(j,2)=Serving_BS(SimStep,j);    % index of target station
                    BS_assoc(j,1)=Serving_BS_help(j,1);
                end
                
                if TTT_value(j,1)<(DeltaT) && Serving_BS_help(j,1)~=0  % as long as current TTT value is lower than allowed TTT value we go through if
                    Serving_BS_SNR_help(j,1)=SNR(j,Serving_BS_help(j,1));   % SNR between MS and serving station
                    Serving_BS_SNR_help(j,2)=SNR(j,Serving_BS_help(j,2));   % SNR between MS and target station
                    if Serving_BS_SNR_help(j,1)<Serving_BS_SNR_help(j,2)   % if SNR of serving station is lower than SINR of target station increase TTT by 1
                        TTT_value(j,1)=TTT_value(j,1)+1;
                        Serving_BS_SNR(SimStep,j)=Serving_BS_SNR_help(j,1);
                    else
                        TTT_value(j,1)=0;    % otherwise, reset TTT
                        Serving_BS_help(j,1)=0;
                        Serving_BS_SNR(SimStep,j)=Serving_BS_SNR_help(j,2);
                    end
                end
                if TTT_value(j,1)==DeltaT && Serving_BS_help(j,1)~=0  % if TTT=TTT_max, reset TTT, increase number of handovers
                    TTT_value(j,1)=0;
                    NoHO(DeltaT,1)=NoHO(DeltaT,1)+1;
                    Serving_BS_help(j,1)=0;                    
                end
            end
        end
        
        SINR = SINR_function(Number_MS,Number_BS,RSS, PL, N_W,BS_assoc,Pt);
        Efficiency = Efficiency_comp(SINR,Number_MS); % calculation of efficiency (bits/RE)
        
       % CALCULATION OF CAPACITY FOR EQUAL BW
               
       for j=1:Number_BS
           Capacity_per_BS_equalBW(SimStep,j)=BW*10^(-6)/NoMSconnected(SimStep,j);
           Capacity_per_BS_equalBW_LTE(SimStep,j)=N_RE*10^(-6)/NoMSconnected(SimStep,j);
       end
       for j=1:Number_MS
           Capacity_per_MS_equalBW(SimStep,j)=Capacity_per_BS_equalBW(SimStep,Serving_BS(SimStep,j))*log2(1+10.^(SINR(j)./10));
           Capacity_per_MS_equalBW_LTE(SimStep,j)=Capacity_per_BS_equalBW_LTE(SimStep,Serving_BS(SimStep,j))*Efficiency(j);
       end    

        Capacity_all(SimStep,1)=sum(Capacity_per_MS_equalBW(SimStep,:));
        Capacity_all(SimStep,3)=sum(Capacity_per_MS_equalBW_LTE(SimStep,:));
        
        % CALCULATION OF CAPACITY FOR FAIR BW       
         for j=1:Number_BS
             SINR_Fair=0;
             Efficency_Fair=0;
             for i=1:Number_MS
                 if(Serving_BS(SimStep,i)==j)
                    SINR_Fair=SINR_Fair+(1/(log2(1+10.^(SINR(i)./10))));
                    Efficency_Fair=Efficency_Fair+1/Efficiency(i);
                 end
             end
           Capacity_per_BS_fairBW(SimStep,j)=BW*10^(-6)/SINR_Fair;                
           Capacity_per_BS_fairBW_LTE(SimStep,j)=N_RE*10^(-6)/Efficency_Fair;
         end
         for j=1:Number_MS
           Capacity_per_MS_fairBW(SimStep,j)=Capacity_per_BS_fairBW(SimStep,Serving_BS(SimStep,j));
           Capacity_per_MS_fairBW_LTE(SimStep,j)=Capacity_per_BS_fairBW_LTE(SimStep,Serving_BS(SimStep,j));
         end
         
         Capacity_all(SimStep,2)=sum(Capacity_per_MS_fairBW(SimStep,:));
         Capacity_all(SimStep,4)=sum(Capacity_per_MS_fairBW_LTE(SimStep,:));
    end
end

figure (1)
hold on
grid on

set(gca, 'fontweight', 'normal', ...
    'fontsize', 16)
xlabel('Simulation time [-]')
ylabel('Capacity [Mbps]')
a1=plot(1:NoOfSteps,Capacity_all(1:NoOfSteps,1),'r-','MarkerSize',5,'LineWidth',1.5);
b1=plot(1:NoOfSteps,Capacity_all(1:NoOfSteps,2),'b-.','MarkerSize',5,'LineWidth',1.5);
c1=plot(1:NoOfSteps,Capacity_all(1:NoOfSteps,3),'g-','MarkerSize',5,'LineWidth',1.5);
d1=plot(1:NoOfSteps,Capacity_all(1:NoOfSteps,4),'m-.','MarkerSize',5,'LineWidth',1.5);
legend([a1,b1,c1,d1],'Equal BW (Shannon)','Fair BW (Shannon)','Equal BW (LTE)','Fair BW (LTE)');
title('Overal system capacity')
print('-f1', '-r300', '-dpng','Capacity');



