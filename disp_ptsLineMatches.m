function  disp_ptsLineMatches( img1,img2, matchedPoints1,matchedPoints2, I1_lines, I2_lines, Mr,Nr,region_size)
%DISP_LINEMATCHES 此处显示有关此函数的摘要
%   此处显示详细说明



[H,W]=size(img1);
blend_img=uint8(zeros([2*H,W]));

blend_img(1:H,:)=img1;
blend_img(H+1:2*H,:)=img2;

imshow(blend_img);
hold on;

%显示点的匹配关系
Npts=size(matchedPoints1,1);
for i=1:Npts
    plot([matchedPoints1(i,1),matchedPoints2(i,1)],[matchedPoints1(i,2),H+matchedPoints2(i,2)], 'LineWidth', 1, 'Color', [0, 1, 0]);
end

%显示线段
Nlines1=size(I1_lines,2);
for i=1:Nlines1
    plot(I1_lines(1:2,i), I1_lines(3:4, i), 'LineWidth', 1, 'Color', [0, 1, 1]);
    str=num2str(i);
    cp=[sum(I1_lines(1:2,i))/2, sum(I1_lines(3:4, i))/2];
    text(cp(1),cp(2),str,'Color',[1,0,0],'FontSize',12);
end

Nlines2=size(I2_lines,2);
for i=1:Nlines2
    plot(I2_lines(1:2,i), I2_lines(3:4, i)+H, 'LineWidth', 1, 'Color', [0, 1, 1]);
    str=num2str(i);
    cp=[sum(I2_lines(1:2,i))/2, sum(I2_lines(3:4, i))/2];
    text(cp(1),cp(2)+H,str,'Color',[1,0,0],'FontSize',12);
end

%显示区域分割线
for i=1:(Mr-2)
   plot([0,W],[i*region_size,i*region_size], 'Color', [0, 0, 0]);
end
for i=1:(Nr-2)
   plot([i*region_size, i*region_size],[0,2*H], 'Color', [0, 0, 0]);
end


end

