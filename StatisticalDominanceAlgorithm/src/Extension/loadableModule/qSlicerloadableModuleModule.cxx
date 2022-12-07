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

// loadableModule Logic includes
#include <vtkSlicerloadableModuleLogic.h>

// loadableModule includes
#include "qSlicerloadableModuleModule.h"
#include "qSlicerloadableModuleModuleWidget.h"

//-----------------------------------------------------------------------------
/// \ingroup Slicer_QtModules_ExtensionTemplate
class qSlicerloadableModuleModulePrivate
{
public:
  qSlicerloadableModuleModulePrivate();
};

//-----------------------------------------------------------------------------
// qSlicerloadableModuleModulePrivate methods

//-----------------------------------------------------------------------------
qSlicerloadableModuleModulePrivate::qSlicerloadableModuleModulePrivate()
{
}

//-----------------------------------------------------------------------------
// qSlicerloadableModuleModule methods

//-----------------------------------------------------------------------------
qSlicerloadableModuleModule::qSlicerloadableModuleModule(QObject* _parent)
  : Superclass(_parent)
  , d_ptr(new qSlicerloadableModuleModulePrivate)
{
}

//-----------------------------------------------------------------------------
qSlicerloadableModuleModule::~qSlicerloadableModuleModule()
{
}

//-----------------------------------------------------------------------------
QString qSlicerloadableModuleModule::helpText() const
{
  return "Statistical Dominance Algorithm";
}

//-----------------------------------------------------------------------------
QString qSlicerloadableModuleModule::acknowledgementText() const
{
  return "Scripted extension performing SDA on digital image.";
}

//-----------------------------------------------------------------------------
QStringList qSlicerloadableModuleModule::contributors() const
{
  QStringList moduleContributors;
  moduleContributors << QString("Andrzej Jasek (AGH), Adam Piórkowski (AGH)");
  return moduleContributors;
}

//-----------------------------------------------------------------------------
QIcon qSlicerloadableModuleModule::icon() const
{
  return QIcon(":/Icons/loadableModule.png");
}

//-----------------------------------------------------------------------------
QStringList qSlicerloadableModuleModule::categories() const
{
  return QStringList() << "Examples";
}

//-----------------------------------------------------------------------------
QStringList qSlicerloadableModuleModule::dependencies() const
{
  return QStringList();
}

//-----------------------------------------------------------------------------
void qSlicerloadableModuleModule::setup()
{
  this->Superclass::setup();
}

//-----------------------------------------------------------------------------
qSlicerAbstractModuleRepresentation* qSlicerloadableModuleModule
::createWidgetRepresentation()
{
  return new qSlicerloadableModuleModuleWidget;
}

//-----------------------------------------------------------------------------
vtkMRMLAbstractLogic* qSlicerloadableModuleModule::createLogic()
{
  return vtkSlicerloadableModuleLogic::New();
}
