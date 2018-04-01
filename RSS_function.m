function RSS = RSS_function(Number_MS,Number_BS,Pt,PL)

%   Number_MS ... Number of MS in the simulation
%   Number_BS ... Number of BS in the simulation
%   Pt ... Transmission power of BSs
%   PL ... pathlos between individual stations in dB

RSS=zeros(Number_MS,Number_BS);


for i=1:Number_MS
    for j=1:Number_BS
       RSS(i,j) = Pt-PL(i,j);
    end
end


end