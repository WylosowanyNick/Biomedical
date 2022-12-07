#include "itkImageFileWriter.h"
#include "itkPluginUtilities.h"
#include "itkInvertIntensityImageFilter.h"
#include "cliModuleCLP.h"

// Use an anonymous namespace to keep class types and function names
// from colliding when module is used as shared object module.  Every
// thing should be in an anonymous namespace except for the module
// entry point, e.g. main()
//
namespace
{

template <typename TPixel>
int DoIt( int argc, char * argv[], TPixel )
{
  PARSE_ARGS;

  // Definition of the types of images used
  typedef TPixel InputPixelType;
  typedef unsigned long long ProcessPixelType;
  typedef unsigned char OutputPixelType;

  const unsigned int Dimension = 3;

  typedef itk::Image<InputPixelType, Dimension> InputImageType;
  typedef itk::Image<OutputPixelType, Dimension> OutputImageType;

  // Loading the input image
  typedef itk::ImageFileReader<InputImageType> ReaderType;
  typename ReaderType::Pointer reader = ReaderType::New();
  reader->SetFileName(inputVolume.c_str());
  reader->Update();
  typename InputImageType::Pointer inputImage = reader->GetOutput();

  // Possible negation of the input image
  if(negateInputImage)
  {
    typedef itk::InvertIntensityImageFilter<InputImageType, InputImageType> InvertType;
    typename InvertType::Pointer inverter = InvertType::New();
    inverter->SetInput(inputImage);
    inverter->Update();
    inputImage = inverter->GetOutput();
  }

  // Defining the appropriate mask
  const int diameter = 2*radious + 1;
  int **mask = new int*[diameter];
  for(int i=0; i<diameter; i++)
    mask[i] = new int[diameter];
  for(int i=0; i<diameter; i++)
    for(int j=0; j<diameter; j++)
      mask[i][j] = 0;

  int cenCoordX, cenCoordY;
  if (neighbourhood == "horizontal")
  {
    for(int i=radious/2; i<radious+radious/2; i++)
      for(int j=0; j<diameter; j++)
        mask[i][j] = 1;

    cenCoordX = radious;
    cenCoordY = radious;
  }
  else if (neighbourhood == "vertical")
  {
    for(int i=0; i<diameter; i++)
      for(int j=radious/2; j<radious+radious/2; j++)
        mask[i][j] = 1;

    cenCoordX = radious;
    cenCoordY = radious;
  }
  else // disc
  {
    for(int i=0; i<diameter; i++)
      for(int j=0; j<diameter; j++)
        if((i-radious)*(i-radious) + (j-radious)*(j-radious) <= radious*radious)
          mask[i][j] = 1;

    cenCoordX = radious;
    cenCoordY = radious;
  }

  // Definition of the processing and resultant images
  using ProcessImageType = itk::Image<ProcessPixelType, 3>;
  auto processImage = ProcessImageType::New();
  auto outputImage = OutputImageType::New();

  InputImageType::RegionType region1 = inputImage->GetLargestPossibleRegion();
  InputImageType::SizeType size = region1.GetSize();
  {
    ProcessImageType::IndexType start;
    start[0]=0; start[1]=0; start[2]=0;

    ProcessImageType::RegionType region;
    region.SetIndex(start); region.SetSize(size);

    processImage->SetRegions(region);
    processImage->Allocate(true);

    outputImage->SetRegions(region);
    outputImage->Allocate();
  }

  // SDA Algorithm
  if(relationship == ">=")
  {
    int Sx = diameter-cenCoordX-1;
    int Sy = diameter-cenCoordY-1;
    for(int z=0; z<size[2]; z++)
      for(int x=cenCoordX; x<size[0]-Sx-1; x++)
        for(int y=cenCoordY; y<size[1]-Sy-1; y++)
          for(int i=-cenCoordX; i<Sx+1; i++)
            for(int j=-cenCoordY; j<Sy+1; j++)
              if(inputImage->GetPixel({x+i,y+j,z}) >= inputImage->GetPixel({x,y,z}) + threshold)
                processImage->SetPixel({x,y,z}, processImage->GetPixel({x,y,z})+mask[cenCoordX + i][cenCoordY + j]);
  }
  else if(relationship == ">")
  {
    int Sx = diameter-cenCoordX-1;
    int Sy = diameter-cenCoordY-1;
    for(int z=0; z<size[2]; z++)
      for(int x=cenCoordX; x<size[0]-Sx-1; x++)
        for(int y=cenCoordY; y<size[1]-Sy-1; y++)
          for(int i=-cenCoordX; i<Sx+1; i++)
            for(int j=-cenCoordY; j<Sy+1; j++)
              if(inputImage->GetPixel({x+i,y+j,z}) > inputImage->GetPixel({x,y,z}) + threshold)
                processImage->SetPixel({x,y,z}, processImage->GetPixel({x,y,z})+mask[cenCoordX + i][cenCoordY + j]);
  }
  else if(relationship == "<=")
  {
    int Sx = diameter-cenCoordX-1;
    int Sy = diameter-cenCoordY-1;
    for(int z=0; z<size[2]; z++)
      for(int x=cenCoordX; x<size[0]-Sx-1; x++)
        for(int y=cenCoordY; y<size[1]-Sy-1; y++)
          for(int i=-cenCoordX; i<Sx+1; i++)
            for(int j=-cenCoordY; j<Sy+1; j++)
              if(inputImage->GetPixel({x+i,y+j,z}) <= inputImage->GetPixel({x,y,z}) + threshold)
                processImage->SetPixel({x,y,z}, processImage->GetPixel({x,y,z})+mask[cenCoordX + i][cenCoordY + j]);
  }
  else // <
  {
    int Sx = diameter-cenCoordX-1;
    int Sy = diameter-cenCoordY-1;
    for(int z=0; z<size[2]; z++)
      for(int x=cenCoordX; x<size[0]-Sx-1; x++)
        for(int y=cenCoordY; y<size[1]-Sy-1; y++)
          for(int i=-cenCoordX; i<Sx+1; i++)
            for(int j=-cenCoordY; j<Sy+1; j++)
              if(inputImage->GetPixel({x+i,y+j,z}) < inputImage->GetPixel({x,y,z}) + threshold)
                processImage->SetPixel({x,y,z}, processImage->GetPixel({x,y,z})+mask[cenCoordX + i][cenCoordY + j]);
  }

  // Result image normalization
  ProcessPixelType outputImageMax;
  for(int z=0; z<size[2]; z++)
  {
    outputImageMax = 0ULL;
    for(int x=0; x<size[0]; x++)
      for(int y=0; y<size[1]; y++)
        if(processImage->GetPixel({x,y,z}) > outputImageMax)
          outputImageMax = processImage->GetPixel({x,y,z});

    for(int x=0; x<size[0]; x++)
      for(int y=0; y<size[1]; y++)
        processImage->SetPixel({x,y,z}, 255*processImage->GetPixel({x,y,z}));

    for(int x=0; x<size[0]; x++)
      for(int y=0; y<size[1]; y++)
        processImage->SetPixel({x,y,z}, processImage->GetPixel({x,y,z})/outputImageMax);

    for(int x=0; x<size[0]; x++)
      for(int y=0; y<size[1]; y++)
        outputImage->SetPixel({x,y,z}, (OutputPixelType)processImage->GetPixel({x,y,z}));
  }

  // Results
  typedef itk::ImageFileWriter<OutputImageType> WriterType;
  typename WriterType::Pointer writer = WriterType::New();
  writer->SetFileName(outputVolume.c_str());
  writer->SetInput(outputImage);
  writer->SetUseCompression(1);
  writer->Update();

  for(int i=0; i<diameter; i++)
    delete mask[i];
  delete mask;

  return EXIT_SUCCESS;
}

} // end of anonymous namespace

