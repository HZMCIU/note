[toc]

# JDK1.7

## 结构

ConcurrentHashMap它采**锁分段技术** 来保证高效的并发操作。ConcurrentHashMap把容器分为多个 **segment（片段）** ，每个片段有一把锁，当多线程访问容器里不同数据段的数据时，线程间就不会存在竞争关系；一个线程占用锁访问一个segment的数据时，并不影响另外的线程访问其他segment中的数据。Segment 继承自 `ReentrantLock`，那本身也就是锁了。结构图如下。

![](jdk1.7_concurrenthashmap.png)

## 源码分析[^6] [^5]

### 重要参数

```java
//ConcurrentHashMap最大容量
static final int MAXIMUM_CAPACITY = 1 << 30;
static final int DEFAULT_INITIAL_CAPACITY = 16;
//默认负载
static final float DEFAULT_LOAD_FACTOR = 0.75f;
//默认并发度，默认最多能有16个线程进行操作
static final int DEFAULT_CONCURRENCY_LEVEL = 16;
//每个段(Segment)中的键值对(Entry)默认有2个
static final int MIN_SEGMENT_TABLE_CAPACITY = 2;
//ConcurrentHashMap最多有1<<16个段
static final int MAX_SEGMENTS = 1 << 16; // slightly conservative

/**
 * Number of unsynchronized retries in size and containsValue
 * methods before resorting to locking. This is used to avoid
 * unbounded retries if tables undergo continuous modification
 * which would make it impossible to obtain an accurate result.
 */
static final int RETRIES_BEFORE_LOCK = 2;

/* ---------------- Fields -------------- */

/**
 * Mask value for indexing into segments. The upper bits of a
 * key's hash code are used to choose the segment.
 */
final int segmentMask;

/**
 * Shift value for indexing within segments.
 */
final int segmentShift;

/**
 * The segments, each of which is a specialized hash table.
 */
final Segment<K,V>[] segments;
```



### 构造函数

构造函数的作用，以构造函数传入的`initialCapacity` 和 `concurrencyLevel`，确认Segment数组的大小`ssize`和每个Segment中HashEntry数组的大小`cap`。其中`ssize`和`cap`向上取整为2的次幂。

```java
@SuppressWarnings("unchecked")
public ConcurrentHashMap(int initialCapacity,
                            float loadFactor, int concurrencyLevel) {
    if (!(loadFactor > 0) || initialCapacity < 0 || concurrencyLevel <= 0)
        throw new IllegalArgumentException();
    if (concurrencyLevel > MAX_SEGMENTS)
        concurrencyLevel = MAX_SEGMENTS;
    // Find power-of-two sizes best matching arguments
    int sshift = 0;
    int ssize = 1;
    //ssize为concurrencyLevel向上取整的2次幂
    while (ssize < concurrencyLevel) {
        ++sshift;
        ssize <<= 1;
    }
    this.segmentShift = 32 - sshift;
    this.segmentMask = ssize - 1;
    if (initialCapacity > MAXIMUM_CAPACITY)
        initialCapacity = MAXIMUM_CAPACITY;
    int c = initialCapacity / ssize;
    if (c * ssize < initialCapacity)
        ++c;
    int cap = MIN_SEGMENT_TABLE_CAPACITY;
    //cap为每个Segment中包含的HashEntry的个数c向上取整为2次幂
    while (cap < c)
        cap <<= 1;
    // create segments and segments[0]
    Segment<K,V> s0 =
        new Segment<K,V>(loadFactor, (int)(cap * loadFactor),
                            (HashEntry<K,V>[])new HashEntry[cap]);
    Segment<K,V>[] ss = (Segment<K,V>[])new Segment[ssize];
    UNSAFE.putOrderedObject(ss, SBASE, s0); // ordered write of segments[0]
    this.segments = ss;
}
```

### `put`方法

操作`ConcurrentHashMap`中元素分为两个步骤：

1. 定位到Segment
2. 调用Segment内部类中的方法，完成对元素的操作

以`put`方法做解释，`remove`,`replace`,`get`方法的操作类似

`ConcurrentHashMap`中的`put`方法

```java
@SuppressWarnings("unchecked")
public V put(K key, V value) {
    Segment<K,V> s;
    if (value == null)
        throw new NullPointerException();
    //计算Hash值
    int hash = hash(key.hashCode());
    //确定Segment数组的下标，定位属于哪个Segment
    int j = (hash >>> segmentShift) & segmentMask;
    if ((s = (Segment<K,V>)UNSAFE.getObject          // nonvolatile; recheck
            (segments, (j << SSHIFT) + SBASE)) == null) //  in ensureSegment
        //获取Segment元素，如果元素不存在，重新创建一个元素
        s = ensureSegment(j);
    return s.put(key, hash, value, false);
}
```

