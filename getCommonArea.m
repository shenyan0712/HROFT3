function [AreaI1t,AreaI2] = getCommonArea( H,W,Trans, H1p,W1p)
%GET 此处显示有关此函数的摘要
%{
H,W         ==>参考图像I的高度和宽度
Trans       ==>It坐标系到原始图像I坐标系的位移
H1p,W1p     ==>It的高度和宽度
%}

%得到It的原点(1,1)在I2坐标系下的位置
Xlt=1+Trans(1); Ylt=1+Trans(2);
%得到It的右下点(W,H)在I2坐标系下的位置
Xrb=W1p+Trans(1); Yrb=H1p+Trans(2);

%取It和参考图像I的公共部分（在参考图像I的坐标系下）, 也即取左边X的最大，右边X的最小，上边Y的最大，下边Y的最小
%左界处理
sx=Xlt;
if sx<1
    sx=1;
end
%右界处理
ex=Xrb;
if ex >W;
   ex=W;
end
%上界处理
sy=Ylt;
if sy<1
    sy=1;
end
%下界处理
ey=Yrb;
if ey >H;
    ey=H;
end

AreaI2=[sy,ey,sx,ex];
%对于I1t,还需要将坐标范围换到I1t的坐标系下
sy=sy-Trans(2);     ey=ey-Trans(2);
sx=sx-Trans(1);     ex=ex-Trans(1);
AreaI1t=[sy,ey,sx,ex];
end

