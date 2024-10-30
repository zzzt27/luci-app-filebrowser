include $(TOPDIR)/feeds/luci/luci.mk

PKG_NAME:=luci-app-filebrowser
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=LuCI FileBrowser
LUCI_PKGARCH:=all

include $(TOPDIR)/rules.mk

# Function to fetch the latest release download URL for arm64
define LatestReleaseURL
    $(shell curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | \
    grep "browser_download_url" | \
    grep "linux-arm64-filebrowser.tar.gz" | \
    cut -d '"' -f 4)
endef

PKG_SOURCE_URL:=$(call LatestReleaseURL)
PKG_SOURCE:=linux-arm64-filebrowser.tar.gz

define Build/Prepare
    mkdir -p $(PKG_BUILD_DIR)
    # Download the binary only if not already downloaded
    [ -f $(DL_DIR)/$(PKG_SOURCE) ] || wget -O $(DL_DIR)/$(PKG_SOURCE) $(PKG_SOURCE_URL)
    tar -xzvf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_DIR)
endef

define Package/$(PKG_NAME)/install
    # Install LuCI files
    $(INSTALL_DIR) $(1)/usr/bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/filebrowser $(1)/usr/bin/filebrowser

    $(INSTALL_DIR) $(1)/etc/config
    $(INSTALL_DATA) ./root/etc/config/filebrowser $(1)/etc/config/filebrowser

    $(INSTALL_DIR) $(1)/etc/init.d
    $(INSTALL_BIN) ./root/etc/init.d/filebrowser $(1)/etc/init.d/filebrowser

    $(INSTALL_DIR) $(1)/etc/uci-defaults
    $(INSTALL_BIN) ./root/etc/uci-defaults/luci-filebrowser $(1)/etc/uci-defaults/luci-filebrowser

    $(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
    $(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/luci-app-filebrowser.json $(1)/usr/share/rpcd/acl.d/luci-app-filebrowser.json

    # LuCI app views and controllers
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
    $(INSTALL_DATA) ./luasrc/controller/filebrowser.lua $(1)/usr/lib/lua/luci/controller/filebrowser.lua

    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
    $(INSTALL_DATA) ./luasrc/model/cbi/filebrowser.lua $(1)/usr/lib/lua/luci/model/cbi/filebrowser.lua

    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/filebrowser
    $(INSTALL_DATA) ./luasrc/view/filebrowser/filebrowser.htm $(1)/usr/lib/lua/luci/view/filebrowser/filebrowser.htm
    $(INSTALL_DATA) ./luasrc/view/filebrowser/filebrowser_status.htm $(1)/usr/lib/lua/luci/view/filebrowser/filebrowser_status.htm
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
