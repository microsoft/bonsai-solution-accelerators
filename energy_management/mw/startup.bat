@echo off

SET mode=startup

if [%1]==[] (
  echo.
) else (
    SET mode=%1
)

echo %mode% mode

set startlog=C:\startup\startlog.txt


REM check if the example is downloaded
IF NOT EXIST "C:\mathworks-examples\bonsai-simulink" (

   IF %mode% == startup (
      REM install Edge Chromium
      echo %date% - %time% - Installing Chromium >> %startlog%
      echo Configuring the browser. This may take a moment.
      cd C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.9\Downloads\0
      cmd /c MicrosoftEdgeEnterpriseX64.msi /quiet /norestart

      REM cmd /c copy dockerinstaller.exe %USERPROFILE%\desktop\Install_Docker.exe
   )

   REM go to the root  example directory 
   echo %date% - %time% - Moving to /mathworks-examples > %startlog%
   cd /mathworks-examples


   REM clone the latest to the directory
   echo %date% - %time% - Cloning https://github.com/microsoft/bonsai-simulink >> %startlog%
   cmd /c git clone https://github.com/microsoft/bonsai-simulink

   REM go to the primary example directory
   echo %date% - %time% - Moving to /mathworks-examples/bonsai-simulink/samples/cartpole >> %startlog%
   cd /mathworks-examples/bonsai-simulink/samples/cartpole
   

   REM install the Bonsai CLI
   echo %date% - %time% - Installing Bonsai CLI >> %startlog%
   
   IF %mode% == startup (
      pip install bonsai-cli

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
      echo %date% - %time% - Running bonsai configure --workspace-id %BONSAI_WORKSPACE% >> %startlog%
      bonsai configure --workspace-id %BONSAI_WORKSPACE% 
   )
   
   REM create the user's brain
   echo %date% - %time% - Running bonsai brain create -n simulink-cartpole >> %startlog%
   bonsai brain create -n simulink-cartpole 

   REM update the inkling for the brain
   echo %date% - %time% - Running bonsai brain version update-inkling --name simulink-cartpole --version 1 --file="./cartpole.ink" >> %startlog%
   bonsai brain version update-inkling --name simulink-cartpole --version 1 --file="./cartpole.ink" 

   IF %mode% == startup (
      echo. 
      echo. 
      echo. 
      echo.  
      echo Configuring Azure. You will be prompted for your Azure credentials.
      echo. 
      echo. 
      echo. 
      echo.  
   

      REM log the user in to Azure to run the container creation
      echo %date% - %time% - Running az login >> %startlog%
   
      cmd /c az login
   )

   REM make sure the user is on the correct subscription by default
   echo %date% - %time% - az account set --subscription %BONSAI_SUBSCRIPTION% >> %startlog%
   cmd /c az account set --subscription %BONSAI_SUBSCRIPTION% 

   REM the user needs to be authenticated to ACR -- expose token for no docker
   echo %date% - %time% - az acr login --name %BONSAI_ACR% --expose-token >> %startlog%
   cmd /c az acr login --name %BONSAI_ACR% --expose-token 

   REM build the container image using the dockerfile from the current directory
   echo %date% - %time% - Running az acr build --registry %BONSAI_ACR% --image simulink-cartpole:v1 . >> %startlog%
   cmd /c az acr build --registry %BONSAI_ACR% --image simulink-cartpole:v1 . 

   REM now add the sim package for the user
   REM set url=https://%BONSAI_ACR%.azurecr.io/mathworks-abca:v1 %ImageName% 
   echo %date% - %time% - Running bonsai simulator package add -n "Simulink Cartpole" -u %BONSAI_ACR%.azurecr.io/simulink-cartpole:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50 >> %startlog%
   bonsai simulator package add -n "Simulink Cartpole" -u %BONSAI_ACR%.azurecr.io/simulink-cartpole:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50      

   REM start the three tabs for the user

   echo %date% - %time% - Opening https://matlab.mathworks.com >> %startlog%
   cmd /c start msedge https://matlab.mathworks.com/

   echo %date% - %time% - Opening https://preview.bons.ai/ >> %startlog%
   cmd /c start msedge https://preview.bons.ai/

   echo %date% - %time% - Opening https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/energy_management/mw/getting_started_mfg.md >> %startlog%
   cmd /c start msedge https://github.com/microsoft/bonsai-solution-accelerators/blob/mw/energy_management/mw/getting_started_mfg.md

   REM install the inkling extension for VS Code
   echo.
   echo Installing the inkling extesion for Visual Studio Code
   echo.
   echo %date% - %time% - Installing ms-inkling.ms-inkling for VS Code >> %startlog%
   cmd /c code --install-extension ms-inkling.ms-inkling

   echo EXITING
   echo %date% - %time% - Script complete >> %startlog%
   exit /b
)
ELSE (
   exit /b
)