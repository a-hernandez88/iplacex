# Automatización de Pruebas - Examen Final

## Descripción del proyecto

Proyecto desarrollado para implementar un proceso de automatización
de pruebas utilizando Java, Maven, JUnit, Git y GitHub Actions.

## Estrategia de pruebas

El proyecto incorpora:

- Pruebas unitarias
- Pruebas de integración
- Pruebas de aceptación
- Pipeline de Integración Continua
- Pipeline de despliegue
- Mecanismo de rollback Blue-Green

## Ejecutar las pruebas

mvn clean test

## Pipelines

### Integración Continua

.github/workflows/ci.yml

### Despliegue

.github/workflows/deployment.yml

El pipeline de despliegue ejecuta:

Build
→ Acceptance Tests
→ Deploy Test Environment
→ Rollback

## Rollback Blue-Green

Blue representa la versión estable y Green la nueva versión.
El pipeline valida Green y posteriormente ejecuta un rollback
controlado hacia Blue para comprobar el mecanismo de recuperación.

## Tecnologías utilizadas

- Java 17
- Maven 3.9.16
- JUnit 5
- Selenium
- Git
- GitHub
- GitHub Actions