`Segment`中的`put`方法

```java
final V put(K key, int hash, V value, boolean onlyIfAbsent) {
    /**
    * tryLock尝试获取锁。如果获取失败，使用scanAndLockForPut获取锁。
    * scanAndLockForPut除了获取锁，还会遍历链表查找包含给定key的结点。
    * 如果没有找到，则会new一个包含给定key的结点，并返回。
    * 如果找到给定key的结点，返回null。
    * scanfAndLockForPut尝试超过3次CAS加锁失败，则会强制加锁。
    */
    HashEntry<K,V> node = tryLock() ? null :
        scanAndLockForPut(key, hash, value);
    V oldValue;
    try {
        HashEntry<K,V>[] tab = table;
        // 取Segment地址
        int index = (tab.length - 1) & hash;
        // 取链表的头节点
        HashEntry<K,V> first = entryAt(tab, index);
        // 遍历链表
        for (HashEntry<K,V> e = first;;) {
            // 链表中的非空元素
            if (e != null) {
                K k;
                // 存在相同的元素，覆盖
                if ((k = e.key) == key ||
                    (e.hash == hash && key.equals(k))) {
                    oldValue = e.value;
                    if (!onlyIfAbsent) {
                        e.value = value;
                        ++modCount;
                    }
                    break;
                }
                e = e.next;
            }
            // 链表为空，或者链表中不存在待插入的元素
            else {
                // tryLock加锁失败，使用scanAndLockForPut加锁，待插入结点已经初始化，使用头插法插入待插入结点
                if (node != null)
                    node.setNext(first);
                else
                // tryLock加锁成功，待插入结点未初始化，头插法加入结点
                    node = new HashEntry<K,V>(hash, key, value, first);
                int c = count + 1;
                // 超出最大容量，rehash容量扩大两倍
                if (c > threshold && tab.length < MAXIMUM_CAPACITY)
                    rehash(node);
                else
                    setEntryAt(tab, index, node);
                ++modCount;
                count = c;
                // 释放
                oldValue = null;
                break;
            }
        }
    } finally {
        unlock();
    }
    return oldValue;
}
```

```java
private HashEntry<K,V> scanAndLockForPut(K key, int hash, V value) {
    // 链表头节点
    HashEntry<K,V> first = entryForHash(this, hash);
    HashEntry<K,V> e = first;
    HashEntry<K,V> node = null;
    int retries = -1; // negative while locating node
    while (!tryLock()) {
        HashEntry<K,V> f; // to recheck first below
        if (retries < 0) {
            // 链表为空
            if (e == null) {
                // 待插入结点未初始化
                if (node == null) // speculatively create node
                    node = new HashEntry<K,V>(hash, key, value, null);
                // retries+=1
                retries = 0;
            }
            // 找到包含给定key的元素
            else if (key.equals(e.key))
                // retries+=1
                retries = 0;
            else
                e = e.next;
        }
        // 尝试3次CAS获取锁，失败，整个segment强制加锁
        else if (++retries > MAX_SCAN_RETRIES) {
            lock();
            break;
        }
        // 获取锁过程中，链表被修改，重置retries=-1，重置头节点first=f，重新遍历链表，重新尝试获取锁
        else if ((retries & 1) == 0 &&
                    (f = entryForHash(this, hash)) != first) {
            e = first = f; // re-traverse if entry changed
            retries = -1;
        }
    }
    return node;
}
```



### `rehash`方法

将Segment中的table容量扩大两倍，并将Segment中的结点重新分配。

