function [lines1,lines2, matches]= HROFT(img1,img2)

region_size=20;

tic

ext = {'*.jpeg','*.jpg','*.png','*.pgm'};  
%file1='.\images\2A.tif';   %building1 1_A office01
%file2='.\images\2B.tif';
outfile1='.\T1.tif';
outfile2='.\T2.tif';
warpfile='.\T3.tif';

%I1_org=imread(file1); %图像的y轴朝下（即行下标），x轴朝右（即列下标）
%I2_org=imread(file2);

I1_org=img1;
I2_org=img2;


if size(size(I1_org),2) >2
    I1=rgb2gray(I1_org);
else
    I1=I1_org;
end
if size(size(I2_org),2) >2
    I2=rgb2gray(I2_org);
else
    I2=I2_org;
end

I1=histeq(I1,255);
I2=histeq(I2,255);

%I1_lines=lsd(file1);
%I2_lines=lsd(file2);

%{
figure;
disp_linesForOneImage(I1,I1_lines,1, false);
figure;
disp_linesForOneImage(I2,I2_lines,1, false);
%}

[H,W]=size(I1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %获得DAISY稠密关键点和描述符
 %[f1,vpts1]=getDAISYkptsDesc(I1,region_size);
 %[f2,vpts2]=getDAISYkptsDesc(I2,region_size);
 %%{
 %获得SURF关键点和描述符
 points1=detectSURFFeatures(I1,'MetricThreshold',4000);  %得到I1的SURF特征点
 points2=detectSURFFeatures(I2,'MetricThreshold',4000);  %得到I2的SURF特征
 %points1 = detectHarrisFeatures(I1);   
 %points2 = detectHarrisFeatures(I1);   
 %提取SURF描述符
 [f1,vpts1]=extractFeatures(I1,points1);
 vpts1=vpts1.Location;
 [f2,vpts2]=extractFeatures(I2,points2);
 vpts2=vpts2.Location;
 
 %进行点匹配
 idx_pairs=matchFeatures(f1,f2,'Method','Exhaustive','MatchThreshold',10, 'MaxRatio', 0.4);
 %得到匹配的点集合
 matchedPoints1=vpts1(idx_pairs(:,1),:);
 matchedPoints2=vpts2(idx_pairs(:,2),:); 
 %%}
 
 %SIFT feature extracting and matching
 %[matchedPoints1,matchedPoints2]=getSIFTmatches(file1, file2);
 %showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2,'montage');
 
 %计算得到两个图像间的homography变换T, 有Pts2=T(Pts1),其中Pts1是matchedPoints1中的内点，Pts2是matchedPoints2中的内点
 [T,dummy1,dummy2,status] = estimateGeometricTransform(double(matchedPoints1), double(matchedPoints2), ...
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

%计算T变换应用于I1时的结果图像的对应到I2图像的尺寸范围。 这个范围可能超出
%outputLimits的输出范围是 ....-2,-1,1,2,...
%当<=-1时，表示向左有多于或等于1个像素的超出。
%>=1时表示在I2尺寸的正常范围内。
[xlim, ylim] = outputLimits(T, [1 W], [1 H]);
off_lx=int16(round(xlim(1))); off_rx=int16(round(xlim(2)));
if off_lx>=1
    off_lx=off_lx-1;    off_rx=off_rx-1;
    W1p=off_rx-off_lx+1;
else
    W1p=off_rx-off_lx;
end
off_ty=int16(round(ylim(1))); off_by=int16(round(ylim(2)));
if off_ty>=1
    off_ty=off_ty-1;    off_by=off_by-1;
    H1p=off_by-off_ty+1;
else
    H1p=off_by-off_ty;
end

%I1t坐标系到I1的坐标系的位移, 即 P_1 = P_1t+Trans
Trans=double([off_lx,off_ty]);

%将I1通过T变形成I1t,其与I2近似
I1_t=imwarp(I1,T, 'SmoothEdges',true,'FillValues',0);   % 'SmoothEdges',true,'FillValues',255
I1t_org=imwarp(I1_org,T, 'SmoothEdges',true,'FillValues',0);
%I1_t=uint8(I1_t);
imwrite(I1t_org,warpfile);

I1_t=paddingImage(T,I1_t,H,W, Trans);

%计算得到I1_t和I2的公共区域
[AreaI1t,AreaI2]=getCommonArea(H,W,Trans, H1p,W1p);
I1_sy=AreaI1t(1); I1_ey=AreaI1t(2); I1_sx=AreaI1t(3); I1_ex=AreaI1t(4);
I2_sy=AreaI2(1); I2_ey=AreaI2(2); I2_sx=AreaI2(3); I2_ex=AreaI2(4);  
H1=I1_ey-I1_sy; W1=I1_ex-I1_sx;
H2=I2_ey-I2_sy; W2=I2_ex-I2_sx;

%将公共区域提取出来得到I1p和I2p
I2p=I1_t(I1_sy:I1_sy+H1-1, I1_sx:I1_sx+W1-1);
I2p_org=I1t_org(I1_sy:I1_sy+H1-1, I1_sx:I1_sx+W1-1,:);
imwrite(I2p,outfile2); 
I1p=I2(I2_sy:I2_sy+H1-1, I2_sx:I2_sx+W1-1);
I1p_org=I2_org(I2_sy:I2_sy+H1-1, I2_sx:I2_sx+W1-1,:);
imwrite(I1p,outfile1);

%图像I1p和I2p的坐标系相对于I2坐标系的位移, 即 P_1t = P_1p+Trans_p or P_2t = P_2p+Trans_p
Trans_p=double([I2_sx-1,I2_sy-1]); %因为范围是从(1,1)开始的，所以位移量要减1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%线匹配过程, 注意现在的I2p是I1的变换图像，I1p是I2的裁剪图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Hp,Wp]=size(I1p);
Mr=floor(Hp/region_size)+1;  %%高
Nr=floor(Wp/region_size)+1;  %%宽
    
