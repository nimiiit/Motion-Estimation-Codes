function [tx,ty,tz,rx,ry,rz,weight]=gen_camera_path_connected_unique_dominant(nonzero_homo,tx_limit,ty_limit,tz_limit, ...
         rx_limit,ry_limit,rz_limit)
 
     
 % pick a random starting point
 
 start_point=[tx_limit(ceil(rand*length(tx_limit))) ...
              ty_limit(ceil(rand*length(ty_limit))) ...
              tz_limit(ceil(rand*length(tz_limit))) ...
              rx_limit(ceil(rand*length(rx_limit))) ...
              ry_limit(ceil(rand*length(ry_limit))) ...
              rz_limit(ceil(rand*length(rz_limit)))];
          
% dominant direction
flag=zeros(1,6);
if(length(tx_limit)~=1), flag(1)=1; end
if(length(ty_limit)~=1), flag(2)=1; end
if(length(tz_limit)~=1), flag(3)=1; end
if(length(rx_limit)~=1), flag(4)=1; end
if(length(ry_limit)~=1), flag(5)=1; end
if(length(rz_limit)~=1), flag(6)=1; end

dflag=zeros(1,6);
for i=randperm(6)
    if(flag(i)~=0)
    dflag(i)=1;
    break;
    end
end
% dflag(1:3)

% form a connected path
tx=[]; ty=[]; tz=[];
rx=[]; ry=[]; rz=[];

% Build the TSF:
[tx_loc, ~, ~, ~, ~, ~] = ndgrid(tx_limit,ty_limit,tz_limit,rx_limit,ry_limit,rz_limit);
tsf=zeros(size(tx_loc));
    
current=start_point;
counter=0;
while(1)
    
    counter=counter+1;
    temp=return_neighbour_dominant(current(1),tx_limit,dflag(1));
    tx=[tx temp];
    current(1)=temp;
    
    temp=return_neighbour_dominant(current(2),ty_limit,dflag(2));
    ty=[ty temp];
    current(2)=temp;
    
    temp=return_neighbour_dominant(current(3),tz_limit,dflag(3));
    tz=[tz temp];
    current(3)=temp;
    
    temp=return_neighbour_dominant(current(4),rx_limit,dflag(4));
    rx=[rx temp];
    current(4)=temp;
    
    temp=return_neighbour_dominant(current(5),ry_limit,dflag(5));
    ry=[ry temp];
    current(5)=temp;
    
    temp=return_neighbour_dominant(current(6),rz_limit,dflag(6));
    rz=[rz temp];
    current(6)=temp;
    

    tsf(find(tx_limit==tx(end)),find(ty_limit==ty(end)),find(tz_limit==tz(end)), ...
        find(rx_limit==rx(end)),find(ry_limit==ry(end)),find(rz_limit==rz(end)))=counter+rand*counter;
  if(length(find(tsf(:)))>=nonzero_homo)  
      break;
  end    
end 

[biggestweights, index]=sort(tsf(:),'descend');
howmany=length(find(tsf(:)));
biggestweights=biggestweights(1:howmany);
weight=biggestweights/sum(biggestweights);
index=index(1:howmany);
positions6D=pagelogic(index,length(tx_limit),length(ty_limit),length(tz_limit),length(rx_limit),length(ry_limit), ...
                             length(rz_limit));
[tx,ty,tz,rx,ry,rz]=position2pose(positions6D,tx_limit,ty_limit,tz_limit,rx_limit,ry_limit,rz_limit);
% weight=randperm(length(tx));
% weight=weight/sum(weight);
% weight=rand(1,length(tx));
% weight=ones(1,nonzero_homo);
% weight=weight/sum(weight);
    
end
     
     
