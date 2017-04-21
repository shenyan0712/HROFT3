function disp_linesForOneImage( img, lines,step, showLabels )
%DISP_LINESFORONEIMG 此处显示有关此函数的摘要
%   此处显示详细说明

out_img=img;

imshow(out_img);
hold on;

Nlines=size(lines,2);



%在合成图像上显示I1的线，及其在I2中匹配的线
for i = 1:step:Nlines
    L1=lines(:,i);
    %显示L1和L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0, 1, 1]);   
    %显示线的（编号）索引值
    if showLabels
        str1=num2str(i);
        cp1=[sum(L1(1:2))/2, sum(L1(3:4))/2];
        text(cp1(1),cp1(2),str1,'Color',[1,0,0],'FontSize',12);
    end
end


end

