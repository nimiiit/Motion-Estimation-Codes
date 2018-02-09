local filename = 'results/model.net'

if io.open(filename,'r') and opt.load == 1 then
	print('File found')
	model = torch.load(filename)
else
	print('Creating a new model')
	local ksize =5
      	local step = 1
	local p = 0.25
        local zp=2
	if opt.model == 'SimpleCNN' then  
		  
		model = nn.Sequential()
		model:add(nn.SpatialConvolution(3,64,ksize,ksize,step,step,zp,zp))--128
		model:add(nn.ReLU())
		
		       		
		model:add(nn.SpatialConvolution(64,128,ksize,ksize,2,2, zp,zp)) ---64
                model:add(nn.SpatialBatchNormalization(128))
		model:add(nn.ReLU())
		                      	
		
		model:add(nn.SpatialConvolution(128,128,ksize,ksize,2,2,zp,zp)) ---32
                model:add(nn.SpatialBatchNormalization(128))
		model:add(nn.ReLU())
			

		model:add(nn.SpatialConvolution(128,256,ksize,ksize,2,2,zp,zp)) --16
                model:add(nn.SpatialBatchNormalization(256))
		model:add(nn.ReLU())
		
                model:add(nn.SpatialConvolution(256,256,ksize,ksize,2,2,zp,zp)) --8
                model:add(nn.SpatialBatchNormalization(256))
		model:add(nn.ReLU())    
			
                model:add(nn.View(8*8*256))
                model:add(nn.Linear(8*8*256, 512))
                model:add(nn.Tanh())
                model:add(nn.Linear(512,105))
        	model:add(nn.SoftMax())   
                model:add(nn.L1Penalty(.1))


	
	else
		error('Invalid model specified')
	end
end

print('Model architecture')
print(model)

criterion = nn.MSECriterion()
criterion1 = nn.AbsCriterion()
