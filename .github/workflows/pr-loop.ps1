function Invoke-EndToEndPipelineTest ($Org, $Pat) {
    #echo  "######" | az devops login --organization https://dev.azure.com/contoso/
    echo  $Pat | az devops login --organization $Org

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($Pat)
    $token =[Convert]::ToBase64String($bytes)
    $headers.Add("Authorization", "Basic :$token")
    $headers.Add("Content-Type", "application/json")

    $apiVersion = "?api-version=7.0"
    $requestUrl = "$org/$project/_apis/pipelines$apiVersion"
    $response = Invoke-RestMethod $requestUrl -Method 'GET' -Headers $headers
    $response | ConvertTo-Json -Depth 100

    $pipelineId = 0;

    foreach ($pipeline in $response.value) {
        Write-Host $pipeline
    }        

    #$body.templateParameters.PipelineId = $pipelineId
    #$body = ConvertTo-Json -Depth 100 $body -Compress
    #Write-Host $body
    #$body = [System.Text.Encoding]::UTF8.GetBytes($body)
    #$requestUrl = "$org/$project/_apis/pipelines/$pipelineId/runs$apiVersion"
    #Write-Host $requestUrl
    #$response = Invoke-RestMethod $requestUrl -Method 'POST' -Headers $headers -Body $body
    #$response | ConvertTo-Json -Depth 100

    #$id = $response.id
}