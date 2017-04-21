function  disp_lineMatchesOneImage( img1,I1_lines,matchedLines,ML_cnt, step, showLabel)
%DISP_LINEMATCHES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

H=size(img1,1);
W=size(img1,2);

figure;
imshow(img1);
hold on;

%�ںϳ�ͼ������ʾI1���ߣ�������I2��ƥ�����
for i = 1:step:ML_cnt
    %imshow(blend_img);
    %hold on;
    L1=I1_lines(:,matchedLines(i,1));
    %��ʾL1
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [1, 0, 0]);
    
    %��ʾ�ߵģ���ţ�����ֵ
    if showLabel
        str1=num2str(i);      %num2str(matchedLines(i,1));
        cp1=[sum(L1(1:2))/2, sum(L1(3:4))/2];
        text(cp1(1),cp1(2),str1,'Color',[1,1,0],'FontSize',12); 
    end 
end


%{
N=size(lines1,1);
for i=1:50:N
    plot([lines1(i,1),lines2(i,1)],[lines1(i,2),H+lines2(i,2)], 'LineWidth', 1, 'Color', [1, 0, 0]);
end
%}

end

