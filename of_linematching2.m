function [ matchedLines,ML_cnt ] = of_linematching2(ptsInI2,Lp_list,validIdx, ...
                                        lineRegion_idx, lineRegion_cnt, ...
                                      I2_regionLine_idx, I2_regionLine_cnt, I2_linesEqs,I2_lines)
% 计算两图像之间的线匹配
%{
输入：
ptsInI2      ==>I1的线L_1i的采样点在I2中的匹配点，[2,3*Nlines],
Nlines为线的数量，已经经过处理，只前两个点有效
Lp_list      ==>Lp_1i线的直线方程
validIdx       ==>是否是有效匹配，[3*Nlines,1], 已经经过处理，第1个值有效
lineRegion_idx      ==>每条Lp_1i线在I2中所经过的区域列表, [2,MAX_REGIONS,Nlines]
lineRegion_cnt      ==>每条线在I2中所经过的区域数量, [Nlines,1]
I2_regionLine_idx   ==>I2的各区域包含线索引, [max_cnt,Mr,Nr]
I2_regionLine_cnt   ==>I2的各区域包含线索引的数量 [Mr,Nr]
I2_line_list        ==>I2的线的直线方程列表 [Nlines,3]
输出：
matchedLines ==>匹配的线的索引，[numOfMatches, 2],  其中[i,1]为I1的线的索引，[i,2]为I2的线的索引
%}

%Nlines为I1中的总线的数量
Nlines=size(ptsInI2,1);
Nlines=Nlines/3;

%
matchedLines=zeros(Nlines*2,2);
ML_cnt=0;

%处理I1的第i条线L_1i
for i=1:Nlines
    candidateLineIdx=0;    %I1中第i条线对应的I2中的候选匹配线的索引
    candidateAng=90;
    candidateDist=1e3;
    theSameCnt=1;
    
    %得到该线对应的两个匹配点
    idx=(i-1)*3+1;
    p1=ptsInI2(idx,:);
    p2=ptsInI2(idx+1,:);
    cp=(p1+p2)/2;
    %该线的直线方程
    Lp=Lp_list(i,:);
    
    if ~validIdx(idx)   %该线没有匹配
        continue
    end
    
    %与Lp_1i线经过的区域中的线一一比较
    numRegions=lineRegion_cnt(i);
    region_list=lineRegion_idx(:,1:numRegions,i);
    for j=1:numRegions
        pM=region_list(1,j); pN=region_list(2,j);
        try
        numLines=I2_regionLine_cnt(pM,pN);
        catch
               fprintf('xx');
        end
        for k=1:numLines
           line_idx=I2_regionLine_idx(k,pM,pN);  %区域中线的索引
           Leq=I2_linesEqs(line_idx,:);
           %计算Lp与L的夹角
           ang=[Lp(1),Lp(2)]*[Leq(1),Leq(2)]'; %因为Lp和L的法向量都是单位化的，所以不需要再除其范数
           ang=acosd(ang);        
           if ang>90 
               ang=abs(180-ang);
           end
           %计算Lp的点到L的距离
           dist1=abs(dot(Leq,[p1,1]));
           dist2=abs(dot(Leq,[p2,1]));
           dist=(dist1+dist2)/2;
           
           %{
           %计算Lp的点到L的垂足
           pp1=calcPedalPoint(Leq,p1);
           pp2=calcPedalPoint(Leq,p2);
           %判断两个垂足点是否至少一个在线段的范围内
           I2L_x1=I2_lines(1,line_idx); I2L_x2=I2_lines(2,line_idx);
           if I2L_x1>I2L_x2
               t=I2L_x1;    I2L_x1=I2L_x2;  I2L_x2=t;
           end
           I2L_y1=I2_lines(3,line_idx); I2L_y2=I2_lines(4,line_idx);
           if I2L_y1>I2L_y2
               t=I2L_y1;    I2L_y1=I2L_y2;  I2L_y2=t;
           end
           I2L_x1=I2L_x1-25; I2L_x2=I2L_x2+25;
           I2L_y1=I2L_y1-25; I2L_y1=I2L_y1+25;
           isInLine=false;
           if (I2L_x1<=pp1(1) && pp1(1)<=I2L_x2) && (I2L_y1<=pp1(2) && pp1(2)<=I2L_y2)
               isInLine=true;
           end
           if (I2L_x1<=pp2(1) && pp2(1)<=I2L_x2) && (I2L_y1<=pp2(2) && pp2(2)<=I2L_y2)
               isInLine=true;
           end
           %}
           
           %匹配的条件
           if ang<5 && dist<2 %&& isInLine
               if ML_cnt>=Nlines || candidateLineIdx==line_idx
                   break;
               end
               ML_cnt=ML_cnt+1;
               matchedLines(ML_cnt,:)=[i,line_idx];
               candidateLineIdx=line_idx;
               %{
              candidateAng=ang;
              candidateDist=dist;
              if candidateLineIdx==line_idx
                  theSameCnt=theSameCnt+1;
                  if theSameCnt==3
                      break;
                  end
              end
              candidateLineIdx=line_idx;
               %}
           end
           
        end % end of k=1:numLines
        if theSameCnt==3
            break;
        end
    end % end of j=1:numRegions
    %到这里，得到的是与Lp夹角最小（或3次重复比较的）的候选线
    %如果候选夹角小于阀值，则表示匹配，添加到匹配列表中
    %{
    if candidateAng<2 && (candidateDist<2 )
       ML_cnt=ML_cnt+1;
       if ML_cnt>Nlines
           break;
       end
       matchedLines(ML_cnt,:)=[i,candidateLineIdx];
    end
    %}
end %end of for i=1:Nlines

end

