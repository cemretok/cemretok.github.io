#!/bin/bash
echo "sh giz.sh [1 dosya_adi] [2 e/d] [3 passprase] [4 is_blog (e/h)] [5 title] [6 date 2016-02-18 11:40:00] [7 category] [8 tag]"

function blog_encrypt {

        degisken="$(cat $1 |  gpg --symmetric --armor --passphrase "$2")"
		
		echo "---" > $1
        printf "layout: post\n" >> $1
        printf "title:  \"$3\"\n" >> $1
        printf "date:  $4\n" >> $1
        printf "categories: ["$5"]\n"  >> $1
        printf "tags: ["$6"]\n"  >> $1
        echo "---" >> $1
		echo "" >> $1
		
		echo "${degisken}" >> $1 
}

function blog_decrypt {
	tag2="$(sed -n '2p' "$1") \n"
	tag3="$(sed -n '3p' "$1") \n"
	tag4="$(sed -n '4p' "$1") \n"
	tag5="$(sed -n '5p' "$1") \n"
	tag6="$(sed -n '6p' "$1") \n"

	body="$(sed -n '9,$ p'  "$1")"

	echo "---" > $1
	printf "${tag2}"  >> $1
	printf "${tag3}"  >> $1
	printf "${tag4}"  >> $1
	printf "${tag5}"  >> $1
	printf "${tag6}"  >> $1
	echo "---"  >> $1
	echo "" >> $1
	
	echo "${body}" | gpg --passphrase "$2" >> $1
}

if [[ $1 == "git" ]]; then
	echo "git"	
else
	if [[ $2 == "e" ]]; then
		if [[ $4 == "e" ]]; then
			blog_encrypt "$1" "$3" "$5" "$6" "$7" "$8" 
		elif [[ $4 == "h" ]]; then
			cat $1 |  gpg --symmetric --armor --passphrase "$3" > $1		
	 	 	cat $1
		fi
	elif [[ $2 == "d" ]]; then
		if [[ $4 == "e" ]]; then
			blog_decrypt "$1" "$3"
		elif [[ $4 == "h" ]]; then
			cat $1 |  gpg --passphrase "$3" > $1
			cat $1
		fi
	fi
fi

