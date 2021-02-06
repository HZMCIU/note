# 调用GPG加密同一文件夹下面的所有markdown文件
from pathlib import Path
import os


def encrypt(path):
    recipient = input('recipient?\n')
    p = Path('.')
    files = [str(x) for x in p.iterdir() if x.suffix !=
             '.asc' and x.suffix != '.py']
    for file in files:
        encrypt = 'gpg -r {0} -a -e --batch --yes {1} '.format(recipient, file)
        os.system(encrypt)
        delete = 'del {0}'.format(file)
        os.system(delete)


def decrypt():
    p = Path('.')
    files = [str(x) for x in p.iterdir() if x.suffix=='.asc']
    for file in files:
        decrypt='gpg --batch --yes -o {0} -d {1}'.format(file[:-4],file)
        os.system(decrypt)
        delete = 'del {0}'.format(file)
        os.system(delete)

if __name__ == '__main__':
    option = input('option?\n')
    if option=='e':
        encrypt()
    elif option=='d':
        decrypt()
