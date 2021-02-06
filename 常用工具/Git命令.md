

[TOC]

# 远程同步[^1]



## `git clone`

`git clone` 从远程主机上，克隆一个版本库。该命令会在本地主机上生成一个目录，目录的名称默认和远程版本库相同。可以设置`git clone`的第二个参数来指定本地目录的名称。

```bash
git clone <版本库的网址>
git clone <版本库的网址> <本地目录名>  # 设置本地目录名
```

`git clone`支持多种协议，除了HTTP(s)以外，还支持SSH、Git、本地文件协议等

```bash
git clone http[s]://example.com/path/to/repo.git/
git clone ssh://example.com/path/to/repo.git/
git clone git://example.com/path/to/repo.git/
git clone /opt/git/project.git 
git clone file:///opt/git/project.git
git clone ftp[s]://example.com/path/to/repo.git/
git clone rsync://example.com/path/to/repo.git/
```

SSH协议还有另一种写法。

```bash
git clone [user@]example.com:path/to/repo.git/
```

##  `git remote`

`git remote`命令用于管理主机名。

+ `git remote` 列出所有远程主机

  ```bash
  git remote
  origin
  ```

+ `git remote -v` 查看远程主机的网址

  ```bash
  git remote -v
  origin  git@github.com:jquery/jquery.git (fetch)
  origin  git@github.com:jquery/jquery.git (push)
  ```

+ `git clone -o` 克隆版本库的时候，指定主机的名称

  ```bash
  git clone -o jQuery https://github.com/jquery/jquery.git
  git remote
  jQuery
  ```

+ `git remote show <主机名>` 查看主机的详细信息

+ `git remote add <主机名> <网址>` 添加远程主机

+ `git remote rm <主机名>` 删除远程主机

+ `git remote rename <原主机名> <新主机名>` 远程主机重命名

## `git fetch`

`git fetch` 将远程主机的版本库更新取回本地。`git fetch`命令通常用来查看其他人的进程，因为它取回的代码对你本地的开发代码没有影响。所取回的更新，在本地主机上要用"**远程主机名/分支名**"的形式读取。

+ `git fetch` 取回所有分支（branch）的更新。`git fetch <远程主机名> <分支名>` 取回特定分支的更新，可以指定分支名。

  ```bash
  git fetch origin master # 取回origin主机的master分支
  ```

+ `git brach -r ` 查看远程分支；`git brach -a` 查看所有分支

  ```bash
  git branch -r
  origin/master
  
  git branch -a
  * master
    remotes/origin/master
  ```

+ `git checkout`远程主机取回更新后，创建一个新的分支

  ```bash
  git checkout -b newBrach origin/master
  ```

+ `git merge`或者`git rebase`在当前的分支上合并远程分支

  ```bash
  git merge origin/master
  git rebase origin/master
  # 在当前的分支上合并 origin/master
  ```

## `git pull`

`git pull<远程主机名> <远程分支名>:<本地分支名>`  的作用是取回远程主机某个分支的更新，再与本地的指定分支合并。

```bash
git pull origin next:master # 取回origin主机的next分支，与本地的master分支合并
git pull origin next # git pull origin next。取回origin/next分支，再与当前分支合并。实质上，这等同于先做git fetch，再做git merge
```

在某些场合，Git会自动在本地分支与远程分支之间，建立一种**追踪关系（tracking）**。比如，*在`git clone`的时候，所有本地分支默认与远程主机的同名分支，建立追踪关系*，也就是说，本地的`master`分支自动"追踪"`origin/master`分支。

+ Git手动建立追踪关系

  ```bash
  git branch --set-upstream master origin/next # 指定master分支追踪origin/next分支
  ```

+ 如果当前分支与远程分支存在追踪关系，`git pull`就可以省略远程分支名

  ```bash
  git pull origin #本地的当前分支自动与对应的origin主机"追踪分支"（remote-tracking branch）进行合并
  ```

+ 如果当前分支只有一个追踪分支，连远程主机名都可以省略。

  ```bash
  git pull #当前分支自动与唯一一个追踪分支进行合并
  ```

+ 合并需要采用rebase模式，可以使用`--rebase`选项

  ```bash
  git pull --rebase <远程主机名> <远程分支名>:<本地分支名>
  ```

+ 如果远程主机删除了某个分支，默认情况下，`git pull` 不会在拉取远程分支的时候，删除对应的本地分支。这是为了防止，由于其他人操作了远程主机，导致`git pull`不知不觉删除了本地分支。

  但是，你可以改变这个行为，加上参数 `-p` 就会在本地删除远程已经删除的分支。

  ```bash
  git pull -p
  # 等同于下面的命令
  git fetch --prune origin 
  git fetch -p
  ```

