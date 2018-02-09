# Motion-Estimation-Codes
Training and testing code for estimating global camera motion from a single space-variantly blurred frame.
## Data generation:
    * Go to CameraMotionGeneration folder in train. In the main.m make the changes for the camera motion. You can set the limit of 
         tx,ty and rz and create connected camera motion and save it as a csv file. (eg. motion_rot.csv). 
    * Run the create_blurred_images.lua in train folder and by properly setting the camera  pose size and the camera motion       range. 
    * Save the data and motion in a new folder (preferably ./Train/train (for clean data) and ./Train/trainb (for blurred data), 
         MotionDataTrain.csv (corresponding camera motion)).
## Training :
         Run run.lua by giving the train and validation data path correctly. Error at each iteration and models will be saved in 
         results folder.
## Testing : 
     *  Run valid.lua provided in the train folder. The trained model for camera motion in tx=[-2:2] and rz=[-5:.5:5] degrees is 
        provided in the trained_model folder.
     *  For testing you can use testb folder with blurred images and the trained model in the valid.lua.
     *  You can train your own model and check as well.
     
# Image Formation Model
 The image formed due to the non-uniform motion of camera over the exposure time can be modelled as 
 * <img src="https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/blurformation.png" alt="equa" width="100" height="30">
 * S is the camera pose space (in our training we used S as tx and rz motion alone and totalling to 105 poses).
 * w_i is the fraction of time camera spend in the ith pose and H_i is the warping matrix.
 * **The blurred image is a weighted sum of warped instances of a clean image**
  <p align="center">
  <img src="https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/imageformationmodel.jpg" alt="Image formation"  width="200" height="200">
   </p>
   
   # Results

| Input | GT Motion | Blurred Image | Estimated Motion | Deblurred O/p| Ordered Motion |
|-------------------|-------------------------|---------------------|--------------------|------------------|-------------|
|![alt-text-1]( https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/Input.png "Clean Reference")|  <img src="https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/original.png" alt="GT motion"  width="120" height="120"> | ![alt-text-3](https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/inp4.png "Blurred Image") | <img src="https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/estimated.png" alt="Estimated Motion"  width="120" height="120"> |  ![alt-text-5](https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/deblr4.png "Deblurred Result") | <img src="https://github.com/nimiiit/Motion-Estimation-Codes/blob/master/ordered.png" alt="Ordered Motion"  width="120" height="120"> |



         
      

