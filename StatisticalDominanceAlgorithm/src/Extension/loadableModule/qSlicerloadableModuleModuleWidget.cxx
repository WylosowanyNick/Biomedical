/*==============================================================================

  Program: 3D Slicer

  Portions (c) Copyright Brigham and Women's Hospital (BWH) All Rights Reserved.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

==============================================================================*/

// Qt includes
#include <QDebug>

// VTK includes
#include <vtkNew.h>

// Slicer includes
#include "qSlicerloadableModuleModuleWidget.h"
#include "ui_qSlicerloadableModuleModuleWidget.h"

// MRML includes
#include <vtkMRMLNode.h>
#include <vtkMRMLVolumeNode.h>
#include <vtkDataSet.h>
#include <vtkImageData.h>

#include <iostream>
#include <vtkIndent.h>

//-----------------------------------------------------------------------------
/// \ingroup Slicer_QtModules_ExtensionTemplate
class qSlicerloadableModuleModuleWidgetPrivate: public Ui_qSlicerloadableModuleModuleWidget
{
public:
  qSlicerloadableModuleModuleWidgetPrivate();
};

//-----------------------------------------------------------------------------
// qSlicerloadableModuleModuleWidgetPrivate methods

//-----------------------------------------------------------------------------
qSlicerloadableModuleModuleWidgetPrivate::qSlicerloadableModuleModuleWidgetPrivate()
{
}

//-----------------------------------------------------------------------------
// qSlicerloadableModuleModuleWidget methods

//-----------------------------------------------------------------------------
qSlicerloadableModuleModuleWidget::qSlicerloadableModuleModuleWidget(QWidget* _parent)
  : Superclass( _parent )
  , d_ptr( new qSlicerloadableModuleModuleWidgetPrivate )
{
}

//-----------------------------------------------------------------------------
qSlicerloadableModuleModuleWidget::~qSlicerloadableModuleModuleWidget()
{
}

//-----------------------------------------------------------------------------
void qSlicerloadableModuleModuleWidget::setup()
{
  Q_D(qSlicerloadableModuleModuleWidget);
  d->setupUi(this);
  this->Superclass::setup();

  connect(d->ApplyButton, SIGNAL(clicked()),
    this, SLOT(onApply()));
}

