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

#ifndef __qSlicerloadableModuleModuleWidget_h
#define __qSlicerloadableModuleModuleWidget_h

// Slicer includes
#include "qSlicerAbstractModuleWidget.h"

#include "qSlicerloadableModuleModuleExport.h"

class qSlicerloadableModuleModuleWidgetPrivate;
class vtkMRMLNode;
class vtkImageData;

/// \ingroup Slicer_QtModules_ExtensionTemplate
class Q_SLICER_QTMODULES_LOADABLEMODULE_EXPORT qSlicerloadableModuleModuleWidget :
  public qSlicerAbstractModuleWidget
{
  Q_OBJECT

public:

  typedef qSlicerAbstractModuleWidget Superclass;
  qSlicerloadableModuleModuleWidget(QWidget *parent=0);
  virtual ~qSlicerloadableModuleModuleWidget();

public slots:
  void onApply();

protected:
  QScopedPointer<qSlicerloadableModuleModuleWidgetPrivate> d_ptr;

  void setup() override;

private:
  Q_DECLARE_PRIVATE(qSlicerloadableModuleModuleWidget);
  Q_DISABLE_COPY(qSlicerloadableModuleModuleWidget);
};

#endif
