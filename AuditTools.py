#!/usr/bin/python3
import Utils.Argsparse as args
import os
import sys
import subprocess
import shlex

argv = args.GetArgs()

print(f"Script path: {os.getcwdb()}")
print(f"Args: {argv}")

if argv.init == True:
    print("Iniciando Carpetas")
    #subprocess.call(shlex.split('./InitFolders.sh'))
    os.system("bash InitFolders.sh")
