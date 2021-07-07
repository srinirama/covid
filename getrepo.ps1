$Projects = az devops project list --organization https://dev.azure.com/ --query "value[].name" -o tsv
foreach ($Proj in $Projects) {
    Write-Output "mkdir $Proj "
    Write-Output "cd $Proj"
    $Repos = az repos list --organization https://dev.azure.com/ --project $Proj | ConvertFrom-Json
    foreach ($Repo in $Repos) {
        if(-not (Test-Path -Path $Repo.name -PathType Container)) {
            #Write-Output -Message "Cloning repo $Proj\$($Repo.Name) ---- $($Repo.webUrl)"

            Write-Output "git clone $($Repo.webUrl)"
        }
        
    }
    Write-Output "cd .."
}

