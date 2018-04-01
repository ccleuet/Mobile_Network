function SINR = SINR_function(Number_MS,Number_BS,RSS, PL, N_W,BS_assoc,Pt)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   RSS ... received signal strength
%   PL ... path loss in dB
%   N_W ... Noise in W
%   BS_assoc ... indication to wich BS MS is connected
%   Pt ... Transmission power of BS in dBm

SINR=zeros(Number_MS,1);
NI=zeros(Number_MS,1);

for i=1:Number_MS
    for j=1:Number_BS
        if BS_assoc(i,2)~=j
            NI(i,1) = NI(i,1) + 10.^-3*10.^( RSS(i,j)/10);   % sum of interference
        end
    end
    NI(i,1) = NI(i,1) + N_W;     % adding Noise
    NI(i,1)=10*log10(NI(i,1)/0.001); % converting to dBm
    SINR(i,1)=Pt-PL(i,BS_assoc(i,2))-NI(i,1);  % SINR calculation
end

end