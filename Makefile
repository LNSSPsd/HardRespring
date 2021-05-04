TARGET := iphone:clang:latest:7.0
ARCHS := armv7 armv7s arm64 arm64e
INSTALL_TARGET_PROCESSES = backboardd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HardRespring

HardRespring_FILES = Tweak.x
HardRespring_CFLAGS = #-fobjc-arc (ARC may cause crash)
HardRespring_FRAMEWORKS = IOKit

include $(THEOS_MAKE_PATH)/tweak.mk
