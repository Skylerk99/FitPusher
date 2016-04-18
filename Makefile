GO_EASY_ON_ME=1

ARCHS = armv7 arm64
TARGET = iphone::9.2:9.0
THEOS_DEVICE_IP = 192.168.2.69


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FitPusher
FitPusher_FILES = Tweak.xm
FitPusher_FRAMEWORKS = CoreGraphics Foundation 
FitPusher_PRIVATE_FRAMEWORKS = AudioToolbox BulletinBoard AppSupport
FitPusher_LIBRARIES = rocketbootstrap
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fitpusher
include $(THEOS_MAKE_PATH)/aggregate.mk
