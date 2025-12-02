; Nightbird Installer Script
; Based on Start Menu Folder Selection Example Written by Joost Verburg

;--------------------------------
; Include Modern UI

  !include "MUI2.nsh"
  
;--------------------------------
; General

  ; Name and file
  Name "Nightbird Engine"
  OutFile "NightbirdInstaller.exe"
  Unicode True

  ; Default installation folder
  InstallDir "$PROGRAMFILES64\Nightbird"
  
  ; Get installation folder from registry if available
  InstallDirRegKey HKLM "SOFTWARE\Nightbird" "InstallDir"

  ; Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
; Variables

  Var StartMenuFolder

;--------------------------------
; Interface Settings

  !define MUI_ABORTWARNING
  
;--------------------------------
; Pages

  !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  
  ; Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "SOFTWARE\Nightbird"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
; Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer Sections

Section "Nightbird Engine" SecNightbird
  SetRegView 64
  
  SetOutPath "$INSTDIR\Source"
  File /r "Source\*.*"
  
  SetOutPath "$INSTDIR\Binaries"
  File /r "Binaries\*.*"
  
  SetOutPath "$INSTDIR\Binaries\Release-windows-x86_64"
  
  ; Store installation folder
  WriteRegStr HKLM "SOFTWARE\Nightbird" "InstallDir" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ; Add to Add or Remove Programs
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "DisplayName" "Nightbird Engine"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "Publisher" "Nightbird"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
	
	; Create shortcuts
	CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Nightbird Editor.lnk" "$INSTDIR\Binaries\Release-windows-x86_64\Editor.exe"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

;--------------------------------
; Descriptions

  ; Language strings
  LangString DESC_SecNightbird ${LANG_ENGLISH} "Installs Nightbird Engine."

  ; Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecNightbird} $(DESC_SecNightbird)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
; Uninstaller Section

Section "Uninstall"
  SetRegView 64
  
  RMDir /r "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\Nightbird Editor.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir /r "$SMPROGRAMS\$StartMenuFolder"
  
  DeleteRegKey HKLM "SOFTWARE\Nightbird"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird"
  
SectionEnd
