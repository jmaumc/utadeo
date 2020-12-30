from __future__ import print_function
import os
import sys
import cv2
import numpy as np

def preProcImages(path, dest):
	for filePath in sorted(os.listdir(path)):
		fileExt = os.path.splitext(filePath)[1]
		if fileExt in [".jpg", ".jpeg"]:
			imagePath = os.path.join(path, filePath)
			im = cv2.imread(imagePath)
			im = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
			im = cv2.resize(im,(100,100))
			imagePath = os.path.join(dest, filePath)
			cv2.imwrite(imagePath,im)

    
def createDataMatrix(images):
	numImages = len(images)
	sz = images[0].shape
	data = np.zeros((numImages, sz[0] * sz[1] * sz[2]), dtype=np.float32)
	for i in range(0, numImages):
		image = images[i].flatten()
		data[i,:] = image

	return data


def readPreprocImages(path):
	images = []
	for filePath in sorted(os.listdir(path)):
		fileExt = os.path.splitext(filePath)[1]
		if fileExt in [".jpg", ".jpeg"]:
			imagePath = os.path.join(path, filePath)		
			im = cv2.imread(imagePath)
			if im is None :
				print("image:{} not read properly".format(imagePath))
			else :
				im = np.float32(im)/255.0
				images.append(im)
				imFlip = cv2.flip(im, 1);
				images.append(imFlip)

	numImages = int(len(images) / 2)

	if numImages == 0 :
		print("No images found")
		sys.exit(0)

	return images


def createNewFace(*args):
	output = averageFace
	for i in range(0, NUM_EIGEN_FACES):
		sliderValues[i] = cv2.getTrackbarPos("Weight" + str(i), "Trackbars");
		weight = sliderValues[i] - MAX_SLIDER_VALUE/2
		output = np.add(output, eigenFaces[i] * weight)

	output = cv2.resize(output, (0,0), fx=2, fy=2)
	cv2.imshow("Result", output)

def resetSliderValues(*args):
	for i in range(0, NUM_EIGEN_FACES):
		cv2.setTrackbarPos("Weight" + str(i), "Trackbars", int(MAX_SLIDER_VALUE/2));
	createNewFace()

if __name__ == '__main__':

	NUM_EIGEN_FACES = 10
	MAX_SLIDER_VALUE = 255

	dirName = "images"
	destDirName = "images_preproc"
	eigfacDirName = "eigenfaces"

	preProcImages(dirName, destDirName)
	
	images = readPreprocImages(destDirName)
	
	sz = images[0].shape
	print(sz)

	data = createDataMatrix(images)

	mean, eigenVectors = cv2.PCACompute(data, mean=None, maxComponents=NUM_EIGEN_FACES)

	averageFace = mean.reshape(sz)

	eigenFaces = []; 

	i=1;
	for eigenVector in eigenVectors:
		eigenFace = eigenVector.reshape(sz)
		im = np.float32(eigenFace)*255.0
		im = np.uint8(im)
		imagePath = os.path.join(eigfacDirName, "EigenFace"+str(i)+".jpg")
		cv2.imwrite(imagePath,im)
		eigenFaces.append(eigenFace)
		i = i+1

	cv2.namedWindow("Result", cv2.WINDOW_AUTOSIZE)
	
	output = cv2.resize(averageFace, (0,0), fx=2, fy=2)
	im = np.float32(averageFace)*255.0
	im = np.uint8(im)
	print(im)
	cv2.imwrite("Mean.jpg",im)
	cv2.imshow("Result", output)
	
	cv2.namedWindow("Trackbars", cv2.WINDOW_AUTOSIZE)

	sliderValues = []
	
	for i in range(0, NUM_EIGEN_FACES):
		sliderValues.append(int(MAX_SLIDER_VALUE/2))
		cv2.createTrackbar( "Weight" + str(i), "Trackbars", int(MAX_SLIDER_VALUE/2), MAX_SLIDER_VALUE, createNewFace)
	
	cv2.setMouseCallback("Result", resetSliderValues);
	
	cv2.waitKey(0)
	cv2.destroyAllWindows()
	