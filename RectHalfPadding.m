
function It=RectHalfPadding(It,range,line1)
%
%{
area    ==> 'upLeft', 'upRight', 'downLeft', 'downRight'
%}
xs=int16(round(range(1))); 
xe=int16(round(range(2))); 
ys=int16(round(range(3))); 
ye=int16(round(range(4)));
line1_eq=calcLineEq(double(line1));
step1=int16(-2*[line1_eq(1),line1_eq(2)]);

for x=xs:xe
    for y=ys:ye
        %{
        try
        pv1=It(y,x);
        catch
            fprintf('xx');
        end
        if pv1>0
           pv2=It(y+1*ydir,x);
           pv3=It(y+2*ydir,x);
           if pv1>pv2; t=pv1; pv1=pv2; pv2=t; end
           if pv2>pv3; t=pv2; pv2=pv3; pv3=t; end
           if pv1>pv2; t=pv1; pv1=pv2; pv2=t; end
       
           for yy=y:-ydir:ys
               It(yy,x)=pv2;
           end
           break;
        end
        %}
         
        %%{
        %计算lx
        v1=line1_eq*double([x,y,1])';
        if v1<-1
            continue;
        end
        %计算点(x,y)到line上的垂足点
        pp1=calcPedalPoint(line1_eq,double([x,y]));
        pv=It(pp1(2)+step1(2),pp1(1)+step1(1));
        It(y,x)=pv;

    end
end



end