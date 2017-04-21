function  disp_ptsMatches( img1,img2, matchedPoints1,matchedPoints2)
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

end

