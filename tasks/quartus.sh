# Download and install Quartus II 13 and pre-requisite packages
INSTALL_DIR="$HOME/.local/share/altera/13.0sp1"

# 32 bit glibc must be installed prior to running the Quartus setup
if [[ ! -f /lib/ld-linux.so.2 ]]; then
  sudo dpkg --add-architecture i386
  sudo apt update && sudo apt install -y libc6:i386
fi

SCRATCH_DIR=$(mktemp -qd) && {
  cd "$SCRATCH_DIR" || exit
  mkdir quartus_installer
  wget https://downloads.intel.com/akdlm/software/acdsinst/13.0sp1/232/ib_tar/Quartus-web-13.0.1.232-linux.tar
  wget /tmp/ http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
  wget http://old-releases.ubuntu.com/ubuntu/pool/universe/t/tbb/libtbb2_4.1~20130613-1.2_amd64.deb

  tar -C quartus_installer -xvf Quartus-web-13.0.1.232-linux.tar
  mkdir -p "$INSTALL_DIR"
  "$SCRATCH_DIR/quartus_installer/components/QuartusSetupWeb-13.0.1.232.run" --mode unattended --unattendedmodeui minimal --installdir "$INSTALL_DIR"
  if $?; then
    errno=$?
    echo "Quartus installer failed with error code $?"
    exit $errno
  fi

  # Patch the libraries
  mkdir libpng_temp
  dpkg-deb -xv libpng12-0_1.2.54-1ubuntu1.1_amd64.deb libpng_temp
  cp -af libpng_temp/lib/x86_64-linux-gnu/* "$INSTALL_DIR/quartus/linux64/"
  mkdir libtbb_temp
  dpkg-deb -xv libtbb2_4.1~20130613-1.2_amd64.deb libtbb_temp
  cp -af libtbb_temp/usr/lib/* "$INSTALL_DIR/quartus/linux64/"
}
rm -rf "$SCRATCH_DIR"
unset -v "$SCRATCH_DIR"

cat > "$HOME/.local/bin/quartus" <<%EOF
#!/bin/bash
export QUARTUS_DIR="${INSTALL_DIR}/quartus"
export PATH+=":${QUARTUS_DIR}/bin"
export QUARTUS_64BIT=1
exec quartus --64bit "\$@"
%EOF

chmod +x "$HOME/.local/bin/quartus"
