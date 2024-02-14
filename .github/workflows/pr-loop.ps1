function Invoke-EndToEndPipelineTest ($Org, $Pat) {
    #echo  "######" | az devops login --organization https://dev.azure.com/contoso/
    #echo  $Pat | az devops login --organization $Org
    #testing
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Pat)
    $token = [Convert]::ToBase64String($bytes)
    echo $token.EndsWith("=")
    echo $token.Length
    $headers.Add("Authorization", "Basic :$token")
    $headers.Add("Content-Type", "application/json")

    $apiVersion = "?api-version=7.0"
    $requestUrl = "$Org/_apis/pipelines$apiVersion"
    $response = Invoke-RestMethod $requestUrl -Method 'GET' -Headers $headers
    $response | ConvertTo-Json -Depth 100

    $pipelineId = 0;

    foreach ($pipeline in $response.value) {
        Write-Host $pipeline
    }        
}