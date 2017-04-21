function cp = calcCrossPoint(line1,line2 )
%计算两条直线的交点
%{
输入:
line1,   ==>[x1_1,x1_2,y1_1,y1_2]
line2,   ==>[x2_1,x2_2,y2_1,y2_2]
%}

line1_eq=cross([line1(1),line1(3),1],[line1(2),line1(4),1]);
line1_eq=line1_eq/norm([line1_eq(1),line1_eq(2)]);  %使法向量单位化
%line1_eq=line1_eq*(line1_eq(1)/abs(line1_eq(1)));   %使法向量(a,b)的a为正

line2_eq=cross([line2(1),line2(3),1],[line2(2),line2(4),1]);
line2_eq=line2_eq/norm([line2_eq(1),line2_eq(2)]);  %使法向量单位化
%line2_eq=line2_eq*(line2_eq(1)/abs(line2_eq(1)));   %使法向量(a,b)的a为正

cp=cross(line1_eq,line2_eq);
cp=round(cp/cp(3));

end

