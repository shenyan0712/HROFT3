clc
clear
close all

file1='..\images\1.jpg';   %building1 1_A office01
file2='..\images\2.jpg';
file3='..\images\3.jpg';

img1=imread(file1); %ͼ���y�ᳯ�£������±꣩��x�ᳯ�ң������±꣩
img2=imread(file2);
img3=imread(file2);

[lines1,lines2,lines3,matches]=HROFT3(img1,img2,img3);

disp_lineMatches(img1,img2,lines1,lines2, matches,size(matches,1),1,true,false);

