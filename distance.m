function d = distance(Number_MS,Number_BS,PosMS,PosBS,SimStep)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   PosMS ... Position of MS (MS1 x | MS1 y | MS2 x | MS2 y | ....)
%   PosBS ... Position of BS (MS1 x | MS1 y | MS2 x | MS2 y | ....)
%   SimStep ... Simulation step

d=zeros(Number_MS,Number_BS);


for i=1:Number_MS
    for j=1:Number_BS
        d(i,j)=sqrt((abs(PosBS(j,1)-PosMS(SimStep,2*i-1)))^2 + (abs(PosBS(j,2)-PosMS(SimStep,2*i)))^2);
    end
end


end