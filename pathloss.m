function PL = pathloss(Number_MS,Number_BS,d,f)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   d ... distance between individual stations in meters
%   f ... frequency in GHz

PL=zeros(Number_MS,Number_BS);


for i=1:Number_MS
    for j=1:Number_BS
       PL(i,j) = 35.2+35*log10(d(i,j))+26*log10(f/2);
    end
end


end