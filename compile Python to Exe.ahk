#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




; Function to open file picker dialog
FilePicker(VarName, Options := "") {
    ; Store the current value
    PrevValue := %VarName%
    
    ; Open the file picker dialog
    FileSelectFile, %VarName%, %Options%
    
    ; Check if the user canceled the dialog and restore the previous value
    if (VarName = 0)
        %VarName% := PrevValue
}

; Function to open folder picker dialog
FolderPicker(VarName, Options := "") {
    ; Store the current value
    PrevValue := %VarName%
    
    ; Open the folder picker dialog
    FileSelectFolder, %VarName%, %Options%
    
    ; Check if the user canceled the dialog and restore the previous value
    if (VarName = 0)
        %VarName% := PrevValue
}



; Define the INI file path
IniFilePath := A_ScriptDir "\config.ini"

Gui, Add, Text, cBlue, Note: All assets must be in a folder which is in the same directory as your Python file.

; Add this line after the last Gui, Add, Button line
Gui, Add, Button,  h25 gOpenExample, !!! When importing files do this !!!
Gui, Add, Text,,
Gui, Add, Text,,

Gui, Add, Text,, Python Install Directory:
Gui, Add, Edit, vPythonDir w480
Gui, Add, Button, w80 h25 gBrowseDir, Browse

Gui, Add, Text,, Python File:
Gui, Add, Edit, vPythonFile w480
Gui, Add, Button, w80 h25 gBrowseFile, Browse

Gui, Add, Text,, Icon File (Optional):
Gui, Add, Edit, vIconFile w480
Gui, Add, Button, w80 h25 gBrowseIcon, Browse

Gui, Add, Text,, Assets Directory (Optional):
Gui, Add, Edit, vAssetsDir w480
Gui, Add, Button, w80 h25 gBrowseAssets, Browse

Gui, Add, Text,, Executable Name:
Gui, Add, Edit, vExecName w480

Gui, Add, Button, w100 h30 gCompileButton, Compile

; Load values from the INI file
IniRead, PythonDir, %IniFilePath%, Settings, PythonDir
IniRead, PythonFile, %IniFilePath%, Settings, PythonFile
IniRead, IconFile, %IniFilePath%, Settings, IconFile
IniRead, ExecName, %IniFilePath%, Settings, ExecName
IniRead, AssetsDir, %IniFilePath%, Settings, AssetsDir

; Check if any user inputted variable is "ERROR" and set it to ""
if (PythonDir = "ERROR")
    PythonDir := ""
if (PythonFile = "ERROR")
    PythonFile := ""
if (IconFile = "ERROR")
    IconFile := ""
if (AssetsDir = "ERROR")
    AssetsDir := ""
if (ExecName = "ERROR")
    ExecName := ""

GuiControl, , PythonDir, %PythonDir%
GuiControl, , PythonFile, %PythonFile%
GuiControl, , IconFile, %IconFile%
GuiControl, , ExecName, %ExecName%
GuiControl, , AssetsDir, %AssetsDir%

Gui, Show, w500 h500, Python Compiler

return

BrowseDir:
Gui, Submit, NoHide
FileSelectFolder, PythonDir, 4, %PythonDir%, Choose Directory
GuiControl, , PythonDir, %PythonDir%
return

BrowseFile:
Gui, Submit, NoHide
FileSelectFile, PythonFile, 3, %PythonFile%, Choose File
GuiControl, , PythonFile, %PythonFile%
return

BrowseIcon:
Gui, Submit, NoHide
FileSelectFile, IconFile, 3, %IconFile%, Choose File
GuiControl, , IconFile, %IconFile%
return

BrowseAssets:
Gui, Submit, NoHide
FileSelectFolder, AssetsDir, 4, %AssetsDir%, Choose Directory
GuiControl, , AssetsDir, %AssetsDir%
return

CompileButton:

Gui, Submit, NoHide

; Save values to the INI file
IniWrite, %PythonDir%, %IniFilePath%, Settings, PythonDir
IniWrite, %PythonFile%, %IniFilePath%, Settings, PythonFile
IniWrite, %IconFile%, %IniFilePath%, Settings, IconFile
IniWrite, %ExecName%, %IniFilePath%, Settings, ExecName
IniWrite, %AssetsDir%, %IniFilePath%, Settings, AssetsDir

; Check if PythonDir is not blank and contains python.exe
if (PythonDir = "" or !FileExist(PythonDir "\Python.exe"))
{
    MsgBox, 16, Error, Invalid Python Directory or Python.exe not found.
    return
}

; Check if PythonFile is not blank and has a .py extension
if (PythonFile = "" or !RegExMatch(PythonFile, "i)\.py$"))
{
    MsgBox, 16, Error, Invalid Python File or not a .py file.
    return
}

; Check if IconFile is not blank and has a .ico extension
if (IconFile != "" and !RegExMatch(IconFile, "i)\.ico$"))
{
    MsgBox, 16, Error, Invalid Icon File or not a .ico file.
    return
}

; Install or upgrade pyinstaller
RunWait, %PythonDir%\Python.exe -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pyinstaller

; Compile the Python script
CompileCmd := """" . PythonDir . "\Scripts\pyinstaller.exe"" --distpath=""."" --onefile --name=""" . ExecName . """"
if (IconFile != "")
    CompileCmd := CompileCmd . " --icon=""" . IconFile . """"
if (AssetsDir != "")
	SplitPath, AssetsDir, DirName
    CompileCmd := CompileCmd . " --add-data=""" . AssetsDir . ";" . DirName . """"
CompileCmd := CompileCmd . " """ . PythonFile . """"

; Set the working directory to the directory of the Python file
FileGetAttrib, FileAttributes, %PythonFile%
; If PythonFile is a file, set the working directory to the directory containing the file
SplitPath, PythonFile, , , Dir

RunWait, %CompileCmd%, %Dir%, , CompileExitCode

; Display an info box indicating the completion of the process with an indeterminate success message
MsgBox, 64, Process Completed, The compilation process has finished. Please check the results.


return


GuiClose:
ExitApp
return


OpenExample:
    ; Create the example window
    Gui, Example: New
    Gui, Example: Add, Edit, w600 h400 vExampleText ReadOnly r20
    Gui, Example: Show, w640 h480, Example way to use this tool

    ; Set the Python syntax-highlighted code in the example window
    ExampleCode := "import sys`n" . "import os`n" . "def resource_path(relative_path):`n" . "	# Get absolute path to resource, works for dev and for PyInstaller`n" . "	base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))`n" . "	return os.path.join(base_path, relative_path)`n`n" . "oldPath = 'assetsFileName/assetFile.txt'`n" . "newPath = resource_path(oldPath)`n"
    GuiControl, Example:, ExampleText, %ExampleCode%
    return

; Add this line after the GuiClose: label
OpenExampleGuiClose:
    Gui, Example: Destroy
    return

; Add these lines at the end of the CompileButton label, after the MsgBox line
; Open the Example window when the user clicks "This Way" button
OpenExampleButton:
    Gui, Example: Show
    return