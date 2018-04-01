function [PosMSinit] = MS_position(Area_x,Area_y,Number_MS)

% POZICE MS = vygenerovani nahodne pozice pro uzivatele
%   Area_x ... size of simulation area in x coordinate
%   Area_y ... size of simulation area in y coordinate
%   Number_MS ... number of MS in simulation
%   PosMSinit ... MS1 x | MS1 y | MS2 x | MS2 y | ....


PosMSinit=size(Number_MS);

for i = 1:Number_MS
    
    PosMSinit(1,2*i-1) = rand*Area_x;
    PosMSinit(1,2*i) = rand*Area_y;
    
end


