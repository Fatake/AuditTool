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
   _____          __           ___________           .__   
  /  _  \  __ ___/  |_  ____   \__    ___/___   ____ |  |  
 /  /_\  \|  |  \   __\/  _ \    |    | /  _ \ /  _ \|  |  
/    |    \  |  /|  | (  <_> )   |    |(  <_> |  <_> )  |__
\____|__  /____/ |__|  \____/    |____| \____/ \____/|____/
        \/                                                 
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
   