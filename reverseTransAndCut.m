function [ I1_lines, I2_lines] = reverseTransAndCut( I1p_lines,I2p_lines, T, Trans, Trans_p, H,W )
%REVERSETRANS �˴���ʾ�йش˺�����ժҪ
%{
I1p_lines   ==>I1p��⵽���߶�
I2p_lines   ==>I2p��⵽���߶�
T           ==>�任
Trans       ==>��
%}

%�Ƚ�I1p_lines��I2p_lines�任��I2����ϵ��
I2_lines(1:2,:)=I2p_lines(1:2,:)-Trans_p(1);
I2_lines(3:4,:)=I2p_lines(3:4,:)-Trans_p(2);

I1_lines(1:2,:)=I1p_lines(1:2,:)-Trans_p(1);
I1_lines(3:4,:)=I1p_lines(3:4,:)-Trans_p(2);

%����I2����ϵ�µ�I1_lines�任��I1_t������ϵ��
%I1_lines(1:2,:)=I1_lines(1:2,:)-t(1);
%I1_lines(3:4,:)=I1_lines(3:4,:)-t(2);

if Trans_p(1)<=0
   I1_lines(1:2,:)=I1p_lines(1:2,:)-1;
end

if Trans_p(2)<=0
   I1_lines(3:4,:)=I1p_lines(3:4,:)-1;
end

if Trans(1)>0
       I1_lines(1:2,:)=I1p_lines(1:2,:)+Trans(1);
       I2_lines(1:2,:)=I2p_lines(1:2,:)+Trans(1);
end
if Trans(2)>0
       I1_lines(3:4,:)=I1p_lines(3:4,:)+Trans(2);
       I2_lines(3:4,:)=I2p_lines(3:4,:)+Trans(2);
end

%��I1_t������ϵ�µ�I1_linesͨ��T^-1�任��
%%%{
Nlines=size(I1_lines,2);
for i=1:Nlines
   x1=I1_lines(1,i); y1=I1_lines(3,i);
   x2=I1_lines(2,i); y2=I1_lines(4,i);
   [x1,y1]=T.transformPointsInverse(x1,y1);
   [x2,y2]=T.transformPointsInverse(x2,y2);
   
   I1_lines(:,i)=[x1,x2,y1,y2]';
end
%%%}

%���ƥ����Ƿ񳬷�Χ
Nlines=size(I1_lines,2);
for i=1:Nlines
   %���I1�е���
    I1_lines(:,i)=cut(I1_lines(:,i),H,W);
end

Nlines=size(I2_lines,2);
for i=1:Nlines
   %���I1�е���
    I2_lines(:,i)=cut(I2_lines(:,i),H,W);
end


end

