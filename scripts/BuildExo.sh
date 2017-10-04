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

echo "Downloading Exo(s)... (it will take a while!)"

#tweakv=$(svn ls https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename) > /dev/null 2>&1

#echo $tweakv >> tweakv.txt
# 
# 
# 
svn ls https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename >> ../tweakv.txt
EXT=dylib
cat ../tweakv.txt | while read p
do
	
	rm -rf *
	
	svn checkout https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename/$p > /dev/null 2>&1
	
	ditto -xk $crackedipa . > /dev/null 2>&1
	
	p=${p%/}
	
	echo $p >> ../twk.txt
	
	echo "I'm building Exo $p..."

	cp -r $p/* Payload/$filename.app/

	for i in $p/*; do
		if [ "${i}" != "${i%.${EXT}}" ];then
			dylibname=$(basename $i)
			echo "Injecting $dylibname..."
			optool install -c load -p @executable_path/$dylibname -t Payload/*/$filename > /dev/null 2>&1
		fi
	done
	
	echo "Repacking..."
	zip -9qry "app.ipa" "Payload" > /dev/null 2>&1
	BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Payload/*/Info.plist)

	newfilename=$filename-v$BUNDLE_VERSION-$p.ipa
	newfilename=`echo $newfilename|tr '-' '_'`

	mv app.ipa ~/Desktop/$newfilename
	
	#rm -rf app.ipa
	
	echo "Saved with filename $newfilename"

done



# if number of ipas > 1
echo
echo
echo

rm -rf *
cat ../tweakv.txt | while read p
do
	svn checkout https://github.com/Sn0wCooder/Extensify-Exos/trunk/$filename/$p > /dev/null 2>&1
done

NUMBEROFTWEAKS=$(find ./* -maxdepth 0 -type d | wc -l)

echo "Number of tweaks: $NUMBEROFTWEAKS"

if (( NUMBEROFTWEAKS > 1 )); then
	


	ditto -xk $crackedipa . > /dev/null 2>&1

	cat ../twk.txt | while read p
	do
		echo -n "_$p" >> ../tweakadded.txt
		cp -r $p/* Payload/$filename.app
		
		for i in $p/*; do
			if [ "${i}" != "${i%.${EXT}}" ];then
				dylibname=$(basename $i)
				echo "Injecting $dylibname..."
				optool install -c load -p @executable_path/$dylibname -t Payload/*/$filename > /dev/null 2>&1
			fi
		done
	done

	echo "Repacking..."
	zip -9qry "app.ipa" "Payload" > /dev/null 2>&1
	BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Payload/*/Info.plist)

#cat ../twk.txt | while read p
#do
#	echo "_$p" > ../tweakadded.txt
#done

	tweakadded=$(cat ../tweakadded.txt)

	newfilename=$filename-v$BUNDLE_VERSION$tweakadded.ipa
	newfilename=`echo $newfilename|tr '-' '_'`

	mv app.ipa ~/Desktop/$newfilename

fi

rm -rf ../tweakv.txt > /dev/null 2>&1
rm -rf ../twk.txt > /dev/null 2>&1
rm -rf ../tweakadded.txt > /dev/null 2>&1

echo "FINISHED!"