%LSD算法的线检测，生成5*M阵列， 每一列对应一条线，分别为端点(x0,x1),端点(y0,y1),线宽w
%%{
I1p_lines=lsd(outfile1);
I2p_lines=lsd(outfile2);
fprintf('Extracted lines for A:%d\n', size(I2p_lines,2));
fprintf('Extracted lines for B:%d\n', size(I1p_lines,2));
%%}

%{
%将I1_lines变换为I1p_lines, 将I2_lines变换为I2p_lines
T2=projective2d(eye(3));
I1p_lines=transformLines(T, Trans_p, I1_lines,H,W);
I2p_lines=transformLines(T2, Trans_p, I2_lines,H,W);
%}
%figure;
%disp_linesForOneImage(I1p,I1p_lines,1, false);
%figure;
%disp_linesForOneImage(I2p,I2p_lines,1, false);

%由线生成点, 
%得到各区域包含线索引regionLine_idx，regionLine_cnt
%生成的点列表pts_list,pts_cnt， 以及各条线对应起始点在点列表中的位置索引ptsLine_idx
[ I1_regionLine_idx,I1_regionLine_cnt, I1_pts_list] =of_line2pts2(I1p_lines,Mr,Nr, region_size,0.1);
%I1_pts_list = I1_pts_list(:,1:I1_pts_cnt)';
I1_pts_list = round(I1_pts_list');
[ I2_regionLine_idx,I2_regionLine_cnt, I2_pts_list] =of_line2pts2(I2p_lines,Mr,Nr, region_size,0.1);
%I2_pts_list = I2_pts_list(:,1:I2_pts_cnt)';
I2_pts_list = round(I2_pts_list');

%显示两图像的线机及特征点(两端点+中点)
%{
disp_linesForOneImage(I1p_org,I1p_lines,1, false);
hold on;
plot(I1_pts_list(:,1), I1_pts_list(:,2), '.','color', [1,0,0]);
figure;
disp_linesForOneImage(I2p,I2p_lines,1, false);
hold on;
plot(I2_pts_list(:,1), I2_pts_list(:,2), '.','color', [1,0,0]);
%}

%*******利用点追踪得到前图像的点在当前图像的匹配点。
%创建点追踪器PointTracker
tracker = vision.PointTracker('NumPyramidLevels', 5, 'MaxBidirectionalError', 3);   %'MaxBidirectionalError', 1,

%%%%%%计算I1,I2之间的匹配
%用前一个图像及其点 初始化tracker
initialize(tracker, I1_pts_list,I1p);
%在I2中追踪这些点
[imagePoints2, validIdx] = step(tracker, I2p);
matchedPoints1 = I1_pts_list(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

ratio=size(matchedPoints1,1)/size(imagePoints2,1);
 
%显示匹配的点
%figure; ax=axes;
%showMatchedFeatures(I1p, I2p, matchedPoints1, matchedPoints2,'falsecolor');
%title('Tracked Features');
%disp_ptsLineMatches(img1,img2,matchedPoints1,matchedPoints2,I1_lines,I2_lines, Mr,Nr,region_size);
 
if  false
     %figure; showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2);
     %disp_ptsMatches(img1,img2,matchedPoints1.Location,matchedPoints2.Location);
     %legend('matched points 1','matched points 2');
     
     %计算区域所包含的点
     %[I1_regionPts_idx,I1_regionPts_cnt]=affinv_regionPts(matchedPoints1,Mr,Nr,region_size);
     %[I2_regionPts_idx,I2_regionPts_cnt]=affinv_regionPts(matchedPoints2,Mr,Nr,region_size);
     return;
 end
 
 %计算每条Lp_1i线在I2中所经过的区域, 会修改validIdx指示Lp_1i是否有效,修改imagePoints2得到Lp_1i的两个端点
 [lineRegion_idx,lineRegion_cnt,Lp_list,imagePoints2,validIdx]=of_regionOfLinePts2(Mr,Nr, imagePoints2,validIdx,region_size);
 I2p_linesEqs=getLineEqns(I2p_lines);
 
%计算匹配线
[ matchedLines,ML_cnt ]=of_linematching2(imagePoints2,Lp_list, validIdx,lineRegion_idx,lineRegion_cnt,I2_regionLine_idx, I2_regionLine_cnt, I2p_linesEqs,I2p_lines);
fprintf('Matched lines:%d\n', ML_cnt);
%disp_lineMatches(I1p,I2p,I1p_lines, I2p_lines, matchedLines,ML_cnt,1,true,false);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将在I1p,和I2p中匹配的线变回到I1和I2, 同时对超出范围的匹配进行裁剪
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[I2_lines,I1_lines]=reverseTransAndCut(I2p_lines,I1p_lines, T,Trans, Trans_p,H,W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%显示匹配的线
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp_linesForOneImage(I2, I1_lines,1, false);
%figure;
%disp_linesForOneImage(I1,I2_lines,1,false);
%figure;
%disp_lineMatches(I1_org,I2_org,I2_lines, I1_lines, matchedLines,ML_cnt,1,true,false);
%disp_lineMatchesOneImage(I2_org,I1_lines,matchedLines,ML_cnt,5,true);
%disp_lineMatchesOneImage(I1_org,I2_lines,matchedLines,ML_cnt,5,true);

Nlines1=size(Lp_list,1);
Nlines2=size(I2p_linesEqs,1);
Nlines=min(Nlines1,Nlines2);
ratio=ML_cnt/Nlines;
fprintf('match ratio=%f\n',ratio);

lines1=I2_lines;
lines2=I1_lines;
matches=matchedLines(1:ML_cnt,:);

end
