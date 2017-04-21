function disp_lines( img1,img2, I1_lines,I2_lines,step )
%DISP_LINES 此处显示有关此函数的摘要
%   此处显示详细说明

[H,W]=size(img1);
blend_img=uint8(zeros([2*H,W]));

blend_img(1:H,:)=img1;
blend_img(H+1:2*H,:)=img2;

imshow(blend_img);
hold on;

Nlines1=size(I1_lines,2);
Nlines2=size(I2_lines,2);


%在合成图像上显示I1的线，及其在I2中匹配的线
for i = 1:step:Nlines1
    L1=I1_lines(:,i);
    %显示L1和L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0, 1, 1]);   
    %显示线的（编号）索引值
    str1=num2str(i);
    cp1=[sum(L1(1:2))/2, sum(L1(3:4))/2];
    text(cp1(1),cp1(2),str1,'Color',[1,0,0],'FontSize',12);
end

for i=1:step:Nlines2
    L2=I2_lines(:,i);
    plot(L2(1:2), L2(3:4)+H, 'LineWidth', 1, 'Color', [0, 1, 1]);
    str2=num2str(i);
    cp2=[sum(L2(1:2))/2, sum(L2(3:4))/2];
    text(cp2(1),cp2(2)+H,str2,'Color',[1,0,0],'FontSize',12);  
end


end

