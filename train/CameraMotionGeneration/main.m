 clc;
clear;
close all;

            %%%%%%%%%%% BLUR PARAMETERS %%%%%%%%%%
% Define the TSF bins
tx_limit= -2:1:2;
ty_limit= 0;
% tx_limit=0;
% ty_limit=0;
%tz_limit=0.9:0.025:1.1;
tz_limit=0;
%rx_limit=-4/3:1/3:4/3;
rx_limit=0;
%ry_limit=-4/3:1/3:4/3;
ry_limit=0;
% rz_limit=-2:1:2;
rz_limit=-5:.5:5;


parfor k=1:200000
    nonzero_homo=randi([1,40],1);
[tx,ty,tz,rx,ry,rz,weight]=gen_camera_path_connected_unique_dominant(nonzero_homo,tx_limit,ty_limit,tz_limit,rx_limit,ry_limit,rz_limit);

% % Visualization - works only for tx, ty - and for 1 pixel increments
% psf=zeros(length(tx_limit),length(ty_limit));
% for i=1:length(tx)
%     psf(tx(i)+ceil(length(tx_limit)/2),ty(i)+ceil(length(ty_limit)/2))=weight(i);
% end
% 
% figure, imshow(psf,[])
motion=zeros(1,105);

for i=1:nonzero_homo
    count=1;
    t=[];
for txlim= -2:1:2
   for rzlim=-5:.5:5
             tylim=0;
%         for rzlim=-3:.5:3
            t=[t; txlim tylim rzlim];
            if(ty(i)==tylim && tx(i)==txlim && rz(i)==rzlim)
                motion(count)=weight(i);
                count=count+1;
            end
            count=count+1;
%         end
   end
end
end
Motion(k,:)=motion;  %./sum(motion);
% Mot_cen(1,k)=sum(Motion(k,:).*t(:,1)');
% Mot_cen(2,k)=sum(Motion(k,:).*t(:,2)');
% Mot_cen(3,k)=sum(Motion(k,:).*t(:,3)');
if mod(k,100)==0
    k
end
end
 csvwrite('motion.csv',Motion);