```java
@SuppressWarnings("unchecked")
private void rehash(HashEntry<K,V> node) {
   /*
    * Reclassify nodes in each list to new table.  Because we
    * are using power-of-two expansion, the elements from
    * each bin must either stay at same index, or move with a
    * power of two offset. We eliminate unnecessary node
    * creation by catching cases where old nodes can be
    * reused because their next fields won't change.
    * Statistically, at the default threshold, only about
    * one-sixth of them need cloning when a table
    * doubles. The nodes they replace will be garbage
    * collectable as soon as they are no longer referenced by
    * any reader thread that may be in the midst of
    * concurrently traversing table. Entry accesses use plain
    * array indexing because they are followed by volatile
    * table write.
    */
    HashEntry<K,V>[] oldTable = table;
    int oldCapacity = oldTable.length;
    int newCapacity = oldCapacity << 1;
    threshold = (int)(newCapacity * loadFactor);
    HashEntry<K,V>[] newTable =
        (HashEntry<K,V>[]) new HashEntry[newCapacity];
    int sizeMask = newCapacity - 1;
    for (int i = 0; i < oldCapacity ; i++) {
        HashEntry<K,V> e = oldTable[i]; //头节点
        if (e != null) {
            HashEntry<K,V> next = e.next;
            int idx = e.hash & sizeMask;
            if (next == null)   //  Single node on list
                newTable[idx] = e;
            // 链表含多个元素，重用同一个slot中的最后一段hash值相同的链表
            else { // Reuse consecutive sequence at same slot
                HashEntry<K,V> lastRun = e; //最后一段链表的头节点
                int lastIdx = idx; // 最后一段链表所映射的hashtable的下标
                for (HashEntry<K,V> last = next;
                        last != null;
                        last = last.next) {
                    int k = last.hash & sizeMask;
                    if (k != lastIdx) {
                        lastIdx = k;
                        lastRun = last;
                    }
                }
                newTable[lastIdx] = lastRun;
                // Clone remaining nodes
                // 重新分配结点，最后一段链表不用重新分配
                for (HashEntry<K,V> p = e; p != lastRun; p = p.next) {
                    V v = p.value;
                    int h = p.hash;
                    int k = h & sizeMask;
                    HashEntry<K,V> n = newTable[k];
                    newTable[k] = new HashEntry<K,V>(h, p.key, v, n);
                }
            }
        }
    }
    int nodeIndex = node.hash & sizeMask; // add the new node
    node.setNext(newTable[nodeIndex]);
    newTable[nodeIndex] = node;
    table = newTable;
}
```

### `size`方法

```java
/**
 * Returns the number of key-value mappings in this map.  If the
 * map contains more than <tt>Integer.MAX_VALUE</tt> elements, returns
 * <tt>Integer.MAX_VALUE</tt>.
 *
 * @return the number of key-value mappings in this map
 */
public int size() {
    // Try a few times to get accurate count. On failure due to
    // continuous async changes in table, resort to locking.
    final Segment<K,V>[] segments = this.segments;
    int size;
    boolean overflow; // true if size overflows 32 bits
    long sum;         // sum of modCounts
    long last = 0L;   // previous sum
    int retries = -1; // first iteration isn't retry
    try {
        for (;;) {
            // 当重试次数等于3次时，直接遍历每个segment并上锁
            if (retries++ == RETRIES_BEFORE_LOCK) {
                for (int j = 0; j < segments.length; ++j)
                    ensureSegment(j).lock(); // force creation
            }
            sum = 0L;
            size = 0;
            overflow = false;
            for (int j = 0; j < segments.length; ++j) {
                Segment<K,V> seg = segmentAt(segments, j);
                if (seg != null) {
                    sum += seg.modCount;
                    int c = seg.count;
                    // 判断是否溢出
                    if (c < 0 || (size += c) < 0)
                        overflow = true;
                }
            }
            if (sum == last)
                break;
            last = sum;
        }
    } finally {
        // 解锁
        if (retries > RETRIES_BEFORE_LOCK) {
            for (int j = 0; j < segments.length; ++j)
                segmentAt(segments, j).unlock();
        }
    }
    return overflow ? Integer.MAX_VALUE : size;
}
```



# JDK1.8 [^7] [^8] [^4]

## 结构

## 源码分析

### 重要参数



# 参考资料

[^1]:[谈谈ConcurrentHashMap1.7和1.8的不同实现](https://www.jianshu.com/p/e694f1e868ec)
[^2]:[ConcurrentHashMap底层实现原理((JDK1.7&1.8)) ](https://blog.csdn.net/zhang18024666607/article/details/92796400?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522161248834016780265470911%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=161248834016780265470911&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_click~default-1-92796400.first_rank_v2_pc_rank_v29_10&utm_term=concurrenthashmap&spm=1018.2226.3001.4187)
[^3]:[ConcurrentHashMap详解](https://blog.csdn.net/fanrenxiang/article/details/80435459?ops_request_misc=&request_id=&biz_id=102&utm_term=concurrenthashmap&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-80435459.first_rank_v2_pc_rank_v29_10&spm=1018.2226.3001.4187)
[^4]:[关于jdk1.8中ConcurrentHashMap的方方面面 ](https://blog.csdn.net/tp7309/article/details/76532366?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522161248834016780265470911%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=161248834016780265470911&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-3-76532366.first_rank_v2_pc_rank_v29_10&utm_term=concurrenthashmap&spm=1018.2226.3001.4187)
[^5]:[ConcurrentHashMap实现原理及源码分析](https://www.cnblogs.com/chengxiao/p/6842045.html)
[^6]:[JDK 1.7之 ConcurrentHashMap 源码分析](https://blog.csdn.net/crazy1235/article/details/76795383)
[^7]:[ConcurrentHashMap源码分析(1.8)](https://www.cnblogs.com/zerotomax/p/8687425.html)
[^8]:[Java 8 ConcurrentHashMap源码分析](https://juejin.cn/post/6844903508546682887)

