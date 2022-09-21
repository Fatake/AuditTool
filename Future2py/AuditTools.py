#!/usr/bin/python3
from pytest import ExitCode
import Utils.Argsparse as args
from Utils.Colors import Colors as C
import os
import sys

def main():
    argv = args.GetArgs()
    print(f"Script path: {os.getcwdb()}")
    print(f"Args: {argv}")

    if argv.init == True:
        print("Iniciando Carpetas")
        #subprocess.call(shlex.split('./InitFolders.sh'))
        os.system("bash InitFolders.sh")
        sys.exit(ExitCode.OK)

def logo():
    print(C.RED + C.BOLD)
    print("""
       d8888               888 d8b 888       88888888888                888\n 
      d88888               888 Y8P 888           888                    888\n
     d88P888               888     888           888                    888\n
    d88P 888 888  888  .d88888 888 888888        888   .d88b.   .d88b.  888\n 
   d88P  888 888  888 d88" 888 888 888           888  d88""88b d88""88b 888\n
  d88P   888 888  888 888  888 888 888  888888   888  888  888 888  888 888\n
 d8888888888 Y88b 888 Y88b 888 888 Y88b.         888  Y88..88P Y88..88P 888\n
d88P     888  "Y88888  "Y88888 888  "Y888        888   "Y88P"   "Y88P"  888\n                                                                          
""")
    print(C.ENDC)
    print("Made with love by:")
    print(f"[{C.GREEN}+{C.ENDC}] @cthulhu897")
    print(f"[{C.GREEN}+{C.ENDC}] @rossJxd")
    print(f"[{C.GREEN}+{C.ENDC}] @Fatake")


if __name__ == "__main__":
    logo()
    print("\n<----------------------->")
    main()
   