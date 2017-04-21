function [ lineRegion_idx,lineRegion_cnt,Lp_list,ptsInI2,validIdx] = of_regionOfLinePts(Mr,Nr, ptsInI2, validIdx, region_size )
%计算每条Lp_1i线在I2中所经过的区域
%{

输出：
lineRegion_idx ==>每条线在I2中所经过的区域列表, [2,MAX_REGIONS,Nlines]
lineRegion_cnt ==>每条线在I2中所经过的区域数量, [Nlines,1]
Lp_list        ==>Lp_1i线的直线方程, [Nlines,3]
%}

Nlines=size(ptsInI2,1)/3;
MAX_REGIONS=ceil(sqrt(Mr^2+Nr^2));  %每条线最多经过的区域
len_regDiag=sqrt(2*region_size^2);
lineRegion_idx=zeros([2,MAX_REGIONS,Nlines]);
lineRegion_cnt=zeros([Nlines,1]);
Lp_list=zeros([Nlines,3]);  %Lp_1i的直线方程


for i=1:Nlines
   
    %先确定出I1中线L_1i在I2中对应的线Lp_1i的两个端点
    idx=(i-1)*3+1;
    p1=ptsInI2(idx,:);
    p2=ptsInI2(idx+1,:);
    p3=ptsInI2(idx+2,:);
    if validIdx(idx) && validIdx(idx+2)
        p2=p3;
        ptsInI2(idx+1,:)=p3;
    elseif validIdx(idx) && validIdx(idx+1)
        p1=p1;
    elseif validIdx(idx+1) && validIdx(idx+2)
        validIdx(idx)=1;
        ptsInI2(idx,:)=p2;
        ptsInI2(idx+1,:)=p3;
    else
        %此线无匹配
        continue;
    end
    
    %得到线的方程
    p1=[p1,1]; p2=[p2,1];
    L=cross(p1,p2);
    L=L/norm([L(1),L(2)]);  %使得L方程的法线方向为单位向量
    Lp_list(i,:)=L;
    
    
    %计算Lp_1i在I2中的经过的区域
    p1M=floor(floor(p1(2))/region_size)+1; p1N=floor(floor(p1(1))/region_size)+1;
    p2M=floor(floor(p2(2))/region_size)+1; p2N=floor(floor(p2(1))/region_size)+1;    
    
    if p1M<1;
        p1M=1; 
    end
    if p2M<1;
        p2M=1; 
    end
    if p1N<1;
        p1N=1; 
    end
    if p2N<1;
        p2N=1;
    end
    
    if p1M>Mr;
        p1M=Mr; 
    end
    if p2M>Mr;
        p2M=Mr; 
    end
    if p1N>Nr;
        p1N=Nr; 
    end
    if p2N>Nr;
        p2N=Nr;
    end
    
    
    
    if p1M>p2M
        t=p1M; p1M=p2M; p2M=t;
    end
    if p1N>p2N
        t=p1N; p1N=p2N; p2N=t;
    end
    
    for m=p1M:p2M
        for n=p1N:p2N
            y=(m-1)*region_size+region_size/2;
            x=(n-1)*region_size+region_size/2;
            cp=[x,y,1];
            dist=abs(dot(L,cp));
            if dist<len_regDiag*(3/5)
                lineRegion_cnt(i)=lineRegion_cnt(i)+1;
                lineRegion_idx(:,lineRegion_cnt(i),i)=[m,n]';
            end
        end
    end
    
end %end of for

end

