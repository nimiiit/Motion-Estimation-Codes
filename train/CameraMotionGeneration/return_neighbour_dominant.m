function neighbour=return_neighbour_dominant(current,limitvar,flag)
if(length(limitvar)==1) % zero search interval
    neighbour=limitvar;
else
    if(flag==0)
    index=find(current==limitvar);
    if(index==length(limitvar)) % end of search interval
        if(rand<0.8)
        neighbour=limitvar(index); % last value of interval
        else
        neighbour=limitvar(index-1); % retrace to last but one
        end
    elseif(index==1) % start of search interval
        if(rand<0.8)
        neighbour=limitvar(index); % first value of interval
        else
        neighbour=limitvar(index+1); % next value of interval
        end
    else
        dummy=rand;
        if(dummy<0.1) 
        neighbour=limitvar(index-1); % back
        elseif(dummy>0.9) 
        neighbour=limitvar(index+1); % forward
        else
        neighbour=limitvar(index); % Stop 
        end
    end
    else % flag ==1
        index=find(current==limitvar);
    if(index==length(limitvar)) % end of search interval
        if(rand>0.8)
        neighbour=limitvar(index); % last value of interval
        else
        neighbour=limitvar(index-1); % retrace to last but one
        end
    elseif(index==1) % start of search interval
        if(rand>0.8)
        neighbour=limitvar(index); % first value of interval
        else
        neighbour=limitvar(index+1); % next value of interval
        end
    else
        dummy=rand;
        if(dummy<0.4) 
        neighbour=limitvar(index-1); % back
        elseif(dummy>0.6) 
        neighbour=limitvar(index+1); % forward
        else
        neighbour=limitvar(index); % Stop 
        end
    end
    end
end
