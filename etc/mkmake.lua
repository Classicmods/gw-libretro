local template = [[
##############
# ${HEADERMSG}

#############
# User config

DEBUG = 0
LOG_PERFORMANCE = 1

####################################
# Variable setup for Makefile.common

CORE_DIR      = ..
INCLUDES      = ${PLAT_INCDIR}
SOURCES_C     =
SOURCES_CXX   =
SOURCES_LUA_C =
LUA_FILES     =
PNG_FILES     =

include Makefile.common

#################
# Toolchain setup

CC  = ${CC}
CXX = ${CXX}
AS  = ${AS}

############
# Extensions

OBJEXT = .${EXT}.o
SOEXT  = .${EXT}.${SO}

################
# Platform setup

PLATDEFS     = ${PLAT_DEFS}
PLATCFLAGS   = ${PLAT_CFLAGS}
PLATCXXFLAGS = ${PLAT_CXXFLAGS}
PLATLDFLAGS  = ${PLAT_LDFLAGS}

################
# libretro setup

RETRODEFS     = -D__LIBRETRO__
RETROCFLAGS   =
RETROCXXFLAGS =
RETROLDFLAGS  =

#################
# Final variables

DEFINES  = $(PLATDEFS) $(RETRODEFS)
CFLAGS   = $(PLATCFLAGS) $(RETROCFLAGS) $(DEFINES) $(INCLUDES)
CXXFLAGS = $(PLATCXXFLAGS) $(RETROCXXFLAGS) $(DEFINES) $(INCLUDES)
LDFLAGS  = $(PLATLDFLAGS) $(RETROLDFLAGS)

########
# Tuning

ifeq ($(DEBUG), 1)
  CFLAGS   += -O0 -g
  CXXFLAGS += -O0 -g
  LDFLAGS  += -g
else
  CFLAGS   += -O3 -DNDEBUG
  CXXFLAGS += -O3 -DNDEBUG
endif

ifeq ($(LOG_PERFORMANCE), 1)
  CFLAGS   += -DLOG_PERFORMANCE
  CXXFLAGS += -DLOG_PERFORMANCE
endif

###############
# Include rules

include Makefile.rules
]]

local host = 'linux-x86_64'
--local host = 'linux-x86'
--local host = 'windows-x86_64'