int main( int argc, char * argv[] )
{
  PARSE_ARGS;

  // Input node
  itk::ImageIOBase::IOPixelType pixelType;
  itk::ImageIOBase::IOComponentType componentType;

  try
  {
    itk::GetImageType(inputVolume, pixelType, componentType);

    switch (componentType)
    {
      case itk::ImageIOBase::UCHAR:
        return DoIt( argc, argv, static_cast<unsigned char>(0) );
        break;
      case itk::ImageIOBase::CHAR:
        return DoIt( argc, argv, static_cast<signed char>(0) );
        break;
      case itk::ImageIOBase::USHORT:
        return DoIt( argc, argv, static_cast<unsigned short>(0) );
        break;
      case itk::ImageIOBase::SHORT:
        return DoIt( argc, argv, static_cast<short>(0) );
        break;
      case itk::ImageIOBase::UINT:
        return DoIt( argc, argv, static_cast<unsigned int>(0) );
        break;
      case itk::ImageIOBase::INT:
        return DoIt( argc, argv, static_cast<int>(0) );
        break;
      case itk::ImageIOBase::ULONG:
        return DoIt( argc, argv, static_cast<unsigned long>(0) );
        break;
      case itk::ImageIOBase::LONG:
        return DoIt( argc, argv, static_cast<long>(0) );
        break;
      case itk::ImageIOBase::FLOAT:
        return DoIt( argc, argv, static_cast<float>(0) );
        break;
      case itk::ImageIOBase::DOUBLE:
        return DoIt( argc, argv, static_cast<double>(0) );
        break;
      case itk::ImageIOBase::UNKNOWNCOMPONENTTYPE:
      default:
        std::cerr << "Unknown input image pixel component type: ";
        std::cerr << itk::ImageIOBase::GetComponentTypeAsString( componentType );
        std::cerr << std::endl;
        return EXIT_FAILURE;
        break;
      }
  }
  catch(itk::ExceptionObject & excep)
  {
      std::cerr << argv[0] << ": exception caught !" << std::endl;
      std::cerr << excep << std::endl;
      return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
