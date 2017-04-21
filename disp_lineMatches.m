function  disp_lineMatches( img1,img2, I1_lines,I2_lines,matchedLines,ML_cnt, step, showLabel,showMatchLines)
%DISP_LINEMATCHES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

H=size(img1,1);
W=size(img1,2);


if size(size(img1),2) >2
    blend_img=uint8(zeros([H,2*W,3]));
    blend_img(:,1:W,:)=img1;
    blend_img(:,W+1:2*W,:)=img2;
else
    blend_img=uint8(zeros([H,2*W]));
    blend_img(:,1:W)=img1;
    blend_img(:,W+1:2*W)=img2;
end


fig=figure;
imshow(blend_img);
hold on;

%�ںϳ�ͼ������ʾI1���ߣ�������I2��ƥ�����
for i = 1:step:ML_cnt
    %imshow(blend_img);
    %hold on;
    L1=I1_lines(:,matchedLines(i,2));
    L2=I2_lines(:,matchedLines(i,1));
    
    if L1(1)==0 || L2(1)==0
        continue;
    end
    
    %��ʾL1��L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0,1, 0]);
    
    %��ʱʹ��
    %if L2(3)<=0; L2(3)=1; end
    %if L2(4)<=0; L2(4)=1; end
    plot(L2(1:2)+W, L2(3:4), 'LineWidth', 1, 'Color', [0, 1, 0]);
    

    
    %��ʾƥ��Ķ�Ӧ��ϵ
    if showMatchLines
        plot([cp1(1),cp2(1)],[cp1(2)+W,cp2(2)], 'b-.');
    end
    
end

     %��ʾ�ߵģ���ţ�����ֵ
if showLabel
    for i=1:step:ML_cnt
        L1=I1_lines(:,matchedLines(i,2));
        L2=I2_lines(:,matchedLines(i,1));


            str1=num2str(i);      %num2str(matchedLines(i,1));
            str2=num2str(i);      %num2str(matchedLines(i,2));
            cp1=[sum(L1(1:2))/2, sum(L1(3:4))/2];
            cp2=[sum(L2(1:2))/2, sum(L2(3:4))/2];
            text(cp1(1),cp1(2),str1,'Color',[1,0,0],'FontSize',9);
            text(cp2(1)+W,cp2(2),str2,'Color',[1,0,0],'FontSize',9);   

    end
end

saveas(fig,'e:/out.tif');

%{
N=size(lines1,1);
for i=1:50:N
    plot([lines1(i,1),lines2(i,1)],[lines1(i,2),H+lines2(i,2)], 'LineWidth', 1, 'Color', [1, 0, 0]);
end
%}

end

