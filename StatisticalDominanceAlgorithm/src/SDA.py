import sys
from PIL import Image
import numpy as np
from numba import njit

# Pharse of arguments
if len(sys.argv) == 1:
    print('''

Script performs the SDA algorithm for grayscale images.
Examples of usage:
python SDA.py -P "../res/wmh_plaques/A_XY27.png"
python SDA.py -P "../res/wmh_plaques/A_XY27.png" -N -R 25 -T 14 -Re 0 -Ne 0

-P [path to the input image] --> Path to the input image.
-N --> Negate the input image. (Default: no negation)
-R [positive integer] --> Size of the mask for the SDA. (Default: 25)
-T [positive integer] --> Threshold for the SDA. (Default: 14)
-Re [0/1/2/3] --> Type of the relationship (0: >=, 1: >, 2: <=, 3: <).
    (Default: >=)
-Ne [0/1/2] --> Type of the neighbourhood/mask (0: disc, 1: horizontal,
    2: vertical). (Default: disc)

    ''')
    quit()

path = ""
negateInputImage = False
radOfMask = 25
threshold = 14
relationship = 0
neighbourhood = 0

i = 1
while i<len(sys.argv):
    if sys.argv[i] == '-P':
        path = sys.argv[i+1]
        i += 2
    elif sys.argv[i] == '-N':
        negateInputImage = True
        i += 1
    elif sys.argv[i] == '-R':
        radOfMask = int(sys.argv[i+1])
        i += 2
    elif sys.argv[i] == '-T':
        threshold = int(sys.argv[i+1])
        i += 2
    elif sys.argv[i] == '-Re':
        relationship = int(sys.argv[i+1])
        i += 2
    elif sys.argv[i] == '-Ne':
        neighbourhood = int(sys.argv[i+1])
        i += 2
    else:
        i += 1

# Loading image as numpy array
image = Image.open(path)
inputImage = np.asarray(image)

# Negating input image
if negateInputImage:
    inputImage = 255-inputImage # negating inputImage

if neighbourhood == 1: # horizontal
    diaOfMask = 2*radOfMask + 1
    mask = np.zeros((diaOfMask, diaOfMask), dtype=np.uint8)
    mask[(radOfMask-radOfMask//2):(radOfMask+radOfMask//2), :] = 1

    cenCoordX = radOfMask
    cenCoordY = radOfMask
elif neighbourhood == 2: # vertical
    diaOfMask = 2*radOfMask + 1
    mask = np.zeros((diaOfMask, diaOfMask), dtype=np.uint8)
    mask[:, (radOfMask-radOfMask//2):(radOfMask+radOfMask//2)] = 1

    cenCoordX = radOfMask
    cenCoordY = radOfMask
else: # disc
    diaOfMask = 2*radOfMask + 1
    mask = np.zeros((diaOfMask, diaOfMask), dtype=np.uint8)
    for i in range(diaOfMask):
        for j in range(diaOfMask):
                if((i-radOfMask)*(i-radOfMask) + (j-radOfMask)*(j-radOfMask) <= radOfMask*radOfMask):
                        mask[i, j] = 1

    cenCoordX = radOfMask
    cenCoordY = radOfMask

# Algorithm SDA
if relationship == 1: # >
    @njit
    def SDA(inputImage, threshold, mask, cenCoordX, cenCoordY):
        outputImage = np.zeros(inputImage.shape, dtype=np.uint64)
        Sx = mask.shape[0] - cenCoordX - 1
        Sy = mask.shape[1] - cenCoordY - 1
        for x in range(cenCoordX, inputImage.shape[0]-Sx-1):
            for y in range(cenCoordY, inputImage.shape[1]-Sy-1):
                for i in range(-cenCoordX, Sx+1):
                    for j in range(-cenCoordY, Sy+1):
                        if inputImage[x+i, y+j] > inputImage[x, y] + threshold:
                            outputImage[x, y] += mask[cenCoordX+i, cenCoordY+j]

        # Normalization of the output image
        outputImageMax = outputImage.max()
        outputImage = outputImage*255
        outputImage = outputImage//outputImageMax
        outputImage = outputImage.astype(np.uint8)

        return outputImage
elif relationship == 2: # <=
    @njit
    def SDA(inputImage, threshold, mask, cenCoordX, cenCoordY):
        outputImage = np.zeros(inputImage.shape, dtype=np.uint64)
        Sx = mask.shape[0] - cenCoordX - 1
        Sy = mask.shape[1] - cenCoordY - 1
        for x in range(cenCoordX, inputImage.shape[0]-Sx-1):
            for y in range(cenCoordY, inputImage.shape[1]-Sy-1):
                for i in range(-cenCoordX, Sx+1):
                    for j in range(-cenCoordY, Sy+1):
                        if inputImage[x+i, y+j] <= inputImage[x, y] + threshold:
                            outputImage[x, y] += mask[cenCoordX+i, cenCoordY+j]

        # Normalization of the output image
        outputImageMax = outputImage.max()
        outputImage = outputImage*255
        outputImage = outputImage//outputImageMax
        outputImage = outputImage.astype(np.uint8)

        return outputImage
elif relationship == 3: # <
    @njit
    def SDA(inputImage, threshold, mask, cenCoordX, cenCoordY):
        outputImage = np.zeros(inputImage.shape, dtype=np.uint64)
        Sx = mask.shape[0] - cenCoordX - 1
        Sy = mask.shape[1] - cenCoordY - 1
        for x in range(cenCoordX, inputImage.shape[0]-Sx-1):
            for y in range(cenCoordY, inputImage.shape[1]-Sy-1):
                for i in range(-cenCoordX, Sx+1):
                    for j in range(-cenCoordY, Sy+1):
                        if inputImage[x+i, y+j] < inputImage[x, y] + threshold:
                            outputImage[x, y] += mask[cenCoordX+i, cenCoordY+j]

        # Normalization of the output image
        outputImageMax = outputImage.max()
        outputImage = outputImage*255
        outputImage = outputImage//outputImageMax
        outputImage = outputImage.astype(np.uint8)

        return outputImage
else: # >=
    @njit
    def SDA(inputImage, threshold, mask, cenCoordX, cenCoordY):
        outputImage = np.zeros(inputImage.shape, dtype=np.uint64)
        Sx = mask.shape[0] - cenCoordX - 1
        Sy = mask.shape[1] - cenCoordY - 1
        for x in range(cenCoordX, inputImage.shape[0]-Sx-1):
            for y in range(cenCoordY, inputImage.shape[1]-Sy-1):
                for i in range(-cenCoordX, Sx+1):
                    for j in range(-cenCoordY, Sy+1):
                        if inputImage[x+i, y+j] >= inputImage[x, y] + threshold:
                            outputImage[x, y] += mask[cenCoordX+i, cenCoordY+j]

        # Normalization of the output image
        outputImageMax = outputImage.max()
        outputImage = outputImage*255
        outputImage = outputImage//outputImageMax
        outputImage = outputImage.astype(np.uint8)

        return outputImage

outputImage = SDA(inputImage, threshold, mask, cenCoordX, cenCoordY)

# Result of the SDA
imageResult = Image.fromarray(outputImage)
imageResult.show()
imageResult.save("result.png")
