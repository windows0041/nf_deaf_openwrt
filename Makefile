#obj-m := nf_deaf.o
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nf_deaf
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/windows0041/nf_deaf.git
PKG_SOURCE_DATE:=2025-06-04   # 替换为仓库实际提交日期
PKG_SOURCE_VERSION:=3d60f3c568dfd2722486f7d013935c3a08822e65  # 替换为实际提交的哈希值（例如 `git rev-parse HEAD`）
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define KernelPackage/nf_deaf
  SUBMENU:=Netfilter Extensions
  TITLE:=nf_deaf kernel module
  FILES:=$(PKG_BUILD_DIR)/nf_deaf.ko
  AUTOLOAD:=$(call AutoLoad,99,nf_deaf)
  DEPENDS:=+kmod-nf-conntrack
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	# 可选：应用补丁（若有兼容性问题）
	# patch -d $(PKG_BUILD_DIR) -p1 < $(CURDIR)/patches/*.patch
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,nf_deaf))
