#!/bin/bash
# For-loop for recon-all with qcache
# Usage: fs_autorecon.sh <nifti file(s)>
# Wild card can be used.
# nifti file name will be the subject id for FreeSurfer
# e.g. con001.nii -> con001

# 19 Jan 2019 K.Nemoto

#Check if the files are specified
if [ $# -lt 1 ]
then
	echo "Please specify nifti files!"
	echo "Usage: $0 <nifti_file(s)>"
	echo "Wild card can be used."
	exit 1
fi

#copy fsaverage and {lr}h.EC_average to $SUBJECTS_DIR if they don't exsit
find $SUBJECTS_DIR -maxdepth 1 | egrep fsaverage$ > /dev/null
if [ $? -eq 1 ]; then
  cp -r $FREESURFER_HOME/subjects/fsaverage $SUBJECTS_DIR
fi

find $SUBJECTS_DIR -maxdepth 1 | egrep [lr]h.EC_average$ > /dev/null
if [ $? -eq 1 ]; then
  cp -r $FREESURFER_HOME/subjects/[lr]h.EC_average $SUBJECTS_DIR
fi

#recon-all
for f in "$@"
do
    fsid=${f%.nii*}
    recon-all -i $f -s $fsid -all -qcache
done

exit

