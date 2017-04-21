function [ LEqns_list ] = getLineEqns( lines )
%得到线Lp_1i的直线方程和中点
%{
lines           ==>Lp_li的点列表 
ptsInI2_idx     ==>各条Lp_li的点在ptsInI2中的起始位置

输出：
LEqns_list      ==>Lp_1i线段的直线方程, [Nlines,3]
%}

Nlines=size(lines,2);

LEqns_list=zeros([Nlines,3]);  %Lp_1i的直线方程

for i=1:Nlines
    p1=[lines(1,i),lines(3,i),1];
    p2=[lines(2,i),lines(4,i),1];
    L=cross(p1,p2);
    L=L/norm([L(1),L(2)]);
    LEqns_list(i,:)=L;
end %end of for i=1:Nlines

end

