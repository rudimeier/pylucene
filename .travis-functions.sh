#!/bin/bash

#
# .travis-functions.sh:
#   - helper functions to be sourced from .travis.yml
#   - designed to respect travis' environment but testing locally is possible
#

if [ ! -f "INSTALL" ]; then
	echo ".travis-functions.sh must be sourced from source dir" >&2
	return 1 || exit 1
fi

function travis_show_env
{
	# don't show secret "travis secure variables"
	env | grep -v "SECRET_" | LC_ALL=C sort

	# obscurity, we don't use a real sectret for now
	SECRET_DL_URL="travis:$(shasum <<<Aix0Nu4UChij4loh | cut -f1 -d' ')@akne.unxz.net/~rudi/travis"
}

function travis_have_sudo
{
	HAVE_SUDO="no"
	if test "$(sudo id -ru)" = "0"; then
		HAVE_SUDO="yes"
	fi
	echo "HAVE_SUDO=$HAVE_SUDO"
}

function travis_jdk_switcher
{
	# There is no jdk_switcher on travis OSX images :(
	if test "$TRAVIS_OS_NAME" != "osx"; then
		jdk_switcher use "$TESTJDK"
	else
		export JAVA_HOME=$(/usr/libexec/java_home)
	fi
}

function install_deps_osx
{
	brew update >/dev/null
	brew install \
		ant \
		|| return
}

function install_deps_linux
{
	true
}

function travis_install_script
{
	if [ "$TRAVIS_OS_NAME" = "osx" ]; then
		install_deps_osx || return
	else
		install_deps_linux || return
	fi

	# installing jcc requires not too old setuptools
	pip install --upgrade setuptools || return
	git clone --quiet git://github.com/rudimeier/jcc.git ~/builds/jcc || return
	pushd ~/builds/jcc || return
	JCC_JDK="$JAVA_HOME" python setup.py install || return
	popd
}

function travis_build
{
	python --version
	java -version

	make
	make test
}

function travis_script
{
	local ret
	set -o xtrace

	travis_build
	ret=$?

	set +o xtrace
	return $ret
}
