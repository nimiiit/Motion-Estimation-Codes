require 'torch'
require 'xlua'    
require 'optim' 
require 'image'
require 'nn' 
require 'nngraph'
require 'math'



cmd = torch.CmdLine()
cmd:option('-seed', 1, 'fixed input seed for repeatable experiments')
cmd:option('-threads', 4, 'number of threads')
cmd:option('-save', 'results/', 'subdirectory to save/log experiments in')
cmd:option('-learningRate', 0.0005, 'learning rate at t=0')
cmd:option('-batchSize', 64, 'mini-batch size (1 = pure stochastic)')
cmd:option('-weightDecay', 1e-4, 'weight decay (SGD only)')
cmd:option('-load', 1, 'option for loading')
cmd:option('-momentum', 0.9, 'momentum (SGD only)')
cmd:option('-lrd', 1e-4, 'Learning rate decay')
cmd:option('-nepochs', 100, 'Number of epochs to train')
cmd:option('-type', 'cuda', 'type: double | float | cuda')
cmd:option('-ngpu', 1, 'GPU number to use')
cmd:option('-model', 'SimpleCNN', 'Model to use| Options: SimpleCNN, SimpleCNN_withBN')
cmd:option('-train_data_path', './Train/train/', 'Training data path')
cmd:option('-train_data_blurpath', './Train/trainb/', 'Training data path')
cmd:option('-test_data_path', './Test/test/', 'Test data path')
cmd:option('-test_data_blurpath', './Test/testb/', 'Test data path')
cmd:option('-train_labels_path', 'MotionDataTrain.csv', 'Training label path')
cmd:option('-test_labels_path', 'MotionDataTest.csv', 'Test label path')
cmd:option('-img_mean_path', 'img_mean.dat', 'Test label path')
cmd:option('-erruse', 1, 'to use image error 0: only motion error 1:image+motion error')
cmd:text()
opt = cmd:parse(arg or {})

if opt.type == 'float' then
   torch.setdefaulttensortype('torch.FloatTensor')
elseif opt.type == 'cuda' then
   require 'cunn'
   require 'cutorch'
   require 'cudnn'
   torch.setdefaulttensortype('torch.CudaTensor')
   cutorch.setDevice(opt.ngpu)
end
torch.setnumthreads(opt.threads)
torch.manualSeed(opt.seed)

dofile 'data.lua'
dofile 'model.lua'
dofile 'train.lua'
dofile 'test.lua'

-- Log results to files
trainLogger = optim.Logger(paths.concat(opt.save, 'train.log'))
testLogger = optim.Logger(paths.concat(opt.save, 'test.log'))
trainiterLogger = optim.Logger(paths.concat(opt.save, 'trainiter.log'))
testiterLogger = optim.Logger(paths.concat(opt.save, 'testiter.log'))


if model then
   parameters,gradParameters = model:getParameters()
end

----------------------------------------------------------------------
print '==> configuring optimizer'

optimState = {
  learningRate = opt.learningRate,
  weightDecay = opt.weightDecay,
  momentum = opt.momentum,
  lrd = opt.lrd
}

if opt.type == 'cuda' then
   model = cudnn.convert(model, cudnn)
   model:cuda()
   criterion1:cuda()
criterion:cuda()
end

----------------------------------------------------------------------
print '==> training!'

for i=1,opt.nepochs do
   train(i)
  test()
collectgarbage();collectgarbage()
end
