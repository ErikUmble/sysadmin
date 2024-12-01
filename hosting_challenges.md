

Note that a kernel change was added in ubuntu 23 that prevents the jail from working by default.
See [here](https://github.com/google/nsjail/issues/236) for discussion.
You just need to run the following workaround on the server:
```bash
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```
and then the docker setup will work as expected.