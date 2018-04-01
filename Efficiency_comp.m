function Efficiency = Efficiency_comp(SINR,Number_MS)

Efficiency=zeros(Number_MS,1);

for i=1:Number_MS
    if SINR(i,1)>=-9.478 && SINR(i,1)<-6.658
        Efficiency(i,1)=2*78/1024;
    elseif SINR(i,1)>=-6.658 && SINR(i,1)<-4.098
        Efficiency(i,1)=2*120/1024;
    elseif SINR(i,1)>=-4.098 && SINR(i,1)<-1.798
        Efficiency(i,1)=2*193/1024;
    elseif SINR(i,1)>=-1.798 && SINR(i,1)<0.399
        Efficiency(i,1)=2*308/1024;
    elseif SINR(i,1)>=0.399 && SINR(i,1)<2.424
        Efficiency(i,1)=2*449/1024;
    elseif SINR(i,1)>=2.424 && SINR(i,1)<4.489
        Efficiency(i,1)=2*602/1024;
    elseif SINR(i,1)>=4.489 && SINR(i,1)<6.367
        Efficiency(i,1)=4*378/1024;
    elseif SINR(i,1)>=6.367 && SINR(i,1)<8.456
        Efficiency(i,1)=4*490/1024;
    elseif SINR(i,1)>=8.456 && SINR(i,1)<10.266
        Efficiency(i,1)=4*616/1024;
    elseif SINR(i,1)>=10.266 && SINR(i,1)<12.218
        Efficiency(i,1)=6*466/1024;
    elseif SINR(i,1)>=12.218 && SINR(i,1)<14.122
        Efficiency(i,1)=6*567/1024;
    elseif SINR(i,1)>=14.122 && SINR(i,1)<15.849
        Efficiency(i,1)=6*666/1024;
    elseif SINR(i,1)>=15.849 && SINR(i,1)<17.786
        Efficiency(i,1)=6*772/1024;
    elseif SINR(i,1)>=17.786 && SINR(i,1)<19.809
        Efficiency(i,1)=6*873/1024;
    elseif SINR(i,1)>=19.809
        Efficiency(i,1)=6*948/1024;
    else
        Efficiency(i,1)=0;
    end;
end
