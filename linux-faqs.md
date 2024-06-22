I had this happen once after doing `rm -R <directory>`. I was getting like a million of 
```
rm: remove write-protected regular file '<directory/path.file>'?
```
Instead of answering `y` for all of them, I can just do this. The `f` flag is a force
```shell
rm -rf <directory>
```

