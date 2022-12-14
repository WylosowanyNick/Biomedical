cmake_minimum_required(VERSION 3.16.3...3.19.7 FATAL_ERROR)

project(Extension)

#-----------------------------------------------------------------------------
# Extension meta-information
set(EXTENSION_HOMEPAGE "https://home.agh.edu.pl/~pioro/sda/")
set(EXTENSION_CATEGORY "Examples")
set(EXTENSION_CONTRIBUTORS "Andrzej Jasek (AGH), Adam Piórkowski (AGH)")
set(EXTENSION_DESCRIPTION "CLI module performing SDA on digital grayscale image.")
set(EXTENSION_ICONURL "https://www.example.com/Slicer/Extensions/Extension.png")
set(EXTENSION_SCREENSHOTURLS "https://www.example.com/Slicer/Extensions/Extension/Screenshots/1.png")
set(EXTENSION_DEPENDS "NA") # Specified as a list or "NA" if no dependencies

#-----------------------------------------------------------------------------
# Extension dependencies
find_package(Slicer REQUIRED)
include(${Slicer_USE_FILE})

#-----------------------------------------------------------------------------
# Extension modules
add_subdirectory(cliModule)
add_subdirectory(loadableModule)
## NEXT_MODULE

#-----------------------------------------------------------------------------
include(${Slicer_EXTENSION_GENERATE_CONFIG})
include(${Slicer_EXTENSION_CPACK})
