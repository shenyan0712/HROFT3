function [pts1,pts2] = getSIFTmatches( imfile1,imfile2 )
%GETSIFT 此处显示有关此函数的摘要
%   此处显示详细说明

img1=imread(imfile1);
if size(size(img1),2) >2
    img1=rgb2gray(img1);
end
img2=imread(imfile2);
if size(size(img2),2) >2
    img2=rgb2gray(img2);
end
imwrite(img1,'e:/t1.tif');
imwrite(img2,'e:/t2.tif');

[im1, des1, loc1] = sift('e:/t1.tif');
[im2, des2, loc2] = sift('e:/t2.tif');

distRatio = 0.6;   
% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
n=0;
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
      n=n+1;
      pts1(n,:)=[loc1(i,2),loc1(i,1)];
      pts2(n,:)= [loc2(indx(1),2),loc2(indx(1),1)];
   else
      match(i) = 0;
   end
end


end

