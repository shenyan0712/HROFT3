function lines_out = transformLines( T, trans_p, lines,H,W )
%将线进行变换，然后将线在[1,H]x[1,W]范围内进行裁剪
%   此处显示详细说明

Nlines=size(lines,2);
lines_out=zeros([4,Nlines]);

n=0;

for i=1:Nlines
   p1=[lines(1,i) ,lines(3,i)];
   p2=[lines(2,i), lines(4,i)];
  
   tp1=T.transformPointsForward(p1);
   tp2=T.transformPointsForward(p2);   
   
   tp1=round(tp1-trans_p);
   tp2=round(tp2-trans_p);
   
   L=[tp1(1),tp2(1),tp1(2),tp2(2)]';
   
   %对线进行检查并裁剪
   %是否超出上界
   if tp1(2)<1 || tp2(2)<1
       if tp1(2)<1 && tp2(2)<1 %说明线完全在范围外
           continue;
       end
       cp=round(calcCrossPoint(L, [1,W,1,1]));
       if tp1(2)<1; 
           tp1=cp(1:2);
       else
           tp2=cp(1:2);
       end
   end;
   %是否超出下界
   if tp1(2)>H || tp2(2)>H
       if tp1(2)>H && tp2(2)>H
           continue;
       end
       cp=round(calcCrossPoint(L, [1,W,H,H]));
       if tp1(2)>H
           tp1=cp(1:2);
       else
           tp2=cp(1:2);
       end
   end
   %是否超出左界
   if tp1(1)<1 || tp2(1)<1
       if tp1(1)<1 && tp2(1)<1
           continue;
       end
       cp=round(calcCrossPoint(L, [1,1,1,H]));
       if tp1(1)<1
           tp1=cp(1:2);
       else
           tp2=cp(1:2);
       end
   end;
   %是否超出右界
   if tp1(1)>W || tp2(1)>W
       if tp1(1)>W && tp2(1)>W
           continue;
       end
       tp1(1)=W; 
       cp=round(calcCrossPoint(L, [W,W,1,H])); 
       if tp1(1)>W
           tp1=cp(1:2);
       else
           tp2=cp(1:2);
       end
   end
   %添加正确的线
   n=n+1;
   lines_out(:,i)=[tp1(1),tp2(1),tp1(2),tp2(2)]';
end
   lines_out=lines_out(:,1:n);
end

