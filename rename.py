#####rename species with _#######

import glob
import subprocess

files= glob.glob("*")
print(files)
for f in files:
	z=f.replace(" ","\ ")
	y=f.replace(" ","_")
	print(y)
	cmd= "mv {0} {1}".format(z,y)
	print(cmd)
	subprocess.call(cmd, shell=True)