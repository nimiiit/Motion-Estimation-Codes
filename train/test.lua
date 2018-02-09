


function test()
	local time = sys.clock()
	model:evaluate()
	
	local mserror = 0
	local count = 0
       
	for i = 1, testData:size(), opt_test.batchSize do
		xlua.progress(i, testData:size())
		input,inputb, __, target = testData:getBatch()
           
		--for i=1,input:size()[1] do
		--	input[i] = input[i] - img_mean
		--end
		--target = transform_targets(target)
		input, inputb,target = cast(input), cast(inputb),cast(target)
		local pred = model:forward(inputb)
                local f=0  
                if opt.erruse==1 then
                for j=1, opt_test.batchSize do
                local matA=torch.CudaTensor(3*128*128,105):mul(0)
                     local PIBY180=math.pi / 180
               local count=1
               for tx=-2,2,1 do
               for rz=-5,5,.5 do
               local ty=0
               local dst1= image.rotate(input[j]:float(), rz*PIBY180, 'bilinear')
               local dst=image.translate(dst1, tx, ty):cuda()
               matA[{{},count}]=torch.reshape(dst[{{},{3,130},{3,130}}],128*128*3)  
               count=count+1
               end
               end
                                  
                 local blurdata= matA * pred[j]
                local err1 = criterion:forward(torch.reshape(blurdata,3,128,128),inputb[j])
                
              f = f+ err1
         

               matA=nil
          
		end
             end
             local err2=criterion:forward(target,pred)
        testiterLogger:add{['% Testing iter Mean Squared Image and Motion Error'] = f/opt_test.batchSize, err2/opt_test.batchSize}
     		mserror = mserror+f/opt_test.batchSize +err2/opt_test.batchSize

	end
	mserror = mserror

	-- printing statistics
	time = sys.clock() - time
	time = time / testData:size()
	print("\n==> Time to test 1 sample = " .. (time*1000) .. 'ms')
	print("Validation Mean Squared Error = " .. mserror)
	testLogger:add{['% Validation Mean Squared Error'] = mserror}  
end
