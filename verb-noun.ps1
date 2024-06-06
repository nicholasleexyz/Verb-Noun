Param([String]$arg1)

Filter Get-ElementByID($id)
{
  "const $($_) = document.getElementById(`"${id}`")" 
}

Filter New-Element($tag)
{
  "const $($_) = document.createElement(`"${tag}`")" 
}

Filter Set-ElementInnerHTML($innerHTML)
{
  "$($_).innerHTML = `"${innerHTML}`"" 
}

Filter Set-ElementAttribute($attributeName, $attributeValue)
{
  "$($_).setAttribute(`"${attributeName}`", `"${attributeValue}`")" 
}

Filter Set-ElementStyle($style)
{
  $_ | Set-ElementAttribute -attributeName "style" -attributeValue $($style -join ';') 
}

Filter Set-ElementParent($parent)
{
  "${parent}.prepend($($_))" 
}

$projectName = If ($PSBoundParameters.ContainsKey('arg1'))
{ ($PSBoundParameters['arg1']) 
} Else
{ "NewProject" 
}

Function New-HTML($projName)
{
  @"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${projName}</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body id="app">
    <script src="main.js"></script>
  </body>
</html>
"@
}

Write-Output "creating project directory"
New-Item $projectName -ItemType "directory"

Write-Output "Moving into project directory..."
Set-Location $projectName

Write-Output "Creating index.html..."
New-HTML -projName $projectName | Out-File -FilePath index.html

# element names
$app = "app"
$content = "content"
$todoContainer = "todoContainer"

$contentStyle = @(
  "width:100%"
  "height:100dvh"
  "display:flex"
  "justify-content:center"
  "align-items:center"
)

$todoContainerStyle = @(
  "width:1024px"
  "height:1024px"
  "border:solid black"
  "border-radius:1rem"
  "background-color:slateblue"
)

$page = @(
  $app | Get-ElementByID -id "app"
  $content | New-Element -tag "div"
  $content | Set-ElementParent -parent $app
  $content | Set-ElementStyle -style $contentStyle
  $todoContainer | New-Element "div"
  $todoContainer | Set-ElementParent -parent $content
  $todoContainer | Set-ElementStyle -style $todoContainerStyle
  $todoContainer | Set-ElementInnerHTML -innerHTML "todo container text"
)

# create main javascript file
$page -join "`n" | Out-File -FilePath main.js
