#!/bin/bash

if which optool >/dev/null; then
    echo "optool is installed"
else
	echo "optool is NOT installed. Proceed with installation..."
    cd /usr/bin > /dev/null 2>&1
	sudo curl -OL https://github.com/alexzielenski/optool/releases/download/0.1/optool.zip > /dev/null 2>&1
	sudo unzip /usr/bin/optool.zip -d /usr/bin > /dev/null 2>&1
	sudo rm -rf optool.zip > /dev/null 2>&1
	cd
fi

echo "Insert here the cracked IPA:"
read crackedipa

echo "End directory: ~/Desktop"

rm -rf tempdire > /dev/null 2>&1
mkdir tempdire
cd tempdire
unzip `realpath "$crackedipa"` > /dev/null 2>&1

filename=$(basename Payload/*)
extension="${filename##*.}"
filename="${filename%.*}"

echo "IPA selected for build Exo: $filename"

echo "Downloading Exo... (it will take a while!)"

tweakv=$(svn ls https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename) > /dev/null 2>&1

svn checkout https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename/$tweakv > /dev/null 2>&1

tweakv=${tweakv%/}

cp -r $tweakv/* Payload/$filename.app/

EXT=dylib
for i in $tweakv/*; do
	if [ "${i}" != "${i%.${EXT}}" ];then
		dylibname=$(basename $i)
	    echo "Injecting $dylibname..."
		optool install -c load -p @executable_path/$dylibname -t Payload/*/$filename > /dev/null 2>&1
	fi
done
echo "Repacking..."
zip -9qry "app.ipa" "Payload" > /dev/null 2>&1
BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Payload/*/Info.plist)

newfilename=$filename-v$BUNDLE_VERSION-$tweakv.ipa
newfilename=`echo $newfilename|tr '-' '_'`

mv app.ipa ~/Desktop/$newfilename

echo "Saved with filename $newfilename"