local platforms = {
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm64_v8a = {
    MAKEFILE      = 'Makefile.android_arm64_v8a',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-4.9/prebuilt/' .. host .. '/bin/aarch64-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-4.9/prebuilt/' .. host .. '/bin/aarch64-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/aarch64-linux-android-4.9/prebuilt/' .. host .. '/bin/aarch64-linux-android-as',
    EXT           = 'android_arm64_v8a',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-arm64/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-arm64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_x86_64 = {
    MAKEFILE      = 'Makefile.android_x86_64',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/x86_64-4.9/prebuilt/' .. host .. '/bin/x86_64-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/x86_64-4.9/prebuilt/' .. host .. '/bin/x86_64-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/x86_64-4.9/prebuilt/' .. host .. '/bin/x86_64-linux-android-as',
    EXT           = 'android_x86_64',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-x86_64/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-x86_64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_mips64 = {
    MAKEFILE      = 'Makefile.android_mips64',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-4.9/prebuilt/' .. host .. '/bin/mips64el-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-4.9/prebuilt/' .. host .. '/bin/mips64el-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/mips64el-linux-android-4.9/prebuilt/' .. host .. '/bin/mips64el-linux-android-as',
    EXT           = 'android_mips64',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-21/arch-mips64/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-fpic -fno-strict-aliasing -finline-functions -ffunction-sections -funwind-tables -fmessage-length=0 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -no-canonical-prefixes -fomit-frame-pointer -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-21/arch-mips64 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm_v7a = {
    MAKEFILE      = 'Makefile.armeabi-v7a',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-as',
    EXT           = 'armeabi-v7a',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-3/arch-arm/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-3/arch-arm -lgcc -no-canonical-prefixes -march=armv7-a -Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_arm_v5te = {
    MAKEFILE      = 'Makefile.armeabi',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/arm-linux-androideabi-4.8/prebuilt/' .. host .. '/bin/arm-linux-androideabi-as',
    EXT           = 'armeabi',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-3/arch-arm/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-fpic -ffunction-sections -funwind-tables -fstack-protector -no-canonical-prefixes -march=armv5te -mtune=xscale -msoft-float -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-3/arch-arm -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_x86 = {
    MAKEFILE      = 'Makefile.x86',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/x86-4.8/prebuilt/' .. host .. '/bin/i686-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/x86-4.8/prebuilt/' .. host .. '/bin/i686-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/x86-4.8/prebuilt/' .. host .. '/bin/i686-linux-android-as',
    EXT           = 'x86',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-9/arch-x86/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-ffunction-sections -funwind-tables -no-canonical-prefixes -fstack-protector -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-9/arch-x86 -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  android_mips = {
    MAKEFILE      = 'Makefile.android_mips',
    HEADERMSG     = 'Download android-ndk-r10d-linux-x86_64.bin from https://developer.android.com/tools/sdk/ndk/index.html, unpack somewhere, and set NDK_ROOT_DIR to it',
    CC            = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-4.8/prebuilt/' .. host .. '/bin/mipsel-linux-android-gcc',
    CXX           = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-4.8/prebuilt/' .. host .. '/bin/mipsel-linux-android-g++',
    AS            = '$(NDK_ROOT_DIR)/toolchains/mipsel-linux-android-4.8/prebuilt/' .. host .. '/bin/mipsel-linux-android-as',
    EXT           = 'android_mips',
    SO            = 'so',
    PLAT_INCDIR   = '-I$(NDK_ROOT_DIR)/platforms/android-9/arch-mips/usr/include',
    PLAT_DEFS     = '-DANDROID -DINLINE=inline -DHAVE_STDINT_H -DBSPF_UNIX -DHAVE_INTTYPES -DLSB_FIRST -Dl_getlocaledecpoint\\(\\)=\\(\\\'.\\\'\\)',
    PLAT_CFLAGS   = '-fpic -fno-strict-aliasing -finline-functions -ffunction-sections -funwind-tables -fmessage-length=0 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -no-canonical-prefixes -fomit-frame-pointer -funswitch-loops -finline-limit=300 -Wa,--noexecstack -Wformat -Werror=format-security',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared --sysroot=$(NDK_ROOT_DIR)/platforms/android-9/arch-mips -lgcc -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -lc -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_x86 = {
    MAKEFILE      = 'Makefile.linux_x86',
    HEADERMSG     = 'apt-get install g++-multilib libc6-dev-i386',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    EXT           = 'linux_x86',
    SO            = 'so',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m32 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m32 -shared -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  linux_x86_64 = {
    MAKEFILE      = 'Makefile.linux_x86_64',
    HEADERMSG     = '',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    EXT           = 'linux_x86_64',
    SO            = 'so',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m64 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m64 -shared -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  windows_x86 = {
    MAKEFILE      = 'Makefile.windows_x86',
    HEADERMSG     = 'apt-get install mingw-w64',
    CC            = 'i686-w64-mingw32-gcc',
    CXX           = 'i686-w64-mingw32-g++',
    AS            = 'i686-w64-mingw32-as',
    EXT           = 'windows_x86',
    SO            = 'dll',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  windows_x86_64 = {
    MAKEFILE      = 'Makefile.windows_x86_64',
    HEADERMSG     = 'apt-get install mingw-w64',
    CC            = 'x86_64-w64-mingw32-gcc',
    CXX           = 'x86_64-w64-mingw32-g++',
    AS            = 'x86_64-w64-mingw32-as',
    EXT           = 'windows_x86_64',
    SO            = 'dll',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-shared -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mingw32 = {
    MAKEFILE      = 'Makefile.mingw32',
    HEADERMSG     = '',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    EXT           = 'mingw32',
    SO            = 'dll',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m32 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m32 -shared -lm'
  },
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mingw64 = {
    MAKEFILE      = 'Makefile.mingw64',
    HEADERMSG     = 'Install tdm-gcc (http://tdm-gcc.tdragon.net/)',
    CC            = 'gcc',
    CXX           = 'g++',
    AS            = 'as',
    EXT           = 'mingw64',
    SO            = 'dll',
    PLAT_INCDIR   = '',
    PLAT_DEFS     = '',
    PLAT_CFLAGS   = '-m64 -fpic -fstrict-aliasing',
    PLAT_CXXFLAGS = '${PLAT_CFLAGS}',
    PLAT_LDFLAGS  = '-m64 -shared -lm'
  },
}

for plat, defs in pairs( platforms ) do
  local templ = template
  local equal
  
  repeat
    equal = true
    
    for def, value in pairs( defs ) do
      local templ2 = templ:gsub( '%${' .. def .. '}', ( value:gsub( '%%', '%%%%' ) ) )
      equal = equal and templ == templ2
      templ = templ2
    end
  until equal
  
  local file, err = io.open( defs.MAKEFILE, 'wb' )
  if not file then error( err ) end
  
  file:write( templ )
  file:close()
end
