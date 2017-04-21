function disp_lines( img1,img2, I1_lines,I2_lines,step )
%DISP_LINES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

[H,W]=size(img1);
blend_img=uint8(zeros([2*H,W]));

blend_img(1:H,:)=img1;
blend_img(H+1:2*H,:)=img2;

imshow(blend_img);
hold on;

Nlines1=size(I1_lines,2);
Nlines2=size(I2_lines,2);


%�ںϳ�ͼ������ʾI1���ߣ�������I2��ƥ�����
for i = 1:step:Nlines1
    L1=I1_lines(:,i);
    %��ʾL1��L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0, 1, 1]);   
    %��ʾ�ߵģ���ţ�����ֵ
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

