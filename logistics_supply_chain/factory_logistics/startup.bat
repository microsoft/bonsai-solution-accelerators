@echo off

SET mode=startup

if [%1]==[] (
  echo.
) else (
    SET mode=%1
)

echo %mode% mode

set startlog=C:\startup\startlog.txt

  REM If the user is already setup, just close
  IF EXIST %USERPROFILE%\.AnyLogicPLE\anylogic6.license (
     exit /b
  ) ELSE (

     REM check if the example is downloaded
     IF NOT EXIST "C:\anylogic-examples\bonsai-anylogic" (
      
       IF %mode% == startup (
         REM install Edge Chromium
         echo %date% - %time% - Installing Chromium >> %startlog%
         echo Configuring the browser. This may take a moment.
         cd C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.9\Downloads\0
         cmd /c MicrosoftEdgeEnterpriseX64.msi /quiet /norestart

         cmd /c copy dockerinstaller.exe %USERPROFILE%\desktop\Install_Docker.exe
       )

       REM go to the root  example directory 
       echo %date% - %time% - Moving to /anylogic-examples > %startlog%
       cd /anylogic-examples


       REM clone the latest to the directory
       echo %date% - %time% - Cloning https://github.com/microsoft/bonsai-anylogic >> %startlog%
       cmd /c git clone https://github.com/microsoft/bonsai-anylogic

       REM go to the primary example directory
       echo %date% - %time% - Moving to /anylogic-examples/bonsai-anylogic/samples/abca >> %startlog%
       cd /anylogic-examples/bonsai-anylogic/samples/abca
       

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
       echo %date% - %time% - Running bonsai brain create -n AnyLogic-ABCA >> %startlog%
       bonsai brain create -n AnyLogic-ABCA 

       REM update the inkling for the brain
       echo %date% - %time% - Running bonsai brain version update-inkling --name AnyLogic-ABCA --version 1 --file="./abca.ink" >> %startlog%
       bonsai brain version update-inkling --name AnyLogic-ABCA --version 1 --file="./abca.ink" 

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
       REM set ImageName=anylogic-abca:v1 --> doesnt seem to work
       echo %date% - %time% - Running az acr build --registry %BONSAI_ACR% --image anylogic-abca:v1 . >> %startlog%
       cmd /c az acr build --registry %BONSAI_ACR% --image anylogic-abca:v1 . 

       REM now add the sim package for the user
       REM set url=https://%BONSAI_ACR%.azurecr.io/anylogic-abca:v1 %ImageName% 
       echo %date% - %time% - Running bonsai simulator package add -n "ABCA" -u %BONSAI_ACR%.azurecr.io/anylogic-abca:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50 >> %startlog%
       bonsai simulator package add -n "ABCA" -u %BONSAI_ACR%.azurecr.io/anylogic-abca:v1 -i 25 -r 1.0 -m 1.0 -p Linux --max-instance-count 50 

     )     


     REM start the three tabs for the user
     echo %date% - %time% - Opening https://cloud.anylogic.com/model/d5d019ef-7cf3-4e92-bfdc-1dccd9f9853c?mode=SETTINGS >> %startlog%
     cmd /c start msedge https://cloud.anylogic.com/model/d5d019ef-7cf3-4e92-bfdc-1dccd9f9853c?mode=SETTINGS
     
     echo %date% - %time% - Opening https://preview.bons.ai/ >> %startlog%
     cmd /c start msedge https://preview.bons.ai/
     
     echo %date% - %time% - Opening https://github.com/microsoft/bonsai-solution-accelerators/blob/main/logistics_supply_chain/factory_logistics/getting_started_mfg.md >> %startlog%
     cmd /c start msedge https://github.com/microsoft/bonsai-solution-accelerators/blob/main/logistics_supply_chain/factory_logistics/getting_started_mfg.md

     REM install the inkling extension for VS Code
     echo.
     echo Installing the inkling extesion for Visual Studio Code
     echo.
     echo %date% - %time% - Installing ms-inkling.ms-inkling for VS Code >> %startlog%
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
     cmd /c tar -xf c:\startup\ple8.7.zip

     REM set the firewall rules (needs to run for the current user, not before) to allow AnyLogic and Java
     REM echo %date% - %time% - Importing firewall rules >>  %startlog%
     REM cmd /c netsh advfirewall import c:\startup\advfirewallpolicy.wfw 

     REM go to the AnyLogic directory
     echo %date% - %time% - Moving to "C:\Program Files\AnyLogic 8.7 Personal Learning Edition\" >> %startlog%
     cd "C:\Program Files\AnyLogic 8.7 Personal Learning Edition\" 

     IF %mode% == startup (
        REM 'start' AnyLogic --> this will not wait for AnyLogic to close before closing the shell. The ABCA model is loaded per the default settings in the .AnyLogicProfessional directory
        echo %date% - %time% - Starting AnyLogic.exe >> %startlog%
        start AnyLogic.exe
     )

     echo EXITING
     echo %date% - %time% - Script complete >> %startlog%
     exit /b

  )