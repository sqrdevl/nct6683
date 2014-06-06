# For building for the current running version of Linux
TARGET		:= $(shell uname -r)
HOME=$(shell pwd)
# Or for a specific version
#TARGET		:= 2.6.33.5
KERNEL_MODULES	:= /lib/modules/$(TARGET)
# KERNEL_BUILD	:= $(KERNEL_MODULES)/build
KERNEL_BUILD	:= /usr/src/linux-headers-$(TARGET)

#SYSTEM_MAP	:= $(KERNEL_BUILD)/System.map
SYSTEM_MAP	:= /boot/System.map-$(TARGET)

DRIVER := nct6683

# Directory below /lib/modules/$(TARGET)/kernel into which to install
# the module:
MOD_SUBDIR = drivers/hwmon

obj-m	:= $(DRIVER).o

MAKEFLAGS += --no-print-directory

.PHONY: all install modules modules_install clean

all: modules

# Targets for running make directly in the external module directory:

modules clean:
	@$(MAKE) -C $(KERNEL_BUILD) M=$(CURDIR) $@ EXTRA_CFLAGS=-g

install: modules_install

modules_install:
	mkdir -p $(KERNEL_MODULES)/kernel/$(MOD_SUBDIR)
	cp $(DRIVER).ko $(KERNEL_MODULES)/kernel/$(MOD_SUBDIR)
	depmod -a -F $(SYSTEM_MAP) $(TARGET)
