# PythonCompiler
A Python compiler made using autohotkey and pyinstaller

## Usage
You must have python installed (and pip must work)
1. Download the executable from releases and run the file
2. Input the directory of where your python version is so that the right libraries can be used. (The directory where the python executable is located) 
3. Input the location of the python script
4. (Optional) Input the location of the icon file
5. (Optional) Input the location of the assets directory
6. Input the name of the executable
7. Press Compile and wait
8. Your exe should be in the directory of the compiler (You can delete the other created files)

## !!! Important information !!!

You have to use this code when importing files into your python file
```python
import sys
import os
def resource_path(relative_path):
	# Get absolute path to resource, works for dev and for PyInstaller
	base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
	return os.path.join(base_path, relative_path)
```
```python
newPath = resource_path(oldPath)
```
This is to get the absolute paths right

All assets must be in a folder which is in the same folder as the python file is.
```
- WorkingFolder
  -pythonFile.py
  -AssetsDirectory
    -asset1.png
    -asset2.txt
    -asset3.mov
```

## How it works

It uses the specified python install to install or update the pyinstaller module which facilitates for the compilation of python files to exe. It then runs the pyinstaller code with the command line argumants that you specified using the program to make the executable.

## Building from source
I used the built in compiler for autohotkey that comes with autohotkey. It is also possible to run the source code if autohotkey is alredy installed.
