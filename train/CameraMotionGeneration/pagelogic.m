function [out] = pagelogic(pageno,a1,a2,a3,a4,a5,a6)

% a1=LSB
% a6=MSB
% page no. = array of index positions after vec operation
% out = cell with 6 elements in each arranged in LSB to MSB order

for i=1:length(pageno)
x=pageno(i);
z=mod(x,(a1*a2*a3*a4*a5));
y=floor(x/(a1*a2*a3*a4*a5));
if (z==0)
    out{1,i}=y;
    z=x/y;
else
    out{1,i}=y+1;
end

p=mod(z,a1*a2*a3*a4);
q=floor(z/(a1*a2*a3*a4));
if (p==0)
    out{1,i}=[q out{1,i}];
    p=z/q;
else
    out{1,i}=[q+1 out{1,i}];
end

s=mod(p,a1*a2*a3);
t=floor(p/(a1*a2*a3));
if (s==0)
    out{1,i}=[t out{1,i}];
    s=p/t;
else
    out{1,i}=[t+1 out{1,i}];
end

u=mod(s,a1*a2);
v=floor(s/(a1*a2));
if(u==0)
    out{1,i}=[v out{1,i}];
    u=s/v;
else
    out{1,i}=[v+1 out{1,i}];
end

l=mod(u,a1);
m=floor(u/a1);
if (l==0)
    out{1,i}=[m out{1,i}];
    l=u/m;
else
    out{1,i}=[m+1 out{1,i}];
end

out{1,i}=[l out{1,i}];
end