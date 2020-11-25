#####move .txt. to folder##########
import glob
import subprocess

files = glob.glob("*.txt")
print(files)
for f in files:
	x = f.split(".")[0]
	print(x)
	cmd= "mv {0} {1}".format(f,x)
	print(cmd)
	subprocess.call(cmd, shell=True)
	