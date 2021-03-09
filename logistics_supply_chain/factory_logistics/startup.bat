@echo off

SET mode=startup

if [%1]==[] (
  echo.
) else (
    SET mode=%1
)

echo Welcome to the Project Bonsai Factory Logistics Accelerator.
echo.
echo This window will close once the accelerator is configured.
echo.

set startlog=C:\startup\startlog.txt

powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 startAcc3

  REM If the user is already setup, just close
  IF EXIST %USERPROFILE%\.AnyLogicPLE\anylogic6.license (
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 exitConfigured
     exit /b
  ) ELSE (

     REM check if the example is downloaded
     IF NOT EXIST "C:\anylogic-examples\bonsai-anylogic" (
      
       IF %mode% == startup (
         REM install Edge Chromium
         echo %date% - %time% - Installing Chromium >> %startlog%
         powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 installEdge
         echo Configuring the browser. This may take a moment.
         cd C:\startup
         cmd /c MicrosoftEdgeEnterpriseX64.msi /quiet /norestart

         cmd /c copy c:\startup\dockerinstaller.exe %USERPROFILE%\desktop\Install_Docker.exe

         cmd /c copy c:\startup\run_setup_matlab.mlx %USERPROFILE%\desktop\run_setup_matlab.mlx
       )

       REM go to the root  example directory 
       echo %date% - %time% - Moving to /anylogic-examples > %startlog%
       cd /anylogic-examples


       REM clone the latest to the directory
       echo %date% - %time% - Cloning https://github.com/microsoft/bonsai-anylogic >> %startlog%
       powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 clone_bonsai-anylogic
       cmd /c git clone https://github.com/microsoft/bonsai-anylogic

       REM go to the primary example directory
       echo %date% - %time% - Moving to /anylogic-examples/bonsai-anylogic/samples/abca >> %startlog%
       cd /anylogic-examples/bonsai-anylogic/samples/abca
       

       REM install the Bonsai CLI
       echo %date% - %time% - Installing Bonsai CLI >> %startlog%
       
       IF %mode% == startup (

          pip install bonsai-cli

          powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 installCli

           echo. 
           echo. 
           echo. 
           echo.  
           echo Configuring Bonsai. Please log in with your Azure credentials.
           echo. 
           echo. 
           echo. 
           echo.  
       

           REM configure the user's workspace with Bonsai. This will prompt for a device login and needs to be interactive
           echo %date% - %time% - Running bonsai configure --workspace-id %BONSAI_WORKSPACE% --tenant-id %BONSAI_TENANT% >> %startlog%
           bonsai configure --workspace-id %BONSAI_WORKSPACE% --tenant-id %BONSAI_TENANT%
           powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 configureWorkspace
       )
       
       REM create the user's brain
      echo %date% - %time% - Running bonsai brain create -n "Factory_Logistics_ABCA"  >> %startlog%
      powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 createBrainStart
      powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\createBrain.ps1 "Factory_Logistics_ABCA" "C:/anylogic-examples/bonsai-anylogic/abca.ink"
      powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 createBrainStartComplete

       REM upload the zip file to build a sim from
       powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 uploadPackageStart
       powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\createSimPackage.ps1 ABCA "C:/anylogic-examples/bonsai-anylogic/exported.zip" anylogic-professional-8
       powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 uploadPackageComplete
     )     


     REM start the three tabs for the user
     echo %date% - %time% - Opening https://cloud.anylogic.com/model/d5d019ef-7cf3-4e92-bfdc-1dccd9f9853c?mode=SETTINGS >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openAlCloud
     cmd /c start msedge https://cloud.anylogic.com/model/d5d019ef-7cf3-4e92-bfdc-1dccd9f9853c?mode=SETTINGS
     
     echo %date% - %time% - Opening https://preview.bons.ai/ >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openBonsai
     cmd /c start msedge https://preview.bons.ai/
     
     echo %date% - %time% - Opening https://aka.ms/bsa-docs >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openWalkthrough
     cmd /c start msedge https://docs.microsoft.com/en-us/autonomous-systems/bonsai-accelerators/guides/run-local-factory-logistics

     REM install the inkling extension for VS Code
     echo.
     echo Installing the inkling extesion for Visual Studio Code
     echo.
     echo %date% - %time% - Installing ms-inkling.ms-inkling for VS Code >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 installInkling
     cmd /c code --install-extension ms-inkling.ms-inkling

     REM setup docker for the current user
     @REM echo %date% - %time% - Configuring Docker >> %startlog%
     @REM net localgroup docker-users "BonsaiUser" /ADD

     REM make the directory for AnyLogic to use
     echo %date% - %time% - Running mkdir %USERPROFILE%\.AnyLogicPLE >> %startlog%
     cmd /c mkdir %USERPROFILE%\.AnyLogicPLE

     REM go to the directory
     echo %date% - %time% - Moving to %USERPROFILE%\.AnyLogicPLE >> %startlog%
     cd %USERPROFILE%\.AnyLogicPLE

     REM unzip the default AnyLogic settings to the directory
     echo %date% - %time% - Running tar -xf c:\startup\ple8.7.zip >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 configureAnyLogic
     cmd /c tar -xf c:\startup\ple8.7.zip

     REM set the firewall rules (needs to run for the current user, not before) to allow AnyLogic and Java
     echo %date% - %time% - Importing firewall rules >>  %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 setupFirewall
     cmd /c netsh advfirewall import c:\startup\advfirewallpolicy.wfw 

     REM go to the AnyLogic directory
     echo %date% - %time% - Moving to "C:\Program Files\AnyLogic 8.7 Personal Learning Edition\" >> %startlog%
     cd "C:\Program Files\AnyLogic 8.7 Personal Learning Edition\" 

     IF %mode% == startup (
        REM 'start' AnyLogic --> this will not wait for AnyLogic to close before closing the shell. The ABCA model is loaded per the default settings in the .AnyLogicProfessional directory
        echo %date% - %time% - Starting AnyLogic.exe >> %startlog%
        powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 startAnyLogic
        start AnyLogic.exe
     )

     echo EXITING
     echo %date% - %time% - Script complete >> %startlog%
     powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 setupComplete
     exit /b

  )