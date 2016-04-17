GO_EASY_ON_ME=1

ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest

THEOS_DEVICE_IP = 192.168.2.69


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FitPusher
FitPusher_FILES = Tweak.xm
FitPusher_FRAMEWORKS = CoreGraphics Foundation 
#FitPusher_PRIVATE_FRAMEWORKS = AudioToolbox BulletinBoard AppSupport
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
