function [ matchedLines,ML_cnt ] = of_linematching2(ptsInI2,Lp_list,validIdx, ...
                                        lineRegion_idx, lineRegion_cnt, ...
                                      I2_regionLine_idx, I2_regionLine_cnt, I2_linesEqs,I2_lines)
% ������ͼ��֮�����ƥ��
%{
���룺
ptsInI2      ==>I1����L_1i�Ĳ�������I2�е�ƥ��㣬[2,3*Nlines],
NlinesΪ�ߵ��������Ѿ���������ֻǰ��������Ч
Lp_list      ==>Lp_1i�ߵ�ֱ�߷���
validIdx       ==>�Ƿ�����Чƥ�䣬[3*Nlines,1], �Ѿ�����������1��ֵ��Ч
lineRegion_idx      ==>ÿ��Lp_1i����I2���������������б�, [2,MAX_REGIONS,Nlines]
lineRegion_cnt      ==>ÿ������I2������������������, [Nlines,1]
I2_regionLine_idx   ==>I2�ĸ��������������, [max_cnt,Mr,Nr]
I2_regionLine_cnt   ==>I2�ĸ�������������������� [Mr,Nr]
I2_line_list        ==>I2���ߵ�ֱ�߷����б� [Nlines,3]
�����
matchedLines ==>ƥ����ߵ�������[numOfMatches, 2],  ����[i,1]ΪI1���ߵ�������[i,2]ΪI2���ߵ�����
%}

%NlinesΪI1�е����ߵ�����
Nlines=size(ptsInI2,1);
Nlines=Nlines/3;

%
matchedLines=zeros(Nlines*2,2);
ML_cnt=0;

%����I1�ĵ�i����L_1i
for i=1:Nlines
    candidateLineIdx=0;    %I1�е�i���߶�Ӧ��I2�еĺ�ѡƥ���ߵ�����
    candidateAng=90;
    candidateDist=1e3;
    theSameCnt=1;
    
    %�õ����߶�Ӧ������ƥ���
    idx=(i-1)*3+1;
    p1=ptsInI2(idx,:);
    p2=ptsInI2(idx+1,:);
    cp=(p1+p2)/2;
    %���ߵ�ֱ�߷���
    Lp=Lp_list(i,:);
    
    if ~validIdx(idx)   %����û��ƥ��
        continue
    end
    
    %��Lp_1i�߾����������е���һһ�Ƚ�
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
           line_idx=I2_regionLine_idx(k,pM,pN);  %�������ߵ�����
           Leq=I2_linesEqs(line_idx,:);
           %����Lp��L�ļн�
           ang=[Lp(1),Lp(2)]*[Leq(1),Leq(2)]'; %��ΪLp��L�ķ��������ǵ�λ���ģ����Բ���Ҫ�ٳ��䷶��
           ang=acosd(ang);        
           if ang>90 
               ang=abs(180-ang);
           end
           %����Lp�ĵ㵽L�ľ���
           dist1=abs(dot(Leq,[p1,1]));
           dist2=abs(dot(Leq,[p2,1]));
           dist=(dist1+dist2)/2;
           
           %{
           %����Lp�ĵ㵽L�Ĵ���
           pp1=calcPedalPoint(Leq,p1);
           pp2=calcPedalPoint(Leq,p2);
           %�ж�����������Ƿ�����һ�����߶εķ�Χ��
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
           
           %ƥ�������
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
    %������õ�������Lp�н���С����3���ظ��Ƚϵģ��ĺ�ѡ��
    %�����ѡ�н�С�ڷ�ֵ�����ʾƥ�䣬��ӵ�ƥ���б���
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

