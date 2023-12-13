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
    program_options
    system
)

if(VCDEPS_BUILD_BOOST)
string(REPLACE ";" "," BOOST_BUILD_LIBS "${VCDEPS_BOOST_COMPONENTS}")

# Compiler flags
set(BOOST_CXX_FLAGS "cxxflags=-std=c++${CMAKE_CXX_STANDARD}")

# Mimic project PIC flag
if(CMAKE_POSITION_INDEPENDENT_CODE)
  string(APPEND BOOST_CXX_FLAGS " -fPIC")
endif(CMAKE_POSITION_INDEPENDENT_CODE)

# Honor quiet request
if(DCMAKE_INSTALL_MESSAGE STREQUAL NEVER)
    set(BOOST_VERBOSE -d0)
endif()

externalproject_add(
    boost
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.gz
    URL_HASH SHA512=231acce3021ef790ee0355e620faf375439c3f2ece0facac681acfc7be60a792c8404bd8c5920cd68c0d9dbcf8b8ac923afdd8d6e8f653306eef974b070e4490
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    PATCH_COMMAND ${BOOST_PATCH_CMD}
    CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_INSTALL_PREFIX} --with-libraries=${BOOST_BUILD_LIBS} --with-toolset=${BOOST_TOOLSET}
    BUILD_COMMAND ./b2 ${BOOST_CXX_FLAGS} variant=${BOOST_LIB_TYPE} link=${BOOST_LINK_TYPE} toolset=${BOOST_TOOLSET} ${BOOST_VERBOSE} install
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
)
else()
  find_package(Boost 1.69 REQUIRED COMPONENTS ${VCDEPS_BOOST_COMPONENTS})
  add_custom_target(boost)
endif()
