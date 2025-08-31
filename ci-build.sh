#!/bin/bash
cd "$(dirname "$0")"
source 'ci-library.sh'
mkdir artifacts
mkdir sourcepkg

# https://github.com/msys2/msys2-autobuild/issues/62
# https://github.com/lazka/msys2-autobuild/commit/42c04bf2231afafc000d06fe6360258d83c30ed7
if [ "$MINGW_ARCH" == "clangarm64" ]; then
  pkgprefix="mingw-w64-clang-aarch64"
  mkdir -p /etc/pacman.d/hooks
  touch /etc/pacman.d/hooks/texinfo-install.hook
  touch /etc/pacman.d/hooks/texinfo-remove.hook
else
  pkgprefix="mingw-w64-clang-x86_64" 
fi

# Enable custom -next repos (this will break msys2 toolchains that use dll's)
cp -f pacman.conf /etc/pacman.conf

cd artifacts
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-clang-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-clang-libs-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-clang-tools-extra-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-clang-analyzer-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-compiler-rt-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-gcc-compat-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-libc++-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-libunwind-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-lld-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-lldb-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-llvm-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-llvm-libs-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-llvm-openmp-19.1.7-1-any.pkg.tar.zst
curl -fOL https://repo.msys2.org/mingw/$MINGW_ARCH/$pkgprefix-polly-19.1.7-1-any.pkg.tar.zst

# Prepare for deploy
##cd artifacts || success 'All packages built successfully'
execute 'Updating pacman repository index' create_pacman_repository "${PACMAN_REPOSITORY}"
execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY}"
execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
