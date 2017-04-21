function It = paddingImage( T, It,H,W, Trans )
%DETERMINPADDINGSIDE �˴���ʾ�йش˺�����ժҪ
%{
It      ==>ԭʼͼ��I����T�任��õ���ͼ��
H,W     ==>ԭʼͼ��I�ĸߺͿ�
Trans   ==>It����ϵ��ԭʼͼ��I����ϵ��λ��
%}
[Ht,Wt]=size(It);

%ԭʼͼ��I���Ͻǵ�任���λ�ã�������ԭʼͼ��I������ϵ�£�
[X1,Y1]=T.transformPointsForward(1,1);  %P1
%���Ͻǵ�
[X2,Y2]=T.transformPointsForward(W,1);  %P2
%���½���
[X3,Y3]=T.transformPointsForward(W,H);  %P3
%���½���
[X4,Y4]=T.transformPointsForward(1,H);  %P4

%��P1,P2,P3,P4��䵽ͼ��It������ϵ��
t=-Trans;
X1=int16(round(X1)+t(1)); Y1=int16(round(Y1)+t(2));  if X1<=0; X1=1; end;  if Y1<=0; Y1=1; end;
X2=int16(round(X2)+t(1)); Y2=int16(round(Y2)+t(2));  if X2<=0; X2=1; end;  if Y2<=0; Y2=1; end;
X3=int16(round(X3)+t(1)); Y3=int16(round(Y3)+t(2));  if X3<=0; X3=1; end;  if Y3<=0; Y3=1; end;
X4=int16(round(X4)+t(1)); Y4=int16(round(Y4)+t(2));  if X4<=0; X4=1; end;  if Y4<=0; Y4=1; end;

if X1>Wt; X1=Wt; end;  if Y1>Ht; Y1=Ht; end;
if X2>Wt; X2=Wt; end;  if Y2>Ht; Y2=Ht; end;
if X3>Wt; X3=Wt; end;  if Y3>Ht; Y3=Ht; end;
if X4>Wt; X4=Wt; end;  if Y4>Ht; Y4=Ht; end;

%��ʾ�任���ͼ���Լ��߽�
%{
figure;
imshow(It)
hold on;
line([X2,X1],[Y2,Y1], 'color',[1,0,0]); %L1 top line
line([X4,X3],[Y4,Y3], 'color',[1,0,0]); %L2 botton line
line([X1,X4],[Y1,Y4], 'color',[1,0,0]); %L3 left line
line([X3,X2],[Y3,Y2], 'color',[1,0,0]); %L4 right line
%}

L1=[X2,X1,Y2,Y1];
L2=[X4,X3,Y4,Y3];
L3=[X1,X4,Y1,Y4];
L4=[X3,X2,Y3,Y2];

%%%%%���ϱ߽���д���
%cp1=calcCrossPoint(L1,[0,Wt-1,0,1]);        %����L1��y=1�Ľ���
if Y1<Y2  %L1��Ӧ���Ͻ�
    %cp2=calcCrossPoint(L1,[Wt,Wt,1,Ht]);    %����L1��x=Wt�Ľ���
    It=RectHalfPadding(It,[X1,X2,Y1,Y2],L1);
elseif Y1>Y2 %L1��Ӧ���Ͻ�
    %cp2=calcCrossPoint(L1,[1,1,1,Ht]);    %����L1��x=1�Ľ���
    It=RectHalfPadding(It,[X1,X2,Y2,Y1], L1);
end

%%%%%���±߽���д���
%cp1=calcCrossPoint(L2,[1,Wt,Ht,Ht]);        %����L2��y=H�Ľ���
if Y3<Y4  %L2��Ӧ���½�
    %cp2=calcCrossPoint(L2,[Wt,Wt,1,Ht]);    %����L2��x=Wt�Ľ���
    It=RectHalfPadding(It,[X4,X3,Y3,Y4],L2);
elseif Y3>Y4 %L2��Ӧ���½�
    %cp2=calcCrossPoint(L2,[1,1,1,Ht]);    %����L1��x=1�Ľ���
    It=RectHalfPadding(It,[X4,X3,Y4,Y3], L2);
end

%%%%%����߽���д���
%cp1=calcCrossPoint(L3,[1,1,1,Ht]);        %����L3��x=1�Ľ���
if X1>X4  %L3��Ӧ���Ͻ�
    %cp2=calcCrossPoint(L3,[1,Wt,1,1]);    %����L3��y=1�Ľ���
    It=RectHalfPadding(It,[X4,X1,Y1,Y4],L3);
elseif X1<X4 %L3��Ӧ���½�
    %cp2=calcCrossPoint(L3,[1,Wt,Ht,Ht]);    %����L1��y=H�Ľ���
    It=RectHalfPadding(It,[X1,X4,Y1,Y4], L3);
end

%%%%%���ұ߽���д���
%cp1=calcCrossPoint(L4,[Wt,Wt,1,Ht]);        %����L4��x=Wt�Ľ���
if X2>X3  %L4��Ӧ���½�
    %cp2=calcCrossPoint(L4,[1,Wt,Ht,Ht]);    %����L4��y=Ht�Ľ���
    It=RectHalfPadding(It,[X3,X2,Y2,Y3],L4);
elseif X2<X3 %L4��Ӧ���Ͻ�
    %cp2=calcCrossPoint(L4,[1,Wt,1,1]);    %����L1��y=1�Ľ���
    It=RectHalfPadding(It,[X2,X3,Y2,Y3], L4);
end

%figure;
%imshow(It);

end



