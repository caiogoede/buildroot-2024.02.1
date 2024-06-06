################################################################################
#
# libssh
#
################################################################################

LIBSSH_VERSION_MAJOR = 0.10
LIBSSH_VERSION = $(LIBSSH_VERSION_MAJOR).6
LIBSSH_SOURCE = libssh-$(LIBSSH_VERSION).tar.xz
LIBSSH_SITE = https://www.libssh.org/files/$(LIBSSH_VERSION_MAJOR)
LIBSSH_LICENSE = LGPL-2.1
LIBSSH_LICENSE_FILES = COPYING
LIBSSH_CPE_ID_VENDOR = libssh
LIBSSH_INSTALL_STAGING = YES
LIBSSH_SUPPORTS_IN_SOURCE_BUILD = NO
LIBSSH_CONF_OPTS = \
	-DWITH_STACK_PROTECTOR=OFF \
	-DWITH_EXAMPLES=OFF

# Not part of any release
# https://www.libssh.org/2023/07/14/cve-2023-3603-potential-null-dereference-in-libsshs-sftp-server/
LIBSSH_IGNORE_CVES += CVE-2023-3603

ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
LIBSSH_CONF_OPTS += -DWITH_STACK_CLASH_PROTECTION=OFF
endif

ifeq ($(BR2_PACKAGE_LIBSSH_SERVER),y)
LIBSSH_CONF_OPTS += -DWITH_SERVER=ON
else
LIBSSH_CONF_OPTS += -DWITH_SERVER=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH_CONF_OPTS += -DWITH_ZLIB=ON
LIBSSH_DEPENDENCIES += zlib
else
LIBSSH_CONF_OPTS += -DWITH_ZLIB=OFF
endif

ifeq ($(BR2_PACKAGE_LIBSSH_MBEDTLS),y)
LIBSSH_CONF_OPTS += -DWITH_MBEDTLS=ON
LIBSSH_DEPENDENCIES += mbedtls
else ifeq ($(BR2_PACKAGE_LIBSSH_LIBGCRYPT),y)
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=ON
LIBSSH_DEPENDENCIES += libgcrypt
else ifeq ($(BR2_PACKAGE_LIBSSH_OPENSSL),y)
LIBSSH_DEPENDENCIES += openssl
endif

$(eval $(cmake-package))
