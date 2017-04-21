function [ img ] = image_padding( img )
%扫描图像的边缘，将其黑色背景色用前景色填充

[H,W]=size(img);

%处理左边缘
for i=1:H
   for j=1:W/2
      pv=img(i,j); %取像素值
      if pv~=0  %往回填
          for k=j:-1:1
            img(i,k)=pv;              
          end
          break;
      end
   end
end

%处理右边缘
for i=1:H
   for j=W:-1:W/2
      pv=img(i,j); %取像素值
      if pv~=0  %往回填
          for k=j:-1:1
            img(i,k)=pv;              
          end
          break;
      end
   end
end




end

