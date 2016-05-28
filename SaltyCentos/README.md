# A way to test salt scripts

Start docker container `milenkovicm/saltycentos`, and mount directory with scripts to `/srv`

```bash
 docker run -ti -v ~/git/salt/srv/:/srv/ milenkovicm/saltycentos
```

Run `salt-call` with `--local` as there is no master server running

 ```bash
 salt-call --local state.highstate
 ```
hopefully `state.highstate` should be executed.
