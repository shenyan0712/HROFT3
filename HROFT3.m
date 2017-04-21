function [lines1,lines2, matches]= HROFT(img1,img2)

region_size=20;

tic

ext = {'*.jpeg','*.jpg','*.png','*.pgm'};  
%file1='.\images\2A.tif';   %building1 1_A office01
%file2='.\images\2B.tif';
outfile1='.\T1.tif';
outfile2='.\T2.tif';
warpfile='.\T3.tif';

%I1_org=imread(file1); %ͼ���y�ᳯ�£������±꣩��x�ᳯ�ң������±꣩
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
 %���DAISY���ܹؼ����������
 %[f1,vpts1]=getDAISYkptsDesc(I1,region_size);
 %[f2,vpts2]=getDAISYkptsDesc(I2,region_size);
 %%{
 %���SURF�ؼ����������
 points1=detectSURFFeatures(I1,'MetricThreshold',4000);  %�õ�I1��SURF������
 points2=detectSURFFeatures(I2,'MetricThreshold',4000);  %�õ�I2��SURF����
 %points1 = detectHarrisFeatures(I1);   
 %points2 = detectHarrisFeatures(I1);   
 %��ȡSURF������
 [f1,vpts1]=extractFeatures(I1,points1);
 vpts1=vpts1.Location;
 [f2,vpts2]=extractFeatures(I2,points2);
 vpts2=vpts2.Location;
 
 %���е�ƥ��
 idx_pairs=matchFeatures(f1,f2,'Method','Exhaustive','MatchThreshold',10, 'MaxRatio', 0.4);
 %�õ�ƥ��ĵ㼯��
 matchedPoints1=vpts1(idx_pairs(:,1),:);
 matchedPoints2=vpts2(idx_pairs(:,2),:); 
 %%}
 
 %SIFT feature extracting and matching
 %[matchedPoints1,matchedPoints2]=getSIFTmatches(file1, file2);
 %showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2,'montage');
 
 %����õ�����ͼ����homography�任T, ��Pts2=T(Pts1),����Pts1��matchedPoints1�е��ڵ㣬Pts2��matchedPoints2�е��ڵ�
 [T,dummy1,dummy2,status] = estimateGeometricTransform(double(matchedPoints1), double(matchedPoints2), ...
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

%����T�任Ӧ����I1ʱ�Ľ��ͼ��Ķ�Ӧ��I2ͼ��ĳߴ緶Χ�� �����Χ���ܳ���
%outputLimits�������Χ�� ....-2,-1,1,2,...
%��<=-1ʱ����ʾ�����ж��ڻ����1�����صĳ�����
%>=1ʱ��ʾ��I2�ߴ��������Χ�ڡ�
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

%I1t����ϵ��I1������ϵ��λ��, �� P_1 = P_1t+Trans
Trans=double([off_lx,off_ty]);

%��I1ͨ��T���γ�I1t,����I2����
I1_t=imwarp(I1,T, 'SmoothEdges',true,'FillValues',0);   % 'SmoothEdges',true,'FillValues',255
I1t_org=imwarp(I1_org,T, 'SmoothEdges',true,'FillValues',0);
%I1_t=uint8(I1_t);
imwrite(I1t_org,warpfile);

I1_t=paddingImage(T,I1_t,H,W, Trans);

%����õ�I1_t��I2�Ĺ�������
[AreaI1t,AreaI2]=getCommonArea(H,W,Trans, H1p,W1p);
I1_sy=AreaI1t(1); I1_ey=AreaI1t(2); I1_sx=AreaI1t(3); I1_ex=AreaI1t(4);
I2_sy=AreaI2(1); I2_ey=AreaI2(2); I2_sx=AreaI2(3); I2_ex=AreaI2(4);  
H1=I1_ey-I1_sy; W1=I1_ex-I1_sx;
H2=I2_ey-I2_sy; W2=I2_ex-I2_sx;

%������������ȡ�����õ�I1p��I2p
I2p=I1_t(I1_sy:I1_sy+H1-1, I1_sx:I1_sx+W1-1);
I2p_org=I1t_org(I1_sy:I1_sy+H1-1, I1_sx:I1_sx+W1-1,:);
imwrite(I2p,outfile2); 
I1p=I2(I2_sy:I2_sy+H1-1, I2_sx:I2_sx+W1-1);
I1p_org=I2_org(I2_sy:I2_sy+H1-1, I2_sx:I2_sx+W1-1,:);
imwrite(I1p,outfile1);

%ͼ��I1p��I2p������ϵ�����I2����ϵ��λ��, �� P_1t = P_1p+Trans_p or P_2t = P_2p+Trans_p
Trans_p=double([I2_sx-1,I2_sy-1]); %��Ϊ��Χ�Ǵ�(1,1)��ʼ�ģ�����λ����Ҫ��1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ƥ�����, ע�����ڵ�I2p��I1�ı任ͼ��I1p��I2�Ĳü�ͼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Hp,Wp]=size(I1p);
Mr=floor(Hp/region_size)+1;  %%��
Nr=floor(Wp/region_size)+1;  %%��
    
