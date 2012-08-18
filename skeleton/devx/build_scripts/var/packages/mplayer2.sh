#!/bin/sh

PKG_NAME="mplayer2"
PKG_VER="git160712"
PKG_REV="1"
PKG_DESC="Video player forked from MPlayer"
PKG_CAT="Multimedia"
PKG_DEPS="+ncurses,+libav"

# the commit
PKG_COMMIT="86571435baf116a91a31451d26224600f3575270"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.bz2 ] && return 0
	# download the sources
	download_file http://git.mplayer2.org/mplayer2/snapshot/$PKG_NAME-$PKG_COMMIT.tar.bz2
	[ $? -ne 0 ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xjvf $PKG_NAME-$PKG_VER.tar.bz2
	[ $? -ne 0 ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --confdir=/$CONF_DIR/$PKG_NAME \
	            --disable-static \
	            --disable-libass \
	            --disable-gl \
	            --disable-dga2 \
	            --disable-dga1 \
	            --disable-vesa \
	            --disable-svga \
	            --disable-sdl \
	            --disable-aa \
	            --disable-caca \
	            --disable-ggi \
	            --disable-ggiwmh \
	            --disable-direct3d \
	            --disable-directx \
	            --disable-dxr3 \
	            --disable-ivtv \
	            --disable-v4l2 \
	            --disable-dvb \
	            --disable-mga \
	            --disable-xmga \
	            --disable-xshape \
	            --enable-fbdev \
	            --disable-3dfx \
	            --disable-tdfxfb \
	            --disable-s3fb \
	            --disable-wii \
	            --disable-directfb \
	            --disable-bl \
	            --disable-tdfxvid \
	            --disable-xvr100 \
	            --disable-tga \
	            --disable-pnm \
	            --disable-md5sum \
	            --disable-yuv4mpeg \
	            --disable-coreaudio \
	            --disable-cocoa \
	            --disable-ossaudio \
	            --disable-rsound \
	            --disable-pulse \
	            --disable-jack \
	            --disable-openal \
	            --disable-nas \
	            --disable-sunaudio \
	            --disable-win32waveout \
	            --language-msg=en \
	            --disable-runtime-cpudetection \
	            --disable-debug \
	            --disable-sighandler \
	            --disable-crash-debug
	[ $? -ne 0 ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ $? -ne 0 ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ $? -ne 0 ] && return 1

	# install the sample configuration
	install -D -m644 etc/codecs.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/codecs.conf
	[ $? -ne 0 ] && return 1
	install -D -m644 etc/input.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/input.conf
	[ $? -ne 0 ] && return 1
	install -D -m644 etc/example.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/example.conf
	[ $? -ne 0 ] && return 1

	# install the list of authors and the copyright notice
	install -D -m644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ $? -ne 0 ] && return 1
	install -D -m644 Copyright $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/Copyright
	[ $? -ne 0 ] && return 1

	return 0
}
