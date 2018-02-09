function [tx,ty,tz,rx,ry,rz]=position2pose(position6D,tx_lim,ty_lim,tz_lim,rx_lim,ry_lim,rz_lim)

tx=zeros(1,length(position6D));
ty=tx; tz=tx; rx=tx; ry=tx; rz=tx;

for i=1:length(position6D)
    tx(1,i)=tx_lim(position6D{1,i}(1));
    ty(1,i)=ty_lim(position6D{1,i}(2));
    tz(1,i)=tz_lim(position6D{1,i}(3));
    rx(1,i)=rx_lim(position6D{1,i}(4));
    ry(1,i)=ry_lim(position6D{1,i}(5));
    rz(1,i)=rz_lim(position6D{1,i}(6));
end
