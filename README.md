## reproduce https://github.com/kubernetes/autoscaler/issues/3131


creates a 1.15 cluster, 2 node pools, both with AS, then creates and deletes (sequentially) 10 statefulsets

with logs:
```
./repro-1.15-cluster.sh 1>/tmp/repro.log 2>&1 &
tail -f /tmp/repro.log
```

## not broken (1.14)

```
./ok-1.14-cluster.sh
```
