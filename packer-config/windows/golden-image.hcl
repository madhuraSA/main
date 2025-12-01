{
  "variables": {
    "azure_tags": {
      "dept": "Engineering",
      "task": "Image deployment"
    },
    "build_resource_group_name": "mccainPackerGroup",
    "communicator": "winrm",
    "image_offer": "WindowsServer",
    "image_publisher": "MicrosoftWindowsServer",
    "image_sku": "2022-datacenter",
    "managed_image_name": "myPackerImage",
    "managed_image_resource_group_name": "packer-poc",
    "os_type": "Windows",
    "vm_size": "Standard_D2_v2",
    "winrm_insecure": true,
    "winrm_timeout": "5m",
    "winrm_use_ssl": true,
    "winrm_username": "packer"
  },
  "provisioners": [
    {
      "type": "powershell",
      "inline": [
        "Add-WindowsFeature Web-Server",
        "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
        "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
        "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
        "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
      ]
    }
  ]
}