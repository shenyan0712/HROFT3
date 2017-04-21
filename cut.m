function L_out = cut( L, H,W)
%CUT 此处显示有关此函数的摘要
%   此处显示详细说明

   tp1=[L(1) ,L(3)];
   tp2=[L(2), L(4)];

   %对线进行检查并裁剪
   %是否超出上界
   if tp1(2)<1 || tp2(2)<1
       if tp1(2)<1 && tp2(2)<1 %说明线完全在范围外
           L_out=[0,0,0,0];
           return
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
           L_out=[0,0,0,0];
           return
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
           L_out=[0,0,0,0];
           return
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
           L_out=[0,0,0,0];
           return
       end
       tp1(1)=W; 
       cp=round(calcCrossPoint(L, [W,W,1,H])); 
       if tp1(1)>W
           tp1=cp(1:2);
       else
           tp2=cp(1:2);
       end
   end
   
   L_out=[tp1(1),tp2(1),tp1(2),tp2(2)]';

end

