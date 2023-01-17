# Create a new HttpListener
$listener = New-Object System.Net.HttpListener
# Add a prefix to listen on
$listener.Prefixes.Add("http://localhost:1478/")
# Start the listener
$listener.Start()

while ($listener.IsListening) {
    # Wait for a request
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    # Extract the filename from the query string
    $file = $request.QueryString["file"]

    # Send a notification
    $balloonTipTitle = "Virus detected"
    $balloonTipText = "We've detected $file as a virus"
    $balloonTipIcon = "Error"
    $notificationCommand = "powershell -Command [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('$balloonTipText', '$balloonTipTitle', 0, '$balloonTipIcon'); Start-Process powershell -Verb RunAs -ArgumentList '& {Stop-Process -Name (Get-Process -Name $file -ErrorAction SilentlyContinue).Name -Force; Remove-Item $file -Force -Confirm:$false }'"
    $notificationCommand | Invoke-Expression

    # Close the response
    $response.Close()
}
