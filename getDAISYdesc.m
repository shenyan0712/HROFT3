function descs = getDAISYdesc( img,kpts,H,W)
%�õ�����������DAISY�������͹ؼ���
%   �˴���ʾ��ϸ˵��

dzy = compute_daisy(img);
Npts=size(kpts,1);

descs=zeros([Npts,200]);

%
for i=1:Npts
    y=int16(kpts(i,2)); x=int16(kpts(i,1));
    if y>=H; y=y-1; end
    if x>=W; x=x-1; end
    try
    out=display_descriptor(dzy,y,x);
    catch
        fprintf('xx');
    end
    out=reshape(out,[1,200]);
    descs(i, :)=out;
end
end

