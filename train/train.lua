
local inputs, inputsb,targets, mserror


function cast(x)
	if opt.type == 'double' then
		x = x:double()
	elseif opt.type == 'cuda' then
		x = x:cuda()
	else
		x = x:float()
	end
	return x
end



local feval = function(x)

	if x ~= parameters then
		parameters:copy(x)
	end
	gradParameters:zero()

	local output = model:forward(inputsb)
        local  f =0
        local df_do=torch.CudaTensor(opt.batchSize,105)
        if opt.erruse==1 then
        for j=1,opt.batchSize do
        
         local matA=torch.CudaTensor(3*128*128,105):mul(0)
                     local PIBY180=math.pi / 180
               local count=1
               for tx=-2,2,1 do
               for rz=-5,5,.5 do
               local ty=0
               local dst1= image.rotate(inputs[j]:float(), rz*PIBY180, 'bilinear')
               local dst=image.translate(dst1, tx, ty):cuda()
               matA[{{},count}]=torch.reshape(dst[{{},{3,130},{3,130}}],128*128*3)  
               count=count+1
               end
               end
                                  
          local blurdata= matA * output[j]
          local err1 = criterion:forward(torch.reshape(blurdata,3,128,128),inputsb[j])
                f = f+ err1
          df_do[{j,{}}] = ((matA:t() * torch.reshape(inputsb[j],128*128*3):mul(-1))+(matA:t() * matA * output[j]))
          matA=nil
           end 
        end
	local err2=criterion:forward(output,targets)
        local df_d1=criterion:backward(output,targets)
       	model:backward(inputsb, .01*df_d1+df_do)
        err=f+err2
	mserror = mserror+f/opt.batchSize+err2/opt.batchSize
       trainiterLogger:add{['% Training iter graderror& Motion Error & Mean Squared Image '] = f/opt.batchSize, err2/opt.batchSize}
	return err, gradParameters
end




function train(iter_num)

   local time = sys.clock()
	mserror = 0
	local count = 0
	model:training()
	
	
	print("==> online epoch # " .. iter_num .. ' [batchSize = ' .. opt.batchSize .. ']')

	for i = 1, trainData:size() , opt.batchSize do --
		xlua.progress(i, trainData:size())
		inputs,inputsb, __, targets = trainData:getBatch()

		inputs,inputsb,targets = cast(inputs),cast(inputsb),cast(targets)
 		optim.adam(feval, parameters, optimState)
		count = count+1
	end

	-- Printing statistics
	
	time = sys.clock() - time
	time = time / trainData:size()
	print("\n==> Time to learn 1 sample = " .. (time*1000) .. 'ms')

	mserror = mserror/count
	print("Training Mean Squared Error = " .. mserror)
	trainLogger:add{['% Training Mean Squared Error'] = mserror}
   
	-- save/log current net
	
	local filename = paths.concat(opt.save, 'model.net')
	os.execute('mkdir -p ' .. sys.dirname(filename))
	print('==> saving model to '..filename)
	torch.save(filename, model:clearState())

	if iter_num%10 == 1 then
		local filename = paths.concat(opt.save, 'model_'..iter_num..'.net')
		os.execute('mkdir -p ' .. sys.dirname(filename))
		print('==> saving model to '..filename)
		torch.save(filename, model:clearState())
	end
end
