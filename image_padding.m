function [ img ] = image_padding( img )
%ɨ��ͼ��ı�Ե�������ɫ����ɫ��ǰ��ɫ���

[H,W]=size(img);

%�������Ե
for i=1:H
   for j=1:W/2
      pv=img(i,j); %ȡ����ֵ
      if pv~=0  %������
          for k=j:-1:1
            img(i,k)=pv;              
          end
          break;
      end
   end
end

%�����ұ�Ե
for i=1:H
   for j=W:-1:W/2
      pv=img(i,j); %ȡ����ֵ
      if pv~=0  %������
          for k=j:-1:1
            img(i,k)=pv;              
          end
          break;
      end
   end
end




end

