#!/bin/bash

# optool must be installed: cd /usr/bin && sudo curl -OL https://github.com/alexzielenski/optool/releases/download/0.1/optool.zip && sudo unzip /usr/bin/optool.zip -d /usr/bin && sudo rm -rf optool.zip

#function log { printf "\e[0;3%im==> \e[1;39m%s…\e[m\n" "$1" "$2"; }

echo "Insert here the cracked IPA:"
read crackedipa
#echo "$crackedipa"

echo "End directory: ~/Desktop"

rm -rf tempdire > /dev/null 2>&1
mkdir tempdire
cd tempdire

#cp "$crackedipa" cracked.ipa

unzip `realpath "$crackedipa"` > /dev/null 2>&1

echo "Downloading Exos... (it will take a while!)"

wget https://github.com/Sn0wCooder/Extensify-Exos/archive/master.zip > /dev/null 2>&1
unzip master.zip > /dev/null 2>&1
rm -rf Extensify-Exos-master/YouTube/Cercube3* > /dev/null 2>&1

filename=$(basename Payload/*)
extension="${filename##*.}"
filename="${filename%.*}"

echo "Filename of the IPA that will builded: $filename"

cp -r Extensify-Exos-master/$filename/*/* Payload/*/

#binary="$appdir/$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" "Payload/*/Info.plist")"

#otool -L "$exo_loader" | grep -o "@executable_path/.*\.dylib" | sort -u | while read -r payload; do
#	log 1 "Injecting $(basename "$payload")"
	#"$optool" install -c load -p "$payload" -t "$binary" > /dev/null
	#done

	EXT=dylib
	for i in Extensify-Exos-master/$filename/*/*; do
	    if [ "${i}" != "${i%.${EXT}}" ];then
			dylibname=$(basename $i)
	        echo "Injecting $dylibname"
			#ls
			optool install -c load -p @executable_path/$dylibname -t Payload/*/$filename > /dev/null 2>&1
	    fi
	done
tweakv=$(basename Extensify-Exos-master/$filename/*)
echo "Repacking..."
zip -9qry "app.ipa" "Payload" > /dev/null 2>&1
BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Payload/*/Info.plist)

newfilename=$filename-v$BUNDLE_VERSION-$tweakv.ipa
newfilename=`echo $newfilename|tr '-' '_'`

mv app.ipa ~/Desktop/$newfilename

#open .

#if [ -d "Payload/YouTube.app" ]; then
  # Control will enter here if $DIRECTORY exists.
  #fi
  # 


  #rm -rf ../tempdire