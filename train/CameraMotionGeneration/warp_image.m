function oup=warp_image(I1,tx,ty,rz,w)
I1=double(I1);
[nrows,ncols,~]=size(I1);
nhomos=1;
H=[cos(rz*pi/180) -sin(rz*pi/180) tx;sin(rz*pi/180) cos(rz*pi/180) ty;0 0 1];
[M]=get_motion_matrix(nrows,ncols,H,w,nhomos);
for i=1:size(I1,3)
    A=I1(:,:,i);
op=M*A(:);
oup(:,:,i)=reshape(op,nrows,ncols);
end
end