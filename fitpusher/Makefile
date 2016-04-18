GO_EASY_ON_ME=1
ARCHS = armv7 arm64
TARGET = iphone::9.2:9.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FitPusher
FitPusher_FILES = skyRootListController.m
FitPusher_INSTALL_PATH = /Library/PreferenceBundles
FitPusher_FRAMEWORKS = UIKit
FitPusher_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FitPusher.plist$(ECHO_END)
