from PIL import Image
import numpy as np

# input data
outputImagePath = "outputImage.png" # path to output SDA image
comparativeImagePath = "comparativeImage.png" # path to comparative SDA image
resultImagePath = "resultImage.png" # path to create differential image

# loading output SDA image and comparative SDA image
outputImageRaw = Image.open(outputImagePath)
outputImage = np.asarray(outputImageRaw)
comparativeImageRaw = Image.open(comparativeImagePath)
comparativeImage = np.asarray(comparativeImageRaw)

# creating comparison (differential) image
shapeComparativeImage = comparativeImage.shape
comparison = np.zeros(shapeComparativeImage, dtype=np.uint8)
for i in range(shapeComparativeImage[0]):
    for j in range(shapeComparativeImage[1]):
        if(outputImage[i, j] >= comparativeImage[i, j]):
            comparison[i, j] = outputImage[i, j] - comparativeImage[i, j]
        else:
            comparison[i, j] = comparativeImage[i, j] - outputImage[i, j]

# results
resultImage = Image.fromarray(comparison)
resultImage.show()
resultImage.save(resultImagePath)

print(f"max: {np.max(comparison)}")
print(f"average: {np.average(comparison)}")
