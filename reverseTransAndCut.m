function [ I1_lines, I2_lines] = reverseTransAndCut( I1p_lines,I2p_lines, T, Trans, Trans_p, H,W )
%REVERSETRANS 此处显示有关此函数的摘要
%{
I1p_lines   ==>I1p检测到的线段
I2p_lines   ==>I2p检测到的线段
T           ==>变换
Trans       ==>存
%}

%先将I1p_lines和I2p_lines变换到I2坐标系下
I2_lines(1:2,:)=I2p_lines(1:2,:)-Trans_p(1);
I2_lines(3:4,:)=I2p_lines(3:4,:)-Trans_p(2);

I1_lines(1:2,:)=I1p_lines(1:2,:)-Trans_p(1);
I1_lines(3:4,:)=I1p_lines(3:4,:)-Trans_p(2);

%将在I2坐标系下的I1_lines变换到I1_t的坐标系下
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

%将I1_t的坐标系下的I1_lines通过T^-1变换到
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

%检查匹配对是否超范围
Nlines=size(I1_lines,2);
for i=1:Nlines
   %检查I1中的线
    I1_lines(:,i)=cut(I1_lines(:,i),H,W);
end

Nlines=size(I2_lines,2);
for i=1:Nlines
   %检查I1中的线
    I2_lines(:,i)=cut(I2_lines(:,i),H,W);
end


end

