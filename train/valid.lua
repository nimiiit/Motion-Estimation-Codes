require 'torch'
require 'nn'
require 'cunn'
require 'cutorch'
require 'image'
require 'cudnn'
require 'math'



cutorch.setDevice(1)

torch.setdefaulttensortype('torch.FloatTensor')


-- function to write to a file

function writeTensor( infilename, intensor )
  local infile = io.open(infilename,'w')
  for i = 1,intensor:size(1) do
    for j = 1,(intensor:size(2)-1) do
      infile:write(intensor[i][j])
      infile:write(',')
    end
    infile:write(intensor[i][-1])
    infile:write('\n')
    infile:flush() 
  end
  infile:close()
end
img_size=128

motion_size=105


timer = torch.Timer()
local predweigths=torch.CudaTensor(10,motion_size)
network ='./trained_model/model.net'

 local model=nil;
 local model=torch.load(network)
 model:evaluate()

local inputbs=torch.CudaTensor(10,3,img_size,img_size)
   -- test over test data
   --print('==> testing on test set:')
   for l =1,10 do 
     inputbs[l] = image.load('./testb/'..l..'.png'):cuda()    

   end
print('Time elapsed : ' .. timer:time().real .. ' seconds')
  predweigths = model:forward(inputbs)
writeTensor( 'MotionDataEst.csv', predweigths:float())




