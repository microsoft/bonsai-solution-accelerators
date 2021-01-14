@echo off

SET mode=startup

if [%1]==[] (
  echo.
) else (
    SET mode=%1
)

echo Welcome to the Project Bonsai Energy Management Accelerator.
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
      cd C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.9\Downloads\0
      cmd /c MicrosoftEdgeEnterpriseX64.msi /quiet /norestart

      cmd /c copy dockerinstaller.exe %USERPROFILE%\desktop\Install_Docker.exe

      cmd /c copy run_setup_matlab.mlx %USERPROFILE%\desktop\run_setup_matlab.mlx
   )

   REM go to the root  example directory 
   echo %date% - %time% - Moving to /mathworks-examples > %startlog%
   cd /mathworks-examples


   REM clone the latest to the directory
   echo %date% - %time% - Cloning https://github.com/microsoft/bonsai-simulink >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 clone_bonsai-simulink
   cmd /c git clone -b jill_journeyman/bem https://github.com/microsoft/bonsai-simulink

   REM go to the primary example directory
   echo %date% - %time% - Moving to /mathworks-examples/bonsai-simulink/samples/cartpole >> %startlog%
   cd /mathworks-examples/bonsai-simulink/samples/building_energy_management
   
   cmd /c powershell.exe -Command Compress-Archive . building_energy_management.zip

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
   
   REM ---------------
   REM THIS SECTION MAY MOVE TO ELSEWHERE IN THE STACK

   REM create the user's brain
   echo %date% - %time% - Running bonsai brain create -n "Energy_Management_Simulink"  >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 createBrain
   bonsai brain create -n "Energy_Management_Simulink" 

   REM update the inkling for the brain
   echo %date% - %time% - Running bonsai brain version update-inkling --name "Energy_Management_Simulink"  --version 1 --file="./buildingEnergyManagement.ink" >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 updateInkling
   bonsai brain version update-inkling --name "Energy_Management_Simulink"  --version 1 --file="./buildingEnergyManagement.ink" 

   @REM IF %mode% == startup (
   @REM    echo. 
   @REM    echo. 
   @REM    echo. 
   @REM    echo.  
   @REM    echo Configuring Azure. You will be prompted for your Azure credentials.
   @REM    echo. 
   @REM    echo. 
   @REM    echo. 
   @REM    echo.  
   

   @REM    REM log the user in to Azure to run the container creation
   @REM    echo %date% - %time% - Running az login >> %startlog%
   
   @REM    cmd /c az login
   @REM    powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 azLogin
   @REM )

   @REM REM make sure the user is on the correct subscription by default
   @REM echo %date% - %time% - az account set --subscription %BONSAI_SUBSCRIPTION% >> %startlog%
   @REM powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 setAzSubscription
   @REM cmd /c az account set --subscription %BONSAI_SUBSCRIPTION% 

   @REM REM the user needs to be authenticated to ACR -- expose token for no docker
   @REM echo %date% - %time% - az acr login --name %BONSAI_ACR% --expose-token >> %startlog%
   @REM powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 acrLogin
   @REM cmd /c az acr login --name %BONSAI_ACR% --expose-token 

   @REM REM build the container image using the dockerfile from the current directory
   @REM echo %date% - %time% - Running az acr build --registry %BONSAI_ACR% --image simulink-cartpole:v1 . >> %startlog%
   @REM powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 acrBuild
   @REM cmd /c az acr build --registry %BONSAI_ACR% --image simulink-cartpole:v1 . 

   @REM REM -------------------------------
   @REM REM TODO: Zip up directory or need a dockerfile
   @REM REM -------------------------------

   @REM REM now add the sim package for the user
   @REM REM set url=https://%BONSAI_ACR%.azurecr.io/mathworks-abca:v1 %ImageName% 
   @REM echo %date% - %time% - Running bonsai simulator package add -n "Energy Management - Simulink" -u %BONSAI_ACR%.azurecr.io/simulink-cartpole:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50 >> %startlog%
   @REM powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 addSimPackage
   @REM bonsai simulator package add -n "Energy Management - Simulink" -u %BONSAI_ACR%.azurecr.io/simulink-cartpole:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50      

   REM start the three tabs for the user

   echo %date% - %time% - Opening https://matlab.mathworks.com >> %startlog%
   @REM cmd /c start msedge https://www.mathworks.com/campaigns/products/trials.html
   cmd /c start msedge https://matlab.mathworks.com

   echo %date% - %time% - Opening https://preview.bons.ai/ >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openBonsai
   cmd /c start msedge https://preview.bons.ai/

   echo %date% - %time% - Opening https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/energy_management/mw/getting_started_mfg.md >> %startlog%
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 openWalkthrough
   cmd /c start msedge https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/energy_management/mw/getting_started_mfg.md

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
)
ELSE (
   powershell.exe -ExecutionPolicy Unrestricted -File C:\startup\logger.ps1 exitConfigured
   exit /b
)