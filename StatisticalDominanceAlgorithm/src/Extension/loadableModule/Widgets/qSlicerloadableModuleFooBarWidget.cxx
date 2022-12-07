/*==============================================================================

  Program: 3D Slicer

  Copyright (c) Kitware Inc.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Jean-Christophe Fillion-Robin, Kitware Inc.
  and was partially funded by NIH grant 3P41RR013218-12S1

==============================================================================*/

// FooBar Widgets includes
#include "qSlicerloadableModuleFooBarWidget.h"
#include "ui_qSlicerloadableModuleFooBarWidget.h"

//-----------------------------------------------------------------------------
/// \ingroup Slicer_QtModules_loadableModule
class qSlicerloadableModuleFooBarWidgetPrivate
  : public Ui_qSlicerloadableModuleFooBarWidget
{
  Q_DECLARE_PUBLIC(qSlicerloadableModuleFooBarWidget);
protected:
  qSlicerloadableModuleFooBarWidget* const q_ptr;

public:
  qSlicerloadableModuleFooBarWidgetPrivate(
    qSlicerloadableModuleFooBarWidget& object);
  virtual void setupUi(qSlicerloadableModuleFooBarWidget*);
};

// --------------------------------------------------------------------------
qSlicerloadableModuleFooBarWidgetPrivate
::qSlicerloadableModuleFooBarWidgetPrivate(
  qSlicerloadableModuleFooBarWidget& object)
  : q_ptr(&object)
{
}

// --------------------------------------------------------------------------
void qSlicerloadableModuleFooBarWidgetPrivate
::setupUi(qSlicerloadableModuleFooBarWidget* widget)
{
  this->Ui_qSlicerloadableModuleFooBarWidget::setupUi(widget);
}

//-----------------------------------------------------------------------------
// qSlicerloadableModuleFooBarWidget methods

//-----------------------------------------------------------------------------
qSlicerloadableModuleFooBarWidget
::qSlicerloadableModuleFooBarWidget(QWidget* parentWidget)
  : Superclass( parentWidget )
  , d_ptr( new qSlicerloadableModuleFooBarWidgetPrivate(*this) )
{
  Q_D(qSlicerloadableModuleFooBarWidget);
  d->setupUi(this);
}

//-----------------------------------------------------------------------------
qSlicerloadableModuleFooBarWidget
::~qSlicerloadableModuleFooBarWidget()
{
}
