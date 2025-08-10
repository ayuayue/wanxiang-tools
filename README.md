## 万象拼音输入法初始化工具

官方仓库: https://github.com/amzxyz/RIME-LMDG

## 使用

输入法初始化工具，用于初始化输入法，将万象方案导入到 rime 中.

windwos 下使用, 使用管理员运行 deploywanxiang.bat 即可.

手动下载模型文件,放到rime用户目录下,由于太大,就不放在git中了. 下载地址: https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram

增加了官方 词库更新与拼音标注工具包 , 直接执行当前目录中的 python 脚本即可

```
python rime固定或用户词典刷新为带辅助码编码.py
python rime固定或用户词典刷新为带声调编码.py
```
