$FileCreated = Register-ObjectEvent -InputObject (New-Object System.IO.FileSystemWatcher) -EventName "Created" -Action {
    # Get the full path of the created file
    $FullPath = $Event.SourceEventArgs.FullPath
    # Get the file hash
    $FileHash = (Get-FileHash -Path $FullPath -Algorithm MD5).Hash
    # Send the file hash to MalwareBazaar for analysis
    $ScanResult = Invoke-WebRequest -Uri "https://mb-api.abuse.ch/api/v1/" -Method POST -Body "query=get_info&hash=$FileHash"
    # Check if the file is known malware
    if ($ScanResult.StatusCode -eq 200) {
        # Send a HTTP GET request to localhost:3000 with the file path as a query parameter
        Invoke-WebRequest -Uri "http://localhost:1478?file=$FullPath" -Method GET
    }
}
