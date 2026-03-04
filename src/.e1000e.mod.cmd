savedcmd_e1000e.mod := printf '%s\n'   netdev.o ethtool.o ich8lan.o mac.o nvm.o phy.o manage.o 80003es2lan.o 82571.o param.o ptp.o kcompat.o | awk '!x[$$0]++ { print("./"$$0) }' > e1000e.mod
