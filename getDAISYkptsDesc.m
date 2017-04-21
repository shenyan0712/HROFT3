function [ descs,kps] = getDAISYkptsDesc( img,region_size)
%�õ�����������DAISY�������͹ؼ���
%   �˴���ʾ��ϸ˵��

[H,W]=size(img);

dzy = compute_daisy(img);

INTERVAL=region_size/5;

M=ceil(H/INTERVAL)-1;
N=ceil(W/INTERVAL)-1;

descs=zeros([M*N,200]);
kps=zeros([M*N,2]);

for i=1:M
    for j=1:N
        idx=i*N+j;
        y=i*INTERVAL; x=j*INTERVAL;
        out=display_descriptor(dzy,y,x);
        out=reshape(out,[1,200]);
        descs(idx, :)=out;
        kps(idx,:)=[x,y];
        
    end  
end

end

