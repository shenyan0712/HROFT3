function disp_linesForOneImage( img, lines,step, showLabels )
%DISP_LINESFORONEIMG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

out_img=img;

imshow(out_img);
hold on;

Nlines=size(lines,2);



%�ںϳ�ͼ������ʾI1���ߣ�������I2��ƥ�����
for i = 1:step:Nlines
    L1=lines(:,i);
    %��ʾL1��L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0, 1, 1]);   
    %��ʾ�ߵģ���ţ�����ֵ
    if showLabels
        str1=num2str(i);
        cp1=[sum(L1(1:2))/2, sum(L1(3:4))/2];
        text(cp1(1),cp1(2),str1,'Color',[1,0,0],'FontSize',12);
    end
end


end

