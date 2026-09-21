# Examen final: automatización de pruebas y CI/CD

**Autor:** Alexis Enrique Hernández Farias  
**Asignatura:** Automatización de pruebas, IPLACEX

## Proyecto y estrategia

La aplicación Java 17 expone `/health` y `/calculate`. La calculadora permite sumar y restar enteros. Se usa Maven para construir el JAR, JUnit 5 para pruebas unitarias y de integración, y GitHub Actions para CI/CD. No se agrega Selenium porque esta aplicación no tiene interfaz gráfica; las pruebas HTTP comprueban mejor su comportamiento real.

La estrategia de ramas es **Trunk-Based**: `main` es la rama estable; las ramas `feature/*` son breves, se validan con CI y se integran mediante pull request. El workflow se ejecuta en push a `main` o `feature/*`, en pull request a `main` y manualmente. Cada cambio integra código, pruebas y configuración de pipeline en el mismo repositorio.

## Actividad 1: Git y Maven

`pom.xml` define Java 17, JUnit 5, Surefire para pruebas unitarias y Failsafe para pruebas de integración. El código principal está en `src/main/java`; las pruebas, en `src/test/java`. `.gitignore` excluye compilados, logs y archivos de ejecución.

Repositorio publicado: <https://github.com/a-hernandez88/iplacex>. Las ramas `main` y `feature/primer-test` muestran el flujo Trunk-Based y su historial de integración. El historial local también se resume en `evidence/git-history.txt`.

## Actividad 2: CI

El archivo `.github/workflows/ci-cd.yml` define jobs de **build**, **unit-tests** e **integration-tests**. El build genera un JAR versionado como artefacto del run. Surefire ejecuta `CalculadoraTest` y Failsafe ejecuta `AppIT`, que levanta el servidor HTTP en un puerto libre y verifica salud, cálculo y error de solicitud. Los reportes XML se publican como artefactos de Actions.

```bash
mvn -B test       # pruebas unitarias
mvn -B verify     # build, pruebas unitarias y de integración
```

La [ejecución exitosa de `main`](https://github.com/a-hernandez88/iplacex/actions/runs/35622120211) confirma los cuatro jobs: build, unit-tests, integration-tests y acceptance-deploy-rollback. La [ejecución exitosa de `feature/primer-test`](https://github.com/a-hernandez88/iplacex/actions/runs/35622134914) confirma el control previo a integración. Los artefactos `unit-results`, `integration-results`, `application-jar` y `deployment-logs` se descargan desde la página del run.

## Actividad 3: aceptación, despliegue y rollback

El job `acceptance-deploy-rollback`, que corre solo en `main`, descarga el JAR y ejecuta `deployment/deploy-demo.sh`. El script inicia el slot **blue** en el puerto 8081 y un router en 8080. Después inicia **green** en 8082, aplica pruebas de aceptación al nuevo slot y cambia el tráfico a green al modificar `deployment/runtime/active-slot.txt`. Comprueba el endpoint público y, finalmente, simula un rollback controlado hacia blue y verifica la recuperación. El router lee el slot activo en cada solicitud.

```bash
mvn -B package
bash deployment/deploy-demo.sh
```

La demostración usa procesos locales del runner: valida el mecanismo Blue/Green y rollback, pero no deja un servicio permanente. En un servidor real, el mismo control de tráfico se ubicaría en un proxy persistente y el cambio de slot se haría con una operación atómica.

## Evidencia verificable

`evidence/verify-local.log` registra el build y los resultados de JUnit. `evidence/deploy-local.log` registra las pruebas de aceptación, el despliegue green y el rollback blue. `evidence/github-actions.txt` registra los enlaces y resultados de cada job del run público. Son ejecuciones reales, locales y en GitHub Actions.

## Relación con la pauta

| Criterio | Evidencia |
|---|---|
| Git/Maven y código funcional | Historial Git, `pom.xml`, `src/` y `evidence/verify-local.log` |
| Repositorio, CI y despliegue | `.github/workflows/ci-cd.yml` y `deployment/` |
| Código limpio y versionado | Clases pequeñas, pruebas separadas, `.gitignore`, ramas `main` y `feature/*` |
| Presentación | Este README, informe Word y logs de ejecución |

## Fuentes de la asignatura

- `ME_1.pdf`: Git, ramas y Maven.
- `ME_3.pdf`: integración continua, stages, pruebas y artefactos.
- `ME_2.pdf`, `ME_4.pdf`, `ME_5.pdf`, `ME_6.pdf`: prácticas de configuración, calidad y entrega revisadas como contexto.
- `TA_EX_7.pdf`: instrucciones de las tres actividades y pauta de evaluación.
