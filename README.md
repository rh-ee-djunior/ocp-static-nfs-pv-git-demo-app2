# ocp-static-nfs-pv-git-demo-app2

Segundo repositório de simulação para teste de migração de PV estático NFS no OpenShift.

Este repositório representa mais uma aplicação da "fábrica de software", com:

- um `PersistentVolume` estático apontando para NFS;
- um `PersistentVolumeClaim` fixado no PV via `volumeName`;
- um `Deployment` que monta o PVC em `/data`;
- uma `Route` para gerar e validar dados persistentes.

## Fluxo

```text
PV static-nfs-pv-demo-app2
  -> NFS 10.0.0.10:/exports/ocp-static-nfs-pv-demo-app2
  -> PVC nfs-static-pv-demo-app2/static-nfs-pvc-demo-app2
  -> Deployment nfs-pv-writer-app2
  -> /data
```

## Deploy

Edite `manifests/01-pv-nfs.yaml` e ajuste o servidor/path NFS:

```yaml
spec:
  nfs:
    server: 10.0.0.10
    path: /exports/ocp-static-nfs-pv-demo-app2
```

Aplique:

```bash
oc apply -k manifests/
```

Valide:

```bash
oc get pv static-nfs-pv-demo-app2
oc get pvc -n nfs-static-pv-demo-app2
oc get pods -n nfs-static-pv-demo-app2
oc get route -n nfs-static-pv-demo-app2
```

## Gerar dados

```bash
ROUTE=$(oc get route nfs-pv-writer-app2 -n nfs-static-pv-demo-app2 -o jsonpath='{.spec.host}')

curl -s http://$ROUTE/ | jq
curl -s "http://$ROUTE/write?msg=app2-antes-migracao" | jq
curl -s "http://$ROUTE/generate?files=5&size_kb=64" | jq
curl -s http://$ROUTE/list | jq
```

## Objetivo da simulação

Este repo deve ser usado junto com outro repositório similar para simular um ambiente real onde múltiplos repositórios possuem arquivos de PV estático apontando para o mesmo servidor NFS antigo.
