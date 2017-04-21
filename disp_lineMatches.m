function  disp_lineMatches( img1,img2, I1_lines,I2_lines,matchedLines,ML_cnt, step, showLabel,showMatchLines)
%DISP_LINEMATCHES 此处显示有关此函数的摘要
%   此处显示详细说明

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

%在合成图像上显示I1的线，及其在I2中匹配的线
for i = 1:step:ML_cnt
    %imshow(blend_img);
    %hold on;
    L1=I1_lines(:,matchedLines(i,2));
    L2=I2_lines(:,matchedLines(i,1));
    
    if L1(1)==0 || L2(1)==0
        continue;
    end
    
    %显示L1和L2
    plot(L1(1:2), L1(3:4), 'LineWidth', 1, 'Color', [0,1, 0]);
    
    %临时使用
    %if L2(3)<=0; L2(3)=1; end
    %if L2(4)<=0; L2(4)=1; end
    plot(L2(1:2)+W, L2(3:4), 'LineWidth', 1, 'Color', [0, 1, 0]);
    

    
    %显示匹配的对应关系
    if showMatchLines
        plot([cp1(1),cp2(1)],[cp1(2)+W,cp2(2)], 'b-.');
    end
    
end

     %显示线的（编号）索引值
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

