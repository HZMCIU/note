from pathlib import Path
p=Path('F:\LeetCode')
subdir=[x for x in p.iterdir() if not x.is_dir()]
for dir in subdir:
    print(dir.name)
