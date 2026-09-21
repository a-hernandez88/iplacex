$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$temp = Join-Path $root 'tools/docx-temp'
$out = Join-Path $root 'Alexis_Hernandez.docx'
if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
New-Item -ItemType Directory -Path (Join-Path $temp '_rels'), (Join-Path $temp 'word') -Force | Out-Null

function P([string]$value, [string]$kind = 'normal') {
    $escaped = [System.Security.SecurityElement]::Escape($value)
    $size = if ($kind -eq 'title') { 36 } elseif ($kind -eq 'heading') { 28 } else { 24 }
    $bold = if ($kind -ne 'normal') { '<w:b/>' } else { '' }
    return "<w:p><w:pPr><w:spacing w:after='160' w:line='276' w:lineRule='auto'/></w:pPr><w:r><w:rPr><w:rFonts w:ascii='Arial' w:hAnsi='Arial'/><w:sz w:val='$size'/>$bold</w:rPr><w:t xml:space='preserve'>$escaped</w:t></w:r></w:p>"
}
$body = @()
$body += P 'EXAMEN FINAL: AUTOMATIZACIÓN DE PRUEBAS' 'title'
$body += P 'Instituto Profesional IPLACEX · Escuela de Informática y Telecomunicaciones'
$body += P 'Alexis Enrique Hernández Farias'
$body += P 'Asignatura: Automatización de pruebas'
$body += P 'Introducción' 'heading'
$body += P 'Este trabajo implementa las tres actividades de TA_EX_7.pdf mediante una aplicación Java de cálculo con endpoints HTTP. Se utiliza un repositorio Git con estrategia Trunk-Based, Maven, JUnit 5 y GitHub Actions. La validación local permite comprobar compilación, pruebas de dos niveles, aceptación, despliegue Blue/Green y rollback.'
$body += P 'Actividad 1. Repositorio Git y proyecto Maven' 'heading'
$body += P 'Se creó el repositorio en la carpeta examen-final. La rama main contiene la versión estable y feature/primer-test muestra la convención de ramas cortas. El archivo pom.xml establece Java 17, JUnit 5, Maven Surefire para pruebas unitarias, Maven Failsafe para integración y Maven JAR Plugin para el artefacto ejecutable. El código se organizó según la estructura estándar src/main/java y src/test/java. El archivo .gitignore excluye archivos generados.'
$body += P 'La clase Calculadora implementa suma y resta con detección de desbordamiento. La clase App expone /health y /calculate. Se eligió JUnit 5 para las pruebas; Selenium no aporta valor en esta aplicación sin interfaz gráfica. Para publicar en GitHub, se debe crear un repositorio vacío y usar los comandos de README.md. No se declara un enlace remoto que aún no existe.'
$body += P 'Actividad 2. Pipeline de integración continua' 'heading'
$body += P 'El archivo .github/workflows/ci-cd.yml define jobs secuenciales: build, unit-tests e integration-tests. Se activa con push a main o feature/*, pull request a main y ejecución manual. El build genera y conserva el JAR; los jobs de pruebas publican reportes como artefactos. CalculadoraTest contiene tres pruebas unitarias independientes. AppIT inicia un servidor en un puerto libre y verifica salud, cálculo HTTP y respuesta de error mediante tres pruebas de integración.'
$body += P 'Evidencia local: evidence/verify-local.log registra BUILD SUCCESS; 3 pruebas unitarias y 3 pruebas de integración, sin errores ni fallos. Esta evidencia corresponde a Maven local. La ejecución en GitHub Actions deberá realizarse después de publicar el repositorio, y sus capturas se pueden añadir desde la pestaña Actions.'
$body += P 'Actividad 3. Acceptance tests, despliegue y rollback' 'heading'
$body += P 'El job acceptance-deploy-rollback se ejecuta en main luego de superar integración. El script deployment/deploy-demo.sh inicia blue en el puerto 8081 y un router en 8080. Luego inicia green en 8082 y aplica acceptance tests de salud y suma a green. Al pasar, cambia active-slot.txt a green y valida el endpoint público. Finalmente simula rollback hacia blue y verifica el resultado. Los logs se guardan como artefactos.'
$body += P 'Evidencia local: evidence/deploy-local.log muestra ACCEPTANCE PASS para ambos slots, DEPLOY PASS active=green y ROLLBACK PASS active=blue. La demostración utiliza procesos del runner y finaliza al terminar el job; no constituye un servicio permanente. Para producción haría falta un proxy persistente y un mecanismo atómico de conmutación.'
$body += P 'Ejecución y entregables' 'heading'
$body += P 'Desde examen-final: mvn -B test ejecuta unitarias; mvn -B verify ejecuta build, unitarias e integración; bash deployment/deploy-demo.sh ejecuta aceptación, despliegue y rollback. El repositorio incluye pom.xml, código fuente, workflow, scripts, README.md y logs de evidencia. La publicación en GitHub y las capturas de Actions requieren ejecutarse desde la cuenta del estudiante.'
$body += P 'Justificación frente a la pauta' 'heading'
$body += P 'Configuración y funcionalidad: Git, Maven, JUnit y pipeline comprobados localmente. Cumplimiento: las tres actividades disponen de archivos ejecutables y evidencias; queda pendiente únicamente publicar en GitHub y registrar capturas del servicio. Código limpio: separación entre aplicación, pruebas y despliegue, nombres descriptivos y flujo de ramas definido. Presentación: README, informe y logs trazables.'
$body += P 'Fuentes consultadas' 'heading'
$body += P 'TA_EX_7.pdf, instrucciones y pauta del examen final. ME_1.pdf, Git y Maven. ME_3.pdf, integración continua, stages, pruebas y artefactos. ME_2.pdf, ME_4.pdf, ME_5.pdf y ME_6.pdf, contexto del curso. desarrollo.pdf, referencia de organización y presentación del informe.'
$xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' + ($body -join '') + '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr></w:body></w:document>'
$types = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>'
$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'
[System.IO.File]::WriteAllText((Join-Path $temp '[Content_Types].xml'), $types, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $temp '_rels/.rels'), $rels, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $temp 'word/document.xml'), $xml, [System.Text.UTF8Encoding]::new($false))
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (Test-Path -LiteralPath $out) { Remove-Item -LiteralPath $out -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($temp, $out)
Remove-Item -LiteralPath $temp -Recurse -Force
Write-Output $out
