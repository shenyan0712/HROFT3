function [AreaI1t,AreaI2] = getCommonArea( H,W,Trans, H1p,W1p)
%GET �˴���ʾ�йش˺�����ժҪ
%{
H,W         ==>�ο�ͼ��I�ĸ߶ȺͿ��
Trans       ==>It����ϵ��ԭʼͼ��I����ϵ��λ��
H1p,W1p     ==>It�ĸ߶ȺͿ��
%}

%�õ�It��ԭ��(1,1)��I2����ϵ�µ�λ��
Xlt=1+Trans(1); Ylt=1+Trans(2);
%�õ�It�����µ�(W,H)��I2����ϵ�µ�λ��
Xrb=W1p+Trans(1); Yrb=H1p+Trans(2);

%ȡIt�Ͳο�ͼ��I�Ĺ������֣��ڲο�ͼ��I������ϵ�£�, Ҳ��ȡ���X������ұ�X����С���ϱ�Y������±�Y����С
%��紦��
sx=Xlt;
if sx<1
    sx=1;
end
%�ҽ紦��
ex=Xrb;
if ex >W;
   ex=W;
end
%�Ͻ紦��
sy=Ylt;
if sy<1
    sy=1;
end
%�½紦��
ey=Yrb;
if ey >H;
    ey=H;
end

AreaI2=[sy,ey,sx,ex];
%����I1t,����Ҫ�����귶Χ����I1t������ϵ��
sy=sy-Trans(2);     ey=ey-Trans(2);
sx=sx-Trans(1);     ex=ex-Trans(1);
AreaI1t=[sy,ey,sx,ex];
end

