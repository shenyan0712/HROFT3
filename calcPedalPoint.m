function pp = calcPedalPoint( line, pt )
%计算pt到line的垂足点
%{
line    ==>[n,d]
pt      ==>[x,y]
%}

n=[line(1),line(2)];
a=(-pt*n'-line(3))/norm(n);

pp=int16(round(pt+a*n));

end

