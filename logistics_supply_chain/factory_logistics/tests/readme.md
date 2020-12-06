
# Areas Tested
- Deployment
- VM extension components
- Batch script components

# Deployment test
Tests completion and time to complete the deployment of the SA resources

- subscription
- main resource group region(s)
-  2 bonsai regions

To perform test:

- Run from virtual machine with Azure user logged in with permission to various Azure subscriptions. 
- Create a resource group
- Perform deployment
- Check deployment status and time
- Log results

To cleanup test:
- Delete resource group

# VM Extension components

Tests the components of the powershell_extension script, mainly:

- downloads software to ensure URLs and files stay consistent

Does not test

- setting environment variables
- installing software

# Batch components
Tests componenents of the startup.bat script, with the assumption the user has already performed `bonsai configure` and `az login` and their credentials are cached (to automate the test).

To perform the test:
- Run the startup.bat script
- Validate
  - The example clones (folder exists)
  - The Bonsai CLI is installed
  - a brain is created
  - inkling is updated 

To cleanup test:
- Delete `%USERPROFILE%\.AnyLogicProfessional\anylogic6.license`
- Delete `"C:\anylogic-examples\bonsai-anylogic"`
- Delete brain `AnyLogic-ABCA`
- Delete package `ABCA`
- Delete ACR `--registry %BONSAI_ACR% --image anylogic-abca:v1 `
- Remove user from `docker-users`
- pip uninstall bonsai-cli



# Not Tested
- Brain training completion
- AnyLogic connector
- Logging in to the virtual machine
- Firewall rules