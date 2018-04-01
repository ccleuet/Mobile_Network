function SNR = SNR_function(Number_MS,Number_BS,PL,Pt, N_dBm)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   PL ... PL between individual stations in meters
%   Pt ... Transmission power of BS in dBm

SNR=zeros(Number_MS,Number_BS);


for i=1:Number_MS
    for j=1:Number_BS
       SNR(i,j) = Pt-PL(i,j)-N_dBm;
    end
end


end