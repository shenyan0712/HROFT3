function [ LEqns_list ] = getLineEqns( lines )
%�õ���Lp_1i��ֱ�߷��̺��е�
%{
lines           ==>Lp_li�ĵ��б� 
ptsInI2_idx     ==>����Lp_li�ĵ���ptsInI2�е���ʼλ��

�����
LEqns_list      ==>Lp_1i�߶ε�ֱ�߷���, [Nlines,3]
%}

Nlines=size(lines,2);

LEqns_list=zeros([Nlines,3]);  %Lp_1i��ֱ�߷���

for i=1:Nlines
    p1=[lines(1,i),lines(3,i),1];
    p2=[lines(2,i),lines(4,i),1];
    L=cross(p1,p2);
    L=L/norm([L(1),L(2)]);
    LEqns_list(i,:)=L;
end %end of for i=1:Nlines

end

