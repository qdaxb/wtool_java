j:Column   | Description
j:Loaded   | 被读入类的数量
j:Bytes    | 被读入的字节数（K）
j:Unloaded | 被卸载类的数量
j:Bytes    | 被卸载的字节数（K）
j:Time     | 花费在load和unload类的时间

i:Column       | Description
i:Compiled     | 被执行的编译任务的数量
i:Failed       | 失败的编译任务的数量
i:Invalid      | 无效的编译任务的数量
i:Time         | 花费在执行编译任务的时间.
i:FailedType   | 最近失败编译的编译类弄.
i:FailedMethod | 最近失败编译的类名和方法名

f:Column | Description
f:NGCMN  | 年轻代的最小容量 (KB).
f:NGCMX  | 年轻代的最大容量 (KB).
f:NGC    | 当前年轻代的容量 (KB).
f:S0C    | 当前S0的空间 (KB).
f:S1C    | 当前S1的空间 (KB).
f:EC     | 当前eden的空间 (KB).
f:OGCMN  | 年老代的最小容量 (KB).
f:OGCMX  | 年老代的最大容量 (KB).
f:OGC    | 当前年老代的容量 (KB).
f:OC     | 当前年老代的空间 (KB).
f:PGCMN  | 永久代的最小容量 (KB).
f:PGCMX  | 永久代的最大容量 (KB).
f:PGC    | 当前永久代的容量 (KB).
f:PC     | 当前永久代的空间 (KB).
f:YGC    | 年轻代gc的次数
f:FGC    | full gc的次数

d:Column | Description
d:S0     | S0使用百分比
d:S1     | S1使用百分比
d:E      | eden使用百分比
d:O      | old使用百分比
d:P      | perm使用百分比
d:YGC    | 年轻代gc次数
d:YGCT   | 年轻代gc时间
d:FGC    | full gc次数
d:FGCT   | full gc时间
d:GCT    | 垃圾收集总时间

h:Column | Description
h:S0     | S0使用百分比
h:S1     | S1使用百分比
h:E      | eden使用百分比
h:O      | old使用百分比
h:P      | perm使用百分比
h:YGC    | 年轻代gc次数
h:YGCT   | 年轻代gc时间
h:FGC    | full gc次数
h:FGCT   | full gc时间
h:GCT    | 垃圾收集总时间
h:LGCC   | 最近垃圾回收的原因.
h:GCC    | 当前垃圾回收的原因.

p:输出所有类装载器在堆里产生的对象 包括每个装载器的名字,活跃,地址,父装载器,和其总共加载的类大小


l:Column | Description
l:PGCMN  | 永久代最小容量 (KB).
l:PGCMX  | 永久代最大容量 (KB).
l:PGC    | 当前永久代的容量 (KB).
l:PC     | 当前永久代的空间 (KB).
l:YGC    | 年轻代gc次数
l:FGC    | full gc次数
l:FGCT   | full gc时间
l:GCT    | 垃圾收集总时间

k:class name对应的就是Class文件里的class的标识
k:B代表byte
k:C代表char
k:D代表double
k:F代表float
k:I代表int
k:J代表long
k:Z代表boolean
k:前边有[代表数组
k:对象用[L+类名表示

q:class name对应的就是Class文件里的class的标识
q:B代表byte
q:C代表char
q:D代表double
q:F代表float
q:I代表int
q:J代表long
q:Z代表boolean
q:前边有[代表数组
q:对象用[L+类名表示

r:应用程序的directbuffer使用情况（单位为byte）
r:direct代表ByteBuffer.allocateDirect分配的nio directbuffer
r:mapped代表FileChannel.map分配的mapped memory

s:查看占用cpu最高的线程情况
s:使用了开源项目jtop，项目地址：https://bitbucket.org/hatterjiang/jtop，作者：hatterjiang
