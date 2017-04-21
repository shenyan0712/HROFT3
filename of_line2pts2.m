function [ region_line_idx,region_line_cnt,linePts_list,linePts_idx] = of_line2pts2( lines, Mr,Nr, region_size, region_ratio  )
% 将lsd生成的线分解为两端点+中点，并建立线所经过的区域列表
%{
 输入:
lines ==> 5xNl阵列, Nl为线的数量
W,H ==>图像的宽和高
region_size ==>将图像划分成区域的尺寸
region_ratio ==>区域中线数量占区域面积的比率
输出：
region_line_idx ==>[Mr,Nr,pts_max],Mr,Nr为区域的数量,给出每个区域内包含线的索引
linePts_list    ==> [2,3*Nlines], Np为总的点数
linePts_idx     ==>L_i线对应的第一个采样点在linePts_list中的位置
%}

Nl=size(lines,2);

MAX_LINES=round(region_size*region_size*region_ratio);    %每个区域中包含线的最大数量

region_line_idx=-1*ones([MAX_LINES,Mr,Nr]);   %每个区域中包含线的索引
region_line_cnt=zeros([Mr,Nr]);         %每个区域中包含线的数量
linePts_list=zeros([2, Nl*3]);            %每条线对应的点的列表
linePts_idx=zeros([Nl,1]);
LEN_STEP=region_size/2;

for i=1:Nl      %逐条处理第i条线段
    region_added=zeros([Mr,Nr]);        %用于指示该点是否已经添加到相应区域内，在实际实现时可用bit位操作来完成
    %得到线段的中点, 从终点开始取点是为了对称性，同时当线很短是就只取一个中点。
    L=lines(:,i);   %%[x0,x1,y0,y1,w]
    cp=[(L(1)+L(2))/2, (L(3)+L(4))/2]'; 
    
    %将线的两端点和中点存到pts_list
    if L(1)<1; L(1)=1; end
    if L(2)<1; L(2)=1; end
    if L(3)<1; L(3)=1; end
    if L(4)<1; L(4)=1; end
    if cp(1)<1;
        cp=1; 
    end
    if cp(2)<1;
        cp=1; 
    end
    
    idx=(i-1)*3+1;
    linePts_list(:,idx)=[L(1),L(3)]';
    linePts_list(:,idx+1)=cp;
    linePts_list(:,idx+2)=[L(2),L(4)]';
    linePts_idx(i)=idx;
    
    %计算出直线方向的单位向量，[x2-x1,y2-y1]的方向为正方向
    dir=[L(2)-L(1),L(4)-L(3)]';
    L_len=norm(dir);
    dir=dir/L_len;
    half_len=L_len/2;
    
    %%%从中点开始，在线的正方向上生成点
    pt=[0,0]';
    while norm(pt)<=half_len
        tt=cp+pt;
        %得到该点所在的区域
        pM=floor(tt(2)/region_size)+1; pN=floor(tt(1)/region_size)+1;
        if pM>Mr || pN>Nr  %
            break;
        end
        %如果该线段还没有加入到区域(pM,pN)的线列表，则添加进去，同时将区域添加到线的区域列表
        if region_added(pM,pN)==0
           region_added(pM,pN)=1;
           if region_line_cnt(pM,pN)<MAX_LINES
                region_line_cnt(pM,pN)=region_line_cnt(pM,pN)+1;
                region_line_idx(region_line_cnt(pM,pN),pM,pN)=i; %将该线段添加进去
           end
        end
        %确定线对应的点在点列表中的起始位置
        %if pt(1)==0 && pt(2)==0
        %pts_line_idx(i)=pts_cnt;
        %end
        pt=pt+LEN_STEP*dir;
    end
    
    
    pt=-LEN_STEP*dir;
    %%%在线的反方向上生成点
    while norm(pt)<=half_len
       tt=cp+pt;
       pM=floor(tt(2)/region_size)+1; pN=floor(tt(1)/region_size)+1;
       if pM>Mr || pN>Nr  %
            break;
       end
       %将该点添加到点列表中
       %pts_cnt = pts_cnt+1;
       %pts_list(:,pts_cnt)=tt;
       %如果该线段还没有加入到区域(pM,pN)的线列表，则添加进去
       if region_added(pM,pN)==0 
            region_added(pM,pN)=1;
            if region_line_cnt(pM,pN)<MAX_LINES 
                region_line_cnt(pM,pN)=region_line_cnt(pM,pN)+1;
                region_line_idx(region_line_cnt(pM,pN),pM,pN)=i; %将该线段添加进去
            end
       end  
       pt=pt+(-LEN_STEP*dir);
    end
end %end of for i=1:Nl

end

