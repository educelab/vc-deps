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
if(APPLE)
    set(BOOST_TOOLSET_AUTO darwin)
elseif(UNIX AND NOT APPLE)
    set(BOOST_TOOLSET_AUTO clang)
elseif(WIN32)
    set(BOOST_TOOLSET_AUTO msvc)
else()
    set(BOOST_TOOLSET_AUTO gcc)
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
    unit_test_framework
    thread
)

if(VCDEPS_BUILD_BOOST)
string(REPLACE ";" "," BOOST_BUILD_LIBS "${VCDEPS_BOOST_COMPONENTS}")
string(REPLACE "unit_test_framework" "test" BOOST_BUILD_LIBS ${BOOST_BUILD_LIBS})
externalproject_add(
    boost
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz
    URL_HASH SHA256=9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${BOOST_PATCH_CMD}
    CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_INSTALL_PREFIX} --with-libraries=${BOOST_BUILD_LIBS} --with-toolset=${BOOST_TOOLSET}
    BUILD_COMMAND ./b2 cxxflags="-std=c++${CMAKE_CXX_STANDARD}" variant=${BOOST_LIB_TYPE} link=${BOOST_LINK_TYPE} toolset=${BOOST_TOOLSET} ${BOOST_OSX_SDK} install
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
)
else()
  find_package(Boost 1.69 REQUIRED COMPONENTS ${VCDEPS_BOOST_COMPONENTS})
  add_custom_target(boost)
endif()
