opt_train = {
   data = opt.train_data_path,
   dataBlur = opt.train_data_blurpath,
   dataset = 'folder',       -- imagenet / lsun / folder
   --dataset2 = 'folder',       -- imagenet / lsun / folder
   batchSize = opt.batchSize,
   loadSize = 132,
   --loadSize = 256,
   loadBlurSize = 128,
   nThreads = opt.threads,           -- #  of data loading threads to use
  labels_path = opt.train_labels_path,
   num_traj_pts = 105
}


opt_test = {
   data = opt.test_data_path,
   dataBlur = opt.test_data_blurpath,
   dataset = 'folder',       -- imagenet / lsun / folder
   batchSize = opt.batchSize,
   loadSize = 132,
   loadBlurSize = 128,
   nThreads = opt.threads,           -- #  of data loading threads to use
   labels_path = opt.test_labels_path,
   num_traj_pts = 105
}



-- creating data loaders
local DataLoader = paths.dofile('../utils/data.lua')
trainData = DataLoader.new(opt_train.nThreads, opt_train.dataset, opt_train)
testData = DataLoader.new(opt_test.nThreads, opt_test.dataset, opt_test)
--img_mean = torch.load(opt.img_mean_path)
