#!/bin/bash

#Assign Parameters 
fileUrl=$4

#Change Directory
cd /tmp

#store resulting file name as a variable
fileNameExtension=$(curl -s -0 -J -w '%{filename_effective}' "$fileUrl")

#Download file with basename 
curl -0 -J $fileUrl

fileName=${fileNameExtension%%. *}
fileExtension=${fileName Extension##*. }

#if file is a Zip file unzip package and change fileName Extension to .pkg file extension 
if [[ "$fileExtension" == "zip" ]]
then
    unzip $fileName Extension -d $fileName
    
    for file in /tmp/$fileName/$fileName/*; do 
        if [[ "$file" == *".pkg" ]]
        then
            #Install package
            installer -pkg "$file" -target /
        else
            echo ${file##*.} does not contain an expected filetype
        fi
    done
fi
if [[ "$fileExtension" == "pkg"]]
then
    installer -pkg /tmp/"$fileNameExtension" -target /
fi

#Post install cleanup
rm "$fileName".rm -rf /tmp/"$fileName" 

exit 0