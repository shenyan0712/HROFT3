function line_eq = calcLineEq( line )
%计算线的法方向

%{
line    ==>[x1,x2,y1,y2]
%}
x1=line(1); 
x2=line(2);
y1=line(3);
y2=line(4);

line_eq=cross([line(1),line(3),1],[line(2),line(4),1]);
line_eq=line_eq/norm([line_eq(1),line_eq(2)]);  %使法向量单位化

%k=(y2-y1)/(x2-x1);
%line_eq=[1,-k,-k*y1-x1];



end

