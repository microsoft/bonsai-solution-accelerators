@echo off

SET mode=startup

if [%1]==[] (
  echo.
) else (
    SET mode=%1
)

echo Welcome to the Project Bonsai Chemical Processing Accelerator.
echo.
echo This window will close once the accelerator is configured.
echo.

set startlog=C:\startup\startlog.txt

powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 startAcc4

REM check if the example is downloaded
IF NOT EXIST "C:\mathworks-examples\bonsai-simulink" (

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
   echo %date% - %time% - Moving to /mathworks-examples > %startlog%
   cd /mathworks-examples


   REM clone the latest to the directory
   echo %date% - %time% - Cloning https://github.com/microsoft/bonsai-simulink >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 clone_bonsai-simulink
   cmd /c git clone https://github.com/microsoft/bonsai-simulink

   REM go to the primary example directory
   echo %date% - %time% - Moving to /mathworks-examples/bonsai-simulink/samples/chemical-process-optimization >> %startlog%
   cd /mathworks-examples/bonsai-simulink/samples/chemical-process-optimization
   
   REM zip the directory for upload --> The *.* part is important to not create a root folder, since the upload will fail if we do
   cmd /c powershell.exe -Command Compress-Archive -Path *.* -DestinationPath chemical-process-optimization.zip

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
   echo %date% - %time% - Running bonsai brain create -n "Chemical_Processing_Simulink" >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 createBrainStart

   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\createBrain.ps1 "Chemical_Processing_Simulink" "c:/mathworks-examples/bonsai-simulink/samples/chemical-process-optimization/machine_teacher.ink"
   
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 createBrainStartComplete
   @REM bonsai brain create -n "Chemical_Processing_Simulink" 

   @REM bonsai brain show --name "Chemical_Processing_Simulink" 

   @REM REM update the inkling for the brain
   @REM echo %date% - %time% - Running bonsai brain version update-inkling --name "Chemical_Processing_Simulink"  --version 1 --file="./machine_teacher.ink" >> %startlog%
   @REM powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 updateInkling
   @REM bonsai brain version update-inkling --name "Chemical_Processing_Simulink"  --version 1 --file="./machine_teacher.ink" 

   @REM bonsai brain show --name "Chemical_Processing_Simulink" 

   REM upload the zip file to build a sim from
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 uploadPackageStart
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\createSimPackage.ps1 Chemical_Process_MW "c:/mathworks-examples/bonsai-simulink/samples/chemical-process-optimization/chemical-process-optimization.zip" mathworks-simulink-2020b
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 uploadPackageComplete

   REM start the three tabs for the user

   echo %date% - %time% - Opening https://matlab.mathworks.com >> %startlog%
   @REM cmd /c start msedge https://www.mathworks.com/campaigns/products/trials.html
   cmd /c start msedge https://matlab.mathworks.com
   
   echo %date% - %time% - Opening https://preview.bons.ai/ >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openBonsai
   cmd /c start msedge https://preview.bons.ai/

   echo %date% - %time% - Opening https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/chemical_processing/mw/getting_started_mfg.md >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openWalkthrough
   cmd /c start msedge https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/chemical_processing/mw/getting_started_mfg.md

   REM install the inkling extension for VS Code
   echo.
   echo Installing the inkling extesion for Visual Studio Code
   echo.
   echo %date% - %time% - Installing ms-inkling.ms-inkling for VS Code >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 installInkling
   cmd /c code --install-extension ms-inkling.ms-inkling

   echo EXITING
   echo %date% - %time% - Script complete >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 setupComplete
   exit /b
) ELSE (
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 exitConfigured
   exit /b
)