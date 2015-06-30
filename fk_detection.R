library(doMC)
registerDoMC()

data.dir   <- '/Users/Copper/Documents/Prema/Prema_Folder/Kaggle/Facial_Keypoints_Detection/'
train.file <- paste0(data.dir, 'training.csv')
test.file  <- paste0(data.dir, 'test.csv')

d.train = read.csv(train.file, stringsAsFactors=F)
d.test  = read.csv(test.file, stringsAsFactors=F) 

#get an idea of fields and data
str(d.train)


#crate a new field in training data
im.train      = d.train$Image
d.train$Image = NULL

#convert im.train to a vector of integers
im.train <- foreach(im = im.train, .combine=rbind) %dopar% 
            {
              as.integer(unlist(strsplit(im, " ")))
            }

#study resulting data
str(im.train)

#crate a new field in the test data
im.test      = d.test$Image
d.test$Image = NULL

#convert im.test to a vector of integers
im.test <- foreach(im = im.test, .combine=rbind) %dopar% 
{
  as.integer(unlist(strsplit(im, " ")))
}

#study resulting data
str(im.test)

#It’s a good idea to save the data as a R data file at this point, 
#so you don't have to repeat this process again. 
#We save all four variables into the fkd.Rd file:
save(d.train, im.train, d.test, im.test, file='fkd.Rd')

#We can reload them at any time with the following command:
load('fkd.Rd')

#Now that the data is loaded let's start looking at the images. 
#Did you notice how the long string comprised of 9216 integers? 
#That’s because each image is a vector of 96*96 pixels (96*96 = 9216).
#To visualize each image, we thus need to first convert these 9216 integers into a 96x96 matrix:
#visualize each image
im = matrix(data=rev(im.train[1,]), nrow=96, ncol=96)

#im.train[1,] returns the first row of im.train, which corresponds to the first training image. 
#rev reverse the resulting vector to match the interpretation of R's image function
#(which expects the origin to be in the lower left corner). 
#To visualize the image we use R's image function:
image(1:96, 1:96, im, col=gray((0:255)/255))

