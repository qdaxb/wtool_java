     __    __  _____            _
    / / /\ \ \/__   \___   ___ | |
    \ \/  \/ /  / /\/ _ \ / _ \| |
     \  /\  /  / / | (_) | (_) | |
      \/  \/   \/   \___/ \___/|_|
# wtool java工具包

## java命令
* `wtool housemd pid [java_home]`
> 使用housemd对java程序进行运行时跟踪，支持的操作有：
> > - 查看加载类
> > - 跟踪方法 
> > - 查看环境变量
> > - 查看对象属性值
> 
> 详细信息请参考[housemd说明文档](https://github.com/qdaxb/wtool/raw/master/java/tools/housemd.lib/README.md)

* `wtool jarconfict path`
> 查找jar包间冲突的类

* `wtool jarfind classname path`
> 在jar包中查找类名

* `wtool jargrep "text" <path or jarfile>`
> 在jar包中查找文本，可查找常量字符串、类引用。

* `wtool findcycle [path]`
> 查找当前工程中是否存在循环引用（目前仅支持maven工程，默认为当前路径）

* `wtool jvm pid`
> 执行jvm debug工具，包含对java栈、堆、线程、gc等状态的查看。
> > * 进入jvm工具后可以输入序号执行对应命令
> > * 可以一次执行多个命令，用分号";"分隔，如：1;3;4;5;6
> > * 每个命令可以带参数，用冒号":"分隔，同一命令的参数之间用逗号分隔，如：1:1000,100;3;5:/data1/output.bin
>
> 示例

```
进入wtool jvm工具：
[root@localhost ~]# wtool jvm 31395
1 : 打印线程数
2 : 打印所有线程
3 : 打印线程运行状态统计
4 : 垃圾收集统计。可以指定间隔时间及执行次数，默认10秒
5 : 打印jvm heap中对象统计*会使程序暂停响应*
6 : 触发full gc
7 : 触发full gc后打印jvm heap
8 : 显示堆中各代的空间1000 10
9 : 打印finalzer队列情况
10 : 垃圾收集统计（包含原因）可以指定间隔时间及执行次数，默认10秒
11 : 显示classloader统计
12 : 显示jit编译统计
13 : 打印jvm heap统计*会使程序暂停响应*
14 : 打印perm区内存情况*会使程序暂停响应*
15 : 输出所有类装载器在perm里产生的对象。可以指定间隔时间及执行次数
16 : dump heap到文件*会使程序暂停响应*默认保存到/root/dump.bin,可指定其它路径
17 : 死锁检测
18 : 查看directbuffer情况
19 : 查看占用cpu最高的线程情况
20 : 等待X秒，默认为1
q : exit
Enter command queue:

比如说我要查看线程运行状态、看5秒gc状态、触发fullgc、之后再观察线程状态、10秒gc状态、最后打印heap中所有对象数量，可以输入命令序列：

3;4:1000,5;6;3;4;5

之后会提示：
which output type?
default : console and log file(31395_jvm.log)
a       : console only
b       : file only
Enter output type:
程序可以只输出到控制台、只输出到文件。默认是同时输出到两者，此时直接按回车。

输出结果会同时打印到控制台和当前目录的$pid_jvm.log中，会输出每个命令行、时间信息和一些关于这个命令的帮助信息，比如刚才的例子，输出如下：

=======================================================
*** [2014-12-03 17:52:10] start execute queue : 3;4:1000,5;6;3;4;5 ***
-------------------------------------------------------
*** [2014-12-03 17:52:10] start execute command:jstack 31395 |grep 'java.lang.Thread.State:'|sort|uniq -c ***
*** [2014-12-03 17:52:10] 打印线程运行状态统计 ***
     18    java.lang.Thread.State: RUNNABLE
     62    java.lang.Thread.State: TIMED_WAITING (on object monitor)
     66    java.lang.Thread.State: TIMED_WAITING (parking)
     31    java.lang.Thread.State: TIMED_WAITING (sleeping)
     14    java.lang.Thread.State: WAITING (on object monitor)
     40    java.lang.Thread.State: WAITING (parking)
*** [2014-12-03 17:52:10] finish execute command:jstack 31395 |grep 'java.lang.Thread.State:'|sort|uniq -c ***
-------------------------------------------------------
*** [2014-12-03 17:52:10] start execute command:jstat -gcutil 31395 1000 5 ***
*** [2014-12-03 17:52:10] 垃圾收集统计。 ***
# Help message:
# Column | Description
# S0     | S0使用百分比
# S1     | S1使用百分比
# E      | eden使用百分比
# O      | old使用百分比
# P      | perm使用百分比
# YGC    | 年轻代gc次数
# YGCT   | 年轻代gc时间
# FGC    | full gc次数
# FGCT   | full gc时间
# GCT    | 垃圾收集总时间

  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00  74.11  31.12  16.11  32.16   2623  183.616    55   13.659  197.276
  0.00  74.11  31.49  16.11  32.16   2623  183.616    55   13.659  197.276
  0.00  74.11  31.54  16.11  32.16   2623  183.616    55   13.659  197.276
  0.00  74.11  31.54  16.11  32.16   2623  183.616    55   13.659  197.276
  0.00  74.11  31.64  16.11  32.16   2623  183.616    55   13.659  197.276
*** [2014-12-03 17:52:14] finish execute command:jstat -gcutil 31395 1000 5 ***
-------------------------------------------------------
*** [2014-12-03 17:52:14] start execute command:jmap -histo:live 31395  >/dev/null ***
*** [2014-12-03 17:52:14] 触发full gc。*会使程序暂停响应* ***
*** [2014-12-03 17:52:15] finish execute command:jmap -histo:live 31395  >/dev/null ***
-------------------------------------------------------
*** [2014-12-03 17:52:15] start execute command:jstack 31395 |grep 'java.lang.Thread.State:'|sort|uniq -c ***
*** [2014-12-03 17:52:15] 打印线程运行状态统计 ***
     18    java.lang.Thread.State: RUNNABLE
     62    java.lang.Thread.State: TIMED_WAITING (on object monitor)
     66    java.lang.Thread.State: TIMED_WAITING (parking)
     31    java.lang.Thread.State: TIMED_WAITING (sleeping)
     14    java.lang.Thread.State: WAITING (on object monitor)
     40    java.lang.Thread.State: WAITING (parking)
*** [2014-12-03 17:52:16] finish execute command:jstack 31395 |grep 'java.lang.Thread.State:'|sort|uniq -c ***
-------------------------------------------------------
*** [2014-12-03 17:52:16] start execute command:jstat -gcutil 31395 1000 10 ***
*** [2014-12-03 17:52:16] 垃圾收集统计。 ***
# Help message:
# Column | Description
# S0     | S0使用百分比
# S1     | S1使用百分比
# E      | eden使用百分比
# O      | old使用百分比
# P      | perm使用百分比
# YGC    | 年轻代gc次数
# YGCT   | 年轻代gc时间
# FGC    | full gc次数
# FGCT   | full gc时间
# GCT    | 垃圾收集总时间

  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00   0.00   0.69  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   0.93  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   0.94  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   0.95  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   1.18  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   1.19  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   1.40  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   1.44  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   1.72  13.26  32.16   2623  183.616    56   14.009  197.625
  0.00   0.00   2.03  13.26  32.16   2623  183.616    56   14.009  197.625
*** [2014-12-03 17:52:25] finish execute command:jstat -gcutil 31395 1000 10 ***
-------------------------------------------------------
*** [2014-12-03 17:52:25] start execute command:jmap -histo 31395  ***
*** [2014-12-03 17:52:25] 打印jvm heap中对象统计*会使程序暂停响应* ***
# Help message:
# class name对应的就是Class文件里的class的标识
# B代表byte
# C代表char
# D代表double
# F代表float
# I代表int
# J代表long
# Z代表boolean
# 前边有[代表数组
# 对象用[L+类名表示


 num     #instances         #bytes  class name
----------------------------------------------
   1:         18471       14269744  [B
   2:         70122       11729664  <constMethodKlass>
   3:        112468       10395568  [C
   4:         70122        9546512  <methodKlass>
   5:          6038        7591760  <constantPoolKlass>
   6:          6038        4535144  <instanceKlassKlass>
   7:          4979        4205760  <constantPoolCacheKlass>
   8:         42984        2750976  com.mysql.jdbc.ConnectionPropertiesImpl$BooleanConnectionProperty
   9:        108153        2595672  java.lang.String
  10:         70458        2254656  java.util.Hashtable$Entry
  11:         15578        2033232  [I
  12:          2706        1596504  <methodDataKlass>
  13:          9831        1293752  [Ljava.lang.Object;
  14:         37742        1207744  java.util.HashMap$Entry
  15:         14756        1139224  [Ljava.util.HashMap$Entry;
  16:          6557         795984  java.lang.Class
  17:          1231         745536  [Ljava.util.Hashtable$Entry;
  18:         10348         745056  com.mysql.jdbc.ConnectionPropertiesImpl$IntegerConnectionProperty
  19:         11542         738688  com.mysql.jdbc.ConnectionPropertiesImpl$StringConnectionProperty
  20:          8186         654880  java.lang.reflect.Method
  21:          9148         653312  [S
  22:         16283         651320  java.util.LinkedHashMap$Entry
………………省略……………………
Total        906014       92399120
*** [2014-12-03 17:52:25] finish execute command:jmap -histo 31395  ***
*** [2014-12-03 17:52:25] finish execute queue ***
=======================================================
```
