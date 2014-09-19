假设脚本文件夹为：~/scripts

###下载
```
git clone --depth 1 git@github.com:puresky/f02w.git ~/scripts
```
###更新
```
cd ~/scripts
git pull
```

###使能
```
bash workspace_initialize ~/scripts
```
将文件夹~/scripts及其子文件夹添加到合适的路径变量中，创建部分文件的链接。
该脚本运行结束后会提示需要手动修改.bashrc文件。

---待完成：
* 操作前请求确认
* 自动更新
* 第三方包
* 独立运行 

----


