# Motion-Estimation-Codes
Training and testing code for estimating global camera motion from a single space-variantly blurred frame.
## Data generation:
    * Go to CameraMotionGeneration folder in train. In the main.m make the changes for the camera motion. You can set the limit of 
         tx,ty and rz and create connected camera motion and save it as a csv file. (eg. motion_rot.csv). 
    *  Run the create_blurred_images.lua in train folder and by properly setting the camera  pose size and the camera motion range. 
         Save the data and motion in a new folder (preferably ./Train/train (for clean data) and ./Train/trainb (for blurred data), 
         MotionDataTrain.csv (corresponding camera motion)).
## Training :
         Run run.lua by giving the train and validation data path correctly. Error at each iteration and models will be saved in 
         results folder.
## Testing : 
     1  Run valid.lua provided in the train folder. The trained model for camera motion in tx=[-2:2] and rz=[-5:.5:5] degrees is 
        provided in the trained_model folder.
     2  For testing you can use testb folder with blurred images and the trained model in the valid.lua.
     3  You can train your own model and check as well.
         

         
      