//-----------------------------------------------------------------------------
void qSlicerloadableModuleModuleWidget::onApply()
{
  Q_D(qSlicerloadableModuleModuleWidget);

  typedef unsigned char inputImageType;
  typedef unsigned long long processImageType;

  // Raw input image
  vtkMRMLVolumeNode* inputVolumeNode = vtkMRMLVolumeNode::SafeDownCast(
      d->InputNodeComboBox->currentNode());
  vtkImageData* rawInputImage = inputVolumeNode->GetImageData();

  // Input image
  int dims[3];
  rawInputImage->GetDimensions(dims);
  vtkImageData* inputImage = vtkImageData::New();
  inputImage->SetDimensions(dims);
  inputImage->AllocateScalars(VTK_UNSIGNED_CHAR, 1);

  // Possible negation of the input image
  if (d->NegativeCheckBox->isChecked())
  {
      for(int i = 0; i < dims[0]; i++)
      for(int j = 0; j < dims[1]; j++)
      for(int k = 0; k < dims[2]; k++)
      {
          auto rawInput = (inputImageType*)rawInputImage->GetScalarPointer(i, j, k);
          auto input = (inputImageType*)inputImage->GetScalarPointer(i, j, k);
          *input = 255-*rawInput;
      }
  }
  else
  {
      for (int i = 0; i < dims[0]; i++)
      for (int j = 0; j < dims[1]; j++)
      for (int k = 0; k < dims[2]; k++)
      {
          auto rawInput = (inputImageType*)rawInputImage->GetScalarPointer(i, j, k);
          auto input = (inputImageType*)inputImage->GetScalarPointer(i, j, k);
          *input = *rawInput;
      }
  }

  // Defining the appropriate masks
  const int radious = d->RadiousSpinBox->value();
  const int diameter = 2 * radious + 1;
  int** mask = new int* [diameter];
  for (int i = 0; i < diameter; i++)
      mask[i] = new int[diameter];
  for (int i = 0; i < diameter; i++)
      for (int j = 0; j < diameter; j++)
          mask[i][j] = 0;

  int cenCoordX, cenCoordY;
  if (d->HorizontalRadioButton->isChecked())
  {
      for (int i = radious / 2; i < radious + radious / 2; i++)
          for (int j = 0; j < diameter; j++)
              mask[i][j] = 1;

      cenCoordX = radious;
      cenCoordY = radious;
  }
  else if (d->VerticalRadioButton->isChecked())
  {
      for (int i = 0; i < diameter; i++)
          for (int j = radious / 2; j < radious + radious / 2; j++)
              mask[i][j] = 1;

      cenCoordX = radious;
      cenCoordY = radious;
  }
  else // disc
  {
      for (int i = 0; i < diameter; i++)
          for (int j = 0; j < diameter; j++)
              if ((i - radious) * (i - radious) + (j - radious) * (j - radious) <= radious * radious)
                  mask[i][j] = 1;

      cenCoordX = radious;
      cenCoordY = radious;
  }

  // Definition of the processing image
  vtkImageData* processImage = vtkImageData::New();
  processImage->SetDimensions(dims);
  processImage->AllocateScalars(VTK_UNSIGNED_LONG_LONG, 1);

  // SDA Algorithm
  if (d->GreaterOrEqualRadioButton->isChecked())
  {
      int threshold = d->ThreholdSpinBox->value();
      int Sx = diameter - cenCoordX - 1;
      int Sy = diameter - cenCoordY - 1;
      for (int z = 0; z < dims[2]; z++)
          for (int x = cenCoordX; x < dims[0] - Sx - 1; x++)
              for (int y = cenCoordY; y < dims[1] - Sy - 1; y++)
                  for (int i = -cenCoordX; i < Sx + 1; i++)
                      for (int j = -cenCoordY; j < Sy + 1; j++)
                      {
                          auto inputValue1 = (inputImageType*)inputImage->GetScalarPointer(x + i, y + j, z);
                          auto inputValue2 = (inputImageType*)inputImage->GetScalarPointer(x, y, z);
                          if (*inputValue1 >= *inputValue2 + threshold)
                          {
                              auto processValue = (processImageType*)processImage->GetScalarPointer(x, y, z);
                              *processValue += mask[cenCoordX + i][cenCoordY + j];
                          }
                      }
  }
  else if (d->GreaterRadioButton->isChecked())
  {
      int threshold = d->ThreholdSpinBox->value();
      int Sx = diameter - cenCoordX - 1;
      int Sy = diameter - cenCoordY - 1;
      for (int z = 0; z < dims[2]; z++)
          for (int x = cenCoordX; x < dims[0] - Sx - 1; x++)
              for (int y = cenCoordY; y < dims[1] - Sy - 1; y++)
                  for (int i = -cenCoordX; i < Sx + 1; i++)
                      for (int j = -cenCoordY; j < Sy + 1; j++)
                      {
                          auto inputValue1 = (inputImageType*)inputImage->GetScalarPointer(x + i, y + j, z);
                          auto inputValue2 = (inputImageType*)inputImage->GetScalarPointer(x, y, z);
                          if (*inputValue1 > *inputValue2 + threshold)
                          {
                              auto processValue = (processImageType*)processImage->GetScalarPointer(x, y, z);
                              *processValue += mask[cenCoordX + i][cenCoordY + j];
                          }
                      }
  }
  else if (d->LessOrEqualRadioButton->isChecked())
  {
      int threshold = d->ThreholdSpinBox->value();
      int Sx = diameter - cenCoordX - 1;
      int Sy = diameter - cenCoordY - 1;
      for (int z = 0; z < dims[2]; z++)
          for (int x = cenCoordX; x < dims[0] - Sx - 1; x++)
              for (int y = cenCoordY; y < dims[1] - Sy - 1; y++)
                  for (int i = -cenCoordX; i < Sx + 1; i++)
                      for (int j = -cenCoordY; j < Sy + 1; j++)
                      {
                          auto inputValue1 = (inputImageType*)inputImage->GetScalarPointer(x + i, y + j, z);
                          auto inputValue2 = (inputImageType*)inputImage->GetScalarPointer(x, y, z);
                          if (*inputValue1 <= *inputValue2 + threshold)
                          {
                              auto processValue = (processImageType*)processImage->GetScalarPointer(x, y, z);
                              *processValue += mask[cenCoordX + i][cenCoordY + j];
                          }
                      }
  }
  else // <
  {
      int threshold = d->ThreholdSpinBox->value();
      int Sx = diameter - cenCoordX - 1;
      int Sy = diameter - cenCoordY - 1;
      for (int z = 0; z < dims[2]; z++)
          for (int x = cenCoordX; x < dims[0] - Sx - 1; x++)
              for (int y = cenCoordY; y < dims[1] - Sy - 1; y++)
                  for (int i = -cenCoordX; i < Sx + 1; i++)
                      for (int j = -cenCoordY; j < Sy + 1; j++)
                      {
                          auto inputValue1 = (inputImageType*)inputImage->GetScalarPointer(x + i, y + j, z);
                          auto inputValue2 = (inputImageType*)inputImage->GetScalarPointer(x, y, z);
                          if (*inputValue1 < *inputValue2 + threshold)
                          {
                              auto processValue = (processImageType*)processImage->GetScalarPointer(x, y, z);
                              *processValue += mask[cenCoordX + i][cenCoordY + j];
                          }
                      }
  }

  // Result image normalization (to unsigned char)
  processImageType processImageMax;
  for (int z = 0; z < dims[2]; z++)
  {
      processImageMax = 0ULL;
      for(int x=0; x<dims[0]; x++)
          for (int y = 0; y < dims[1]; y++)
          {
              auto value = (processImageType*)processImage->GetScalarPointer(x, y, z);
              if (*value > processImageMax)
                  processImageMax = *value;
          }

      for (int x = 0; x < dims[0]; x++)
          for (int y = 0; y < dims[1]; y++)
          {
              auto value = (processImageType*)processImage->GetScalarPointer(x, y, z);
              *value = *value * 255;
          }

      for (int x = 0; x < dims[0]; x++)
          for (int y = 0; y < dims[1]; y++)
          {
              auto value = (processImageType*)processImage->GetScalarPointer(x, y, z);
              *value = *value / processImageMax;
          }

      for(int x = 0; x < dims[0]; x++)
          for (int y = 0; y < dims[1]; y++)
          {
              auto resultValue1 = (processImageType*)processImage->GetScalarPointer(x, y, z);
              auto resultValue2 = (inputImageType*)inputImage->GetScalarPointer(x, y, z);
              *resultValue2 = (inputImageType) * resultValue1;
          }
  }

  // Results
  vtkMRMLVolumeNode* outputVolumeNode = vtkMRMLVolumeNode::SafeDownCast(d->OutputNodeComboBox->currentNode());
  int wasModified = outputVolumeNode->StartModify();
  outputVolumeNode->CopyContent(inputVolumeNode);
  outputVolumeNode->SetAndObserveImageData(inputImage);
  outputVolumeNode->EndModify(wasModified);

  for (int i = 0; i < diameter; i++)
      delete mask[i];
  delete mask;
}