%LSD�㷨���߼�⣬����5*M���У� ÿһ�ж�Ӧһ���ߣ��ֱ�Ϊ�˵�(x0,x1),�˵�(y0,y1),�߿�w
%%{
I1p_lines=lsd(outfile1);
I2p_lines=lsd(outfile2);
fprintf('Extracted lines for A:%d\n', size(I2p_lines,2));
fprintf('Extracted lines for B:%d\n', size(I1p_lines,2));
%%}

%{
%��I1_lines�任ΪI1p_lines, ��I2_lines�任ΪI2p_lines
T2=projective2d(eye(3));
I1p_lines=transformLines(T, Trans_p, I1_lines,H,W);
I2p_lines=transformLines(T2, Trans_p, I2_lines,H,W);
%}
%figure;
%disp_linesForOneImage(I1p,I1p_lines,1, false);
%figure;
%disp_linesForOneImage(I2p,I2p_lines,1, false);

%�������ɵ�, 
%�õ����������������regionLine_idx��regionLine_cnt
%���ɵĵ��б�pts_list,pts_cnt�� �Լ������߶�Ӧ��ʼ���ڵ��б��е�λ������ptsLine_idx
[ I1_regionLine_idx,I1_regionLine_cnt, I1_pts_list] =of_line2pts2(I1p_lines,Mr,Nr, region_size,0.1);
%I1_pts_list = I1_pts_list(:,1:I1_pts_cnt)';
I1_pts_list = round(I1_pts_list');
[ I2_regionLine_idx,I2_regionLine_cnt, I2_pts_list] =of_line2pts2(I2p_lines,Mr,Nr, region_size,0.1);
%I2_pts_list = I2_pts_list(:,1:I2_pts_cnt)';
I2_pts_list = round(I2_pts_list');

%��ʾ��ͼ����߻���������(���˵�+�е�)
%{
disp_linesForOneImage(I1p_org,I1p_lines,1, false);
hold on;
plot(I1_pts_list(:,1), I1_pts_list(:,2), '.','color', [1,0,0]);
figure;
disp_linesForOneImage(I2p,I2p_lines,1, false);
hold on;
plot(I2_pts_list(:,1), I2_pts_list(:,2), '.','color', [1,0,0]);
%}

%*******���õ�׷�ٵõ�ǰͼ��ĵ��ڵ�ǰͼ���ƥ��㡣
%������׷����PointTracker
tracker = vision.PointTracker('NumPyramidLevels', 5, 'MaxBidirectionalError', 3);   %'MaxBidirectionalError', 1,

%%%%%%����I1,I2֮���ƥ��
%��ǰһ��ͼ����� ��ʼ��tracker
initialize(tracker, I1_pts_list,I1p);
%��I2��׷����Щ��
[imagePoints2, validIdx] = step(tracker, I2p);
matchedPoints1 = I1_pts_list(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

ratio=size(matchedPoints1,1)/size(imagePoints2,1);
 
%��ʾƥ��ĵ�
%figure; ax=axes;
%showMatchedFeatures(I1p, I2p, matchedPoints1, matchedPoints2,'falsecolor');
%title('Tracked Features');
%disp_ptsLineMatches(img1,img2,matchedPoints1,matchedPoints2,I1_lines,I2_lines, Mr,Nr,region_size);
 
if  false
     %figure; showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2);
     %disp_ptsMatches(img1,img2,matchedPoints1.Location,matchedPoints2.Location);
     %legend('matched points 1','matched points 2');
     
     %���������������ĵ�
     %[I1_regionPts_idx,I1_regionPts_cnt]=affinv_regionPts(matchedPoints1,Mr,Nr,region_size);
     %[I2_regionPts_idx,I2_regionPts_cnt]=affinv_regionPts(matchedPoints2,Mr,Nr,region_size);
     return;
 end
 
 %����ÿ��Lp_1i����I2��������������, ���޸�validIdxָʾLp_1i�Ƿ���Ч,�޸�imagePoints2�õ�Lp_1i�������˵�
 [lineRegion_idx,lineRegion_cnt,Lp_list,imagePoints2,validIdx]=of_regionOfLinePts2(Mr,Nr, imagePoints2,validIdx,region_size);
 I2p_linesEqs=getLineEqns(I2p_lines);
 
%����ƥ����
[ matchedLines,ML_cnt ]=of_linematching2(imagePoints2,Lp_list, validIdx,lineRegion_idx,lineRegion_cnt,I2_regionLine_idx, I2_regionLine_cnt, I2p_linesEqs,I2p_lines);
fprintf('Matched lines:%d\n', ML_cnt);
%disp_lineMatches(I1p,I2p,I1p_lines, I2p_lines, matchedLines,ML_cnt,1,true,false);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����I1p,��I2p��ƥ����߱�ص�I1��I2, ͬʱ�Գ�����Χ��ƥ����вü�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[I2_lines,I1_lines]=reverseTransAndCut(I2p_lines,I1p_lines, T,Trans, Trans_p,H,W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

%��ʾƥ�����
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
