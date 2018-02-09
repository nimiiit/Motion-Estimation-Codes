
function[M]=get_motion_matrix(nrows,ncols,H,w,nhomos)
Mloc = mbMatrix([nrows,ncols],H,w,[0,0],[nrows,ncols],[nrows/2,ncols/2]);  % is a cpp file, returns the locations and weights of warped positions from clean image?
npix=nrows*ncols;


M = sparse(npix,npix);

for m = 1:max(nhomos)
    rows = repmat([1:npix]',[4,1]);
    cols = 1 + [Mloc(:,(m-1)*8 + 1);Mloc(:,(m-1)*8 + 2);Mloc(:,(m-1)*8 + 3);Mloc(:,(m-1)*8 + 4)]; % 4 posns corresponding to warp and bil interp
    vals = [Mloc(:,(m-1)*8 + 5);Mloc(:,(m-1)*8 + 6);Mloc(:,(m-1)*8 + 7);Mloc(:,(m-1)*8 + 8)]; % corresponding bil interp weights
    
    idx = find(cols >= 1 & cols <= npix);
    rows = rows(idx);
    cols = cols(idx);
    vals = vals(idx);  % considering only those mappings which maps inside image window
    
    Mtmp = sparse(rows,cols,vals,npix,npix);
    M = M + Mtmp;  % sparse M matrix
    clear Mtmp;
end
end