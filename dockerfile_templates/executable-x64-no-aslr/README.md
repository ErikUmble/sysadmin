You just need to compile without PIE
```
gcc your_file -no-pie
```
and use the same Dockerfile template as with aslr