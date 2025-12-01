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
  InstallDirRegKey HKCU "Software\Nightbird" "Install_Dir"

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
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Nightbird"
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

  SetOutPath "$INSTDIR\Source"
  File /r "Source\*.*"
  
  SetOutPath "$INSTDIR\Binaries"
  File /r "Binaries\*.*"
  
  ; Store installation folder
  WriteRegStr HKCU "Software\Nightbird" "Install_Dir" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ; Add to Add or Remove Programs
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "DisplayName" "Nightbird Engine"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird" "Publisher" "Nightbird"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
	
	; Create shortcuts
	CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Nightbird Editor.lnk" "$INSTDIR\Binaries\Release-windows-x86_64\Editor.exe" "" "$INSTDIR\Binaries\Release-windows-x86_64"
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
  RMDir /r "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\Nightbird Editor.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  
  DeleteRegKey HKCU "Software\Nightbird"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nightbird"

SectionEnd