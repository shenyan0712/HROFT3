function [ region_line_idx,region_line_cnt,linePts_list,linePts_idx] = of_line2pts2( lines, Mr,Nr, region_size, region_ratio  )
% ��lsd���ɵ��߷ֽ�Ϊ���˵�+�е㣬���������������������б�
%{
 ����:
lines ==> 5xNl����, NlΪ�ߵ�����
W,H ==>ͼ��Ŀ�͸�
region_size ==>��ͼ�񻮷ֳ�����ĳߴ�
region_ratio ==>������������ռ��������ı���
�����
region_line_idx ==>[Mr,Nr,pts_max],Mr,NrΪ���������,����ÿ�������ڰ����ߵ�����
linePts_list    ==> [2,3*Nlines], NpΪ�ܵĵ���
linePts_idx     ==>L_i�߶�Ӧ�ĵ�һ����������linePts_list�е�λ��
%}

Nl=size(lines,2);

MAX_LINES=round(region_size*region_size*region_ratio);    %ÿ�������а����ߵ��������

region_line_idx=-1*ones([MAX_LINES,Mr,Nr]);   %ÿ�������а����ߵ�����
region_line_cnt=zeros([Mr,Nr]);         %ÿ�������а����ߵ�����
linePts_list=zeros([2, Nl*3]);            %ÿ���߶�Ӧ�ĵ���б�
linePts_idx=zeros([Nl,1]);
LEN_STEP=region_size/2;

for i=1:Nl      %���������i���߶�
    region_added=zeros([Mr,Nr]);        %����ָʾ�õ��Ƿ��Ѿ���ӵ���Ӧ�����ڣ���ʵ��ʵ��ʱ����bitλ���������
    %�õ��߶ε��е�, ���յ㿪ʼȡ����Ϊ�˶Գ��ԣ�ͬʱ���ߺܶ��Ǿ�ֻȡһ���е㡣
    L=lines(:,i);   %%[x0,x1,y0,y1,w]
    cp=[(L(1)+L(2))/2, (L(3)+L(4))/2]'; 
    
    %���ߵ����˵���е�浽pts_list
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
    
    %�����ֱ�߷���ĵ�λ������[x2-x1,y2-y1]�ķ���Ϊ������
    dir=[L(2)-L(1),L(4)-L(3)]';
    L_len=norm(dir);
    dir=dir/L_len;
    half_len=L_len/2;
    
    %%%���е㿪ʼ�����ߵ������������ɵ�
    pt=[0,0]';
    while norm(pt)<=half_len
        tt=cp+pt;
        %�õ��õ����ڵ�����
        pM=floor(tt(2)/region_size)+1; pN=floor(tt(1)/region_size)+1;
        if pM>Mr || pN>Nr  %
            break;
        end
        %������߶λ�û�м��뵽����(pM,pN)�����б�����ӽ�ȥ��ͬʱ��������ӵ��ߵ������б�
        if region_added(pM,pN)==0
           region_added(pM,pN)=1;
           if region_line_cnt(pM,pN)<MAX_LINES
                region_line_cnt(pM,pN)=region_line_cnt(pM,pN)+1;
                region_line_idx(region_line_cnt(pM,pN),pM,pN)=i; %�����߶���ӽ�ȥ
           end
        end
        %ȷ���߶�Ӧ�ĵ��ڵ��б��е���ʼλ��
        %if pt(1)==0 && pt(2)==0
        %pts_line_idx(i)=pts_cnt;
        %end
        pt=pt+LEN_STEP*dir;
    end
    
    
    pt=-LEN_STEP*dir;
    %%%���ߵķ����������ɵ�
    while norm(pt)<=half_len
       tt=cp+pt;
       pM=floor(tt(2)/region_size)+1; pN=floor(tt(1)/region_size)+1;
       if pM>Mr || pN>Nr  %
            break;
       end
       %���õ���ӵ����б���
       %pts_cnt = pts_cnt+1;
       %pts_list(:,pts_cnt)=tt;
       %������߶λ�û�м��뵽����(pM,pN)�����б�����ӽ�ȥ
       if region_added(pM,pN)==0 
            region_added(pM,pN)=1;
            if region_line_cnt(pM,pN)<MAX_LINES 
                region_line_cnt(pM,pN)=region_line_cnt(pM,pN)+1;
                region_line_idx(region_line_cnt(pM,pN),pM,pN)=i; %�����߶���ӽ�ȥ
            end
       end  
       pt=pt+(-LEN_STEP*dir);
    end
end %end of for i=1:Nl

end

