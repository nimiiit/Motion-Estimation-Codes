require 'torch'
require 'image'
require 'nn' 
require 'math'
require 'cunn'
require 'cutorch'


torch.setdefaulttensortype('torch.FloatTensor')
  cutorch.setDevice(1)

-------------
local function split(str, sep)
  sep = sep or ','
  fields={}
  local matchfunc = string.gmatch(str, "([^"..sep.."]+)")
  if not matchfunc then return {str} end
  for str in matchfunc do
      table.insert(fields, str)
  end
  return fields
end


-- csv read function

function readCSV(filename,ht,wid)
  local csv_ten = torch.Tensor(ht,wid)
  local file = io.open(filename,"r")
  local ln=1
  for line in file:lines() do 
    if ln>ht then break end
    temp = split(line,",")
    for i=1,wid do
      csv_ten[ln][i] = tonumber(temp[i])
    end
    ln=ln+1
  end
  file:close()
  return csv_ten
end

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
-------------------------------------

  ----------------------------------------------
local weights_all= readCSV('./CameraMotionGeneration/motion.csv',200000,105)
local index1=1
local index=1
local img_size1=132
local img_size=128
local weight_save=torch.Tensor(170000,105)
local inpg=torch.Tensor(3,128,128)
for t =1, 17000 do
    local input=torch.Tensor(3,img_size1,img_size1)
      input= image.load('./IMAGES/'..t..'.jpg')
      input:cuda()
          for k=1,10 do
               local weights=weights_all[index1]
                      weight_save[index]=weights
                      weights=weights:cuda()
                     matA=torch.CudaTensor(3*128*128,105):mul(0)
                     local PIBY180=math.pi / 180
               local count=1
               for tx=-2,2,1 do
               for rz=-5,5,.5 do
               local ty=0
               local dst1= image.rotate(input:float(), rz*PIBY180, 'bilinear')
               local dst=image.translate(dst1, tx, ty):cuda()
               matA[{{},count}]=torch.reshape(dst[{{},{3,130},{3,130}}],img_size*img_size*3)  
               count=count+1
               end
               end
          local out=matA*weights:div(torch.sum(weights))
         local out1=torch.reshape(out,3,128,128)
        image.save('./Train/trainb/'.. index .. '.png',    out1:float())
        image.save('./Train/train/'.. index .. '.png', input:float())
       index1=index1+1
      index=index+1

   end
print(t)
end


writeTensor( 'MotionDataTrain.csv', weight_save:float())
