from __main__ import vtk, qt, ctk, slicer
import numpy as np
try:
  from numba import njit
except:
  slicer.util.pip_install('numba')
  from numba import njit

# This class contains a metadata related to the module.
class scriptedModule:
  def __init__(self, parent):
    parent.title = "scriptedModule"
    parent.categories = ["Examples"]
    parent.dependencies = []
    parent.contributors = ["Andrzej Jasek (AGH)",
    "Adam Piórkowski (AGH)"]
    parent.helpText = """
    Statistical Dominance Algorithm
    """
    parent.acknowledgementText = """
    Scripted extension performing SDA on digital grayscale
    image (see https://home.agh.edu.pl/~pioro/sda/)."""
    self.parent = parent

# This class implements the module.
class scriptedModuleWidget:
  def __init__(self, parent = None):
    if not parent:
      self.parent = slicer.qMRMLWidget()
      self.parent.setLayout(qt.QVBoxLayout())
      self.parent.setMRMLScene(slicer.mrmlScene)
    else:
      self.parent = parent
    self.layout = self.parent.layout()
    if not parent:
      self.setup()
      self.parent.show()

  # Method in which one defines GUI.
  def setup(self):
    # Collapsible button in which one can create GUI.
    self.collapsibleButton = ctk.ctkCollapsibleButton()
    self.collapsibleButton.text = "Statistical Dominance Algorithm"
    self.layout.addWidget(self.collapsibleButton)

    # Layout within the collapsible button.
    self.formLayout = qt.QFormLayout(self.collapsibleButton)

    ## Defining the volume selectors.
    # Defining the horizontal frame whick contains label and selector.
    self.inputFrame = qt.QFrame(self.collapsibleButton)
    self.inputFrame.setLayout(qt.QHBoxLayout())
    self.formLayout.addWidget(self.inputFrame)
    # Label
    self.inputLabel = qt.QLabel("Input Volume: ", self.inputFrame)
    self.inputFrame.layout().addWidget(self.inputLabel)
    # Selector
    self.inputSelector = slicer.qMRMLNodeComboBox(self.inputFrame)
    self.inputSelector.nodeTypes = ( ("vtkMRMLScalarVolumeNode"), "" )
    self.inputSelector.addEnabled = False
    self.inputSelector.removeEnabled = False
    self.inputSelector.setMRMLScene( slicer.mrmlScene )
    self.inputFrame.layout().addWidget(self.inputSelector)

    # Negative ChechBox
    self.negativeCheck = qt.QCheckBox("Negative (dark background)", self.collapsibleButton)
    self.negativeCheck.toolTip = "When checked, negate input image."
    self.negativeCheck.checked = True
    self.formLayout.addWidget(self.negativeCheck)

    # R LineEdit
    # Defining the horizontal frame whick contains label and QLineEdit.
    self.rFrame = qt.QFrame(self.collapsibleButton)
    self.rFrame.setLayout(qt.QHBoxLayout())
    self.formLayout.addWidget(self.rFrame)
    # Label
    self.rLabel = qt.QLabel("R: ", self.rFrame)
    self.rFrame.layout().addWidget(self.rLabel)
    # QLineEdit
    self.rLineEdit = qt.QLineEdit(self.rFrame)
    self.rLineEdit.toolTip = "Set radious size of the mask."
    self.rLineEdit.setFixedWidth(40)
    self.rLineEdit.setInputMask("00D")
    self.rLineEdit.setValidator(qt.QIntValidator())
    self.rLineEdit.setText(25)
    self.rFrame.layout().addWidget(self.rLineEdit)

    # threshold LineEdit
    # Defining the horizontal frame whick contains label and QLineEdit.
    self.thresholdFrame = qt.QFrame(self.collapsibleButton)
    self.thresholdFrame.setLayout(qt.QHBoxLayout())
    self.formLayout.addWidget(self.thresholdFrame)
    # Label
    self.thresholdLabel = qt.QLabel("threshold: ", self.thresholdFrame)
    self.thresholdFrame.layout().addWidget(self.thresholdLabel)
    # QLineEdit
    self.thresholdLineEdit = qt.QLineEdit(self.thresholdFrame)
    self.thresholdLineEdit.toolTip = "Set threshold."
    self.thresholdLineEdit.setFixedWidth(40)
    self.thresholdLineEdit.setInputMask("00D")
    self.thresholdLineEdit.setValidator(qt.QIntValidator())
    self.thresholdLineEdit.setText(14)
    self.thresholdFrame.layout().addWidget(self.thresholdLineEdit)

    # relationship ComboBox
    # Defining the horizontal frame whick contains label and QLineEdit.
    self.relationshipFrame = qt.QFrame(self.collapsibleButton)
    self.relationshipFrame.setLayout(qt.QHBoxLayout())
    self.formLayout.addWidget(self.relationshipFrame)
    # Label
    self.relationshipLabel = qt.QLabel("relationship: ", self.relationshipFrame)
    self.relationshipFrame.toolTip = "Set relationship."
    self.relationshipFrame.layout().addWidget(self.relationshipLabel)
    # QComboBox
    self.relationshipComboBox = qt.QComboBox(self.relationshipFrame)
    self.relationshipComboBox.addItems([">=", ">", "<=", "<"])
    self.relationshipComboBox.setFixedSize(60, 20)
    self.relationshipFrame.layout().addWidget(self.relationshipComboBox)

    # neighbourhood ComboBox
    # Defining the horizontal frame whick contains label and QLineEdit.
    self.neighbourhoodFrame = qt.QFrame(self.collapsibleButton)
    self.neighbourhoodFrame.setLayout(qt.QHBoxLayout())
    self.formLayout.addWidget(self.neighbourhoodFrame)
    # Label
    self.neighbourhoodLabel = qt.QLabel("neighbourhood: ", self.neighbourhoodFrame)
    self.neighbourhoodFrame.toolTip = "Set neighbourhood."
    self.neighbourhoodFrame.layout().addWidget(self.neighbourhoodLabel)
    # QComboBox
    self.neighbourhoodComboBox = qt.QComboBox(self.neighbourhoodFrame)
    self.neighbourhoodComboBox.addItems(["disc", "horizontal", "vertical"])
    self.neighbourhoodComboBox.setFixedSize(100, 20)
    self.neighbourhoodFrame.layout().addWidget(self.neighbourhoodComboBox)

    # Apply button
    self.applyButton = qt.QPushButton("Apply SDA", self.collapsibleButton)
    self.applyButton.toolTip = "Apply SDA on the image."
    self.formLayout.addWidget(self.applyButton)
    self.applyButton.connect('clicked(bool)', self.onApply)

    # Add vertical spacer which prevents uncollapsed button from centering.
    self.layout.addStretch(1)

  def onApply(self):
    inputVolume = self.inputSelector.currentNode()
    if not inputVolume:
      qt.QMessageBox.critical(
          slicer.util.mainWindow(),
          'SDA', 'Input volume is required for the SDA.')
      return

    # Input node
    inputImage = slicer.util.array(inputVolume.GetName())

    # Input params
    negateInputImage = self.negativeCheck.checked
    radOfMask = int(self.rLineEdit.text)
    threshold = int(self.thresholdLineEdit.text)
    relationship = self.relationshipComboBox.currentIndex
    neighbourhood = self.neighbourhoodComboBox.currentIndex

    # Negating input image
    if negateInputImage:
      inputImage = 255-inputImage # odwrócenie kolorów zdjęcia

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

    # Cloning the input node for storing the output image
    shNode = slicer.vtkMRMLSubjectHierarchyNode.GetSubjectHierarchyNode(slicer.mrmlScene)
    itemIDToClone = shNode.GetItemByDataNode(inputVolume)
    clonedItemID = slicer.modules.subjecthierarchy.logic().CloneSubjectHierarchyItem(shNode, itemIDToClone)
    outputVolume = shNode.GetItemDataNode(clonedItemID)

    # Applying algorithm
    outputImage = slicer.util.array(outputVolume.GetName())
    for i in range(inputImage.shape[0]):
      outputImage[i] = SDA(inputImage[i], threshold, mask, cenCoordX, cenCoordY)

    # Make the output volume appear in all the slice views
    selectionNode = slicer.app.applicationLogic().GetSelectionNode()
    selectionNode.SetReferenceActiveVolumeID(outputVolume.GetID())
    slicer.app.applicationLogic().PropagateVolumeSelection(0)