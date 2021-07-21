option(VCDEPS_BUILD_BOOST "Build Boost" ON)

# Set Boost build type to match provided release type
if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    set(BOOST_LIB_TYPE debug)
else()
    set(BOOST_LIB_TYPE release)
endif()

# Set Boost link type to match provided link type
if(BUILD_SHARED_LIBS)
    set(BOOST_LINK_TYPE shared)
else()
    set(BOOST_LINK_TYPE static)
endif()

# Set Boost toolset type based on the OS
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
    set(BOOST_TOOLSET_AUTO clang)
    configure_file(${PROJECT_SOURCE_DIR}/patches/boost-macOS-user-config.jam.in ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam)
    set(BOOST_PATCH_CMD cp ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam tools/build/src/)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(BOOST_TOOLSET_AUTO clang)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(BOOST_TOOLSET_AUTO gcc)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(BOOST_TOOLSET_AUTO msvc)
endif()
set(BOOST_TOOLSET ${BOOST_TOOLSET_AUTO} CACHE STRING "Boost Build toolset")

# Required Boost components
set(VCDEPS_BOOST_COMPONENTS
    atomic
    chrono
    date_time
    exception
    iostreams
    filesystem
    program_options
    random
    regex
    serialization
    system
    thread
)

if(VCDEPS_BUILD_BOOST)
string(REPLACE ";" "," BOOST_BUILD_LIBS "${VCDEPS_BOOST_COMPONENTS}")

# Compiler flags
set(BOOST_CXX_FLAGS "cxxflags=-std=c++${CMAKE_CXX_STANDARD}")

# Mimic project PIC flag
if(CMAKE_POSITION_INDEPENDENT_CODE)
  string(APPEND BOOST_CXX_FLAGS " -fPIC")
endif(CMAKE_POSITION_INDEPENDENT_CODE)

externalproject_add(
    boost
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz
    URL_HASH SHA256=7bd7ddceec1a1dfdcbdb3e609b60d01739c38390a5f956385a12f3122049f0ca
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${BOOST_PATCH_CMD}
    CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_INSTALL_PREFIX} --with-libraries=${BOOST_BUILD_LIBS} --with-toolset=${BOOST_TOOLSET}
    BUILD_COMMAND ./b2 ${BOOST_CXX_FLAGS} variant=${BOOST_LIB_TYPE} link=${BOOST_LINK_TYPE} toolset=${BOOST_TOOLSET} install
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
)
else()
  find_package(Boost 1.69 REQUIRED COMPONENTS ${VCDEPS_BOOST_COMPONENTS})
  add_custom_target(boost)
endif()
