
<#! 
  Instructions
    - Run file in Powershell (double clicking might work).  Keep filter_list.txt in same folder as .ps1 file
        - If the powershell gives an error run the following in a PowerShell Window
            Set-ExecutionPolicy Bypass
    - Select export .XML App Config, it will output a filtered version in the same folder as the original .XML APP config
!#>

#Open file/folder dialog box
Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'XML File (*.xml)|*.xml'
    Title = 'Select files to open'
}

$null = $FileBrowser.ShowDialog()

#assign variables for input file
$XMLInput = $filebrowser.filename

#strip .xml from output file (put it back in on save)
$Output = $XMLInput -replace ".{4}$"

#get file content
$xml = [xml](Get-Content $XMLInput)

#names of settings to filter out
$removenodes = (Get-Content '.\filter_list.txt')

#loop through each filter_list in the xml file and remove them
foreach ($removenode in $removenodes) {
  ($xml.APPConfiguration.SelectNodes("*[starts-with(name(), '$removenode')]")) | ForEach-Object {
      # Remove each node from its parent
      [void]$_.ParentNode.RemoveChild($_)
  }
}

# Save the modified document
$xml.Save($Output + "-filtered.xml")