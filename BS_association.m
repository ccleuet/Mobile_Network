function BS_assoc = BS_association(Number_MS,SNR)

%   Number_MS ... Number of MS in the simulation
%   SNR ... SNR between individual stations (MS-BS)

BS_assoc=zeros(Number_MS,2);


for i=1:Number_MS
    [BS_assoc(i,1),BS_assoc(i,2)]=max(SNR(i,:));
end


end