## `git push`

`git push <远程主机名> <本地分支名>:<远程分支名>` 用于将本地分支的更新，推送到远程主机。

+ 如果省略远程分支名，则表示将本地分支推送与之存在"追踪关系"的远程分支（通常两者同名），如果该远程分支不存在，则会被新建

  ```bash
  git push origin master # 将本地的master分支推送到origin主机的master分支。如果后者不存在，则会被新建。
  ```

+ 省略本地分支名，则表示删除指定的远程分支，因为这等同于推送一个空的本地分支到远程分支

  ```bash
  git push origin :master
  # 等同于
  git push origin --delete master # 删除origin主机的master分支。
  ```

+ 当前分支与远程分支之间存在追踪关系，则本地分支和远程分支都可以省略

  ```bash
  git push origin # 将当前分支推送到origin主机的对应分支
  ```

+ 如果当前分支只有一个追踪分支，那么主机名都可以省略。

  ```bash
  git push
  ```

+ 如果当前分支与多个主机存在追踪关系，则可以使用`-u`选项指定一个默认主机，这样后面就可以不加任何参数使用`git push`

  ```bash
  git push -u origin master # 将本地的master分支推送到origin主机，同时指定origin为默认主机，后面就可以不加任何参数使用git push了
  ```

+ `git push --all`不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机

  ```bash
  git push --all origin # 将所有本地分支都推送到origin主机
  ```

+ 如果远程主机的版本比本地版本更新，推送时Git会报错，要求先在本地做`git pull`合并差异，然后再推送到远程主机。这时，如果你一定要推送，可以使用`--force`选项

  ```bash
  git push --force origin  # git push --force origin 
  ```

  

# 撤销操作[^2]

## `git revert`

`git revert [倒数第一个提交] [倒数第二个提交]`作用是撤销提交的代码

+ `git revert HEAD` 。只能抵消上一个提交。原理是，在当前提交后面，新增一次提交，抵消掉上一次提交导致的所有变化。它不会改变过去的历史，所以是首选方式，没有任何丢失代码的风险。

+ `git revert [倒数第一个提交] [倒数第二个提交]` 。 `git revert` 命令只能抵消上一个提交，如果想抵消多个提交，必须在命令行依次指定这些提交。

+ `git revert`命令还有两个参数

  `--no-edit`：执行时不打开默认编辑器，直接使用 Git 自动生成的提交信息。

  `--no-commit`：只抵消暂存区和工作区的文件变化，不产生新的提交。

## `git reset`

`git reset [last good SHA]` ，丢弃掉某个提交之后的所有提交。以前的提交在历史中彻底消失，而不是被抵消掉。

+ `git reset`的原理是，让最新提交的指针回到以前某个时点，该时点之后的提交都从历史中消失。
+ 默认情况下，`git reset`不改变工作区的文件（但会改变暂存区），`--hard`参数可以让工作区里面的文件也回到以前的状态。
+ 执行`git reset`命令之后，如果想找回那些丢弃掉的提交，可以使用`git reflog`命令，具体做法参考[这里](https://github.blog/2015-06-08-how-to-undo-almost-anything-with-git/#redo-after-undo-local)。不过，**这种做法有时效性，时间长了可能找不回来。**

## `git commit --amend`

`git commit --amend` 修改上一次提交的信息。它的原理是产生一个新的提交对象，替换掉上一次提交产生的提交对象。这时如果暂存区有发生变化的文件，会一起提交到仓库。所以，`--amend`不仅可以修改提交信息，还可以整个把上一次提交替换掉。

## `git checkout`

如果工作区的某个文件被改乱了，但还没有提交，可以用`git checkout`命令找回本次修改之前的文件。先找暂存区，如果该文件有暂存的版本，则恢复该版本，否则恢复上一次提交的版本。**注意，工作区的文件变化一旦被撤销，就无法找回了。**

```bash
git checkout -- [filename]
```

## 从暂存区撤销文件

`git rm --cached [filename]` 将暂存区的文件删除。

## 撤销当前分支的变化

你在当前分支上做了几次提交，突然发现放错了分支，这几个提交本应该放到另一个分支。

```bash
# 新建一个 feature 分支，指向当前最新的提交
# 注意，这时依然停留在当前分支
git branch feature

# 切换到这几次提交之前的状态
git reset --hard [当前分支此前的最后一次提交]

# 切换到 feature 分支
git checkout feature
```

[^1]:[Git远程操作详解](https://www.ruanyifeng.com/blog/2014/06/git_remote.html)
[^2]:[如何撤销 Git 操作？](http://www.ruanyifeng.com/blog/2019/12/git-undo.html)