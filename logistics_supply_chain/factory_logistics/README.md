# Factory Logistics


This will deploy a solution accelerator using a UI by clicking the button below:

[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fbonsai-solution-accelerators%2Fmain%2Flogistics_supply_chain%2Ffactory_logistics%2FCreateSolutionAccelerator.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fbonsai-solution-accelerators%2Fmain%2Flogistics_supply_chain%2Ffactory_logistics%2FcreateUiDefinition.json)

Deploy with Bastion

[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fbonsai-solution-accelerators%2Fmain%2Flogistics_supply_chain%2Ffactory_logistics%2FCreateSolutionAcceleratorB.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fbonsai-solution-accelerators%2Fmain%2Flogistics_supply_chain%2Ffactory_logistics%2FcreateUiDefinition.json)

<!-- This will deploy a solution accelerator by clicking the button below:

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdavidhcoe%2Fb_sas%2Fmaster%2FCreateSolutionAccelerator.json)  
 -->

# Single Resource

https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdavidhcoe%2Fb_sas%2Fmaster%2FCreateWindowsVirtualMachineWithExtensionB.json   


## Resources Deployed

- Bonsai (and child RG and resources)
- Virtual Machine
- Network Interface
- Network Security Group
- Virtual Network
- Public IP Address

# How it works

Takes a template approach to deploying the resources:

**CreateSolutionAccelerator** sets up the input parameters<br>
1. *CreateBonsaiArm* creates the Bonsai resources 
2. *CreateWindowsVirtualMachineWithExtension* creates the virtual machine and required networking components to RDP to the machine. <br> - Runs the `powershell_extension.ps1` script which sets an envrionment variable from (2), downloads Python, installs the bonsai CLI, and downloads AnyLogic and the `startup.bat` script, which is used by the VM when the user launches logs in.

# VM Launch

When the user logs in, they see the typical Windows startup (ie, permissions for data capture, network connection). The `startup.bat` file runs. It 

- clones the https://github.com/microsoft/bonsai-anylogic repository
- installs bonsai-cli
- runs bonsai configure [workspace-id] (workspace ID is an environment variable)
- creates a brain
- uploads the inkling
- starts an Edge session for docs
- launches AnyLogic 
