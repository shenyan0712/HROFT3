I=imread('../images/4A.bmp');

if size(size(I),2) >2
    I=rgb2gray(I);
end

[H,W]=size(I);

X1=int16(W/2); Y1=1;
X2=W; Y2=int16(H/2);
X3=X1; Y3=H;
X4=1; Y4=Y2;

L1=[X2,X1,Y2,Y1];
L2=[X4,X3,Y4,Y3];
L3=[X1,X4,Y1,Y4];
L4=[X3,X2,Y3,Y2];

It=RectHalfPadding(I,[X1,X2,Y1,Y2],L1);
imshow(It);