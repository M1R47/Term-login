#!/system/bin/sh

#colors and other variables.
R='\033[1;31m'
C='\033[0;36m'
B='\033[1;34m'
G='\033[1;32m'
Y='\033[1;33m'
U='\033[3A'
FILE=$(which login)
LOCK="$PREFIX/bin/applets/lockscr"


#Banner
banner () {
    clear
    echo
    echo -e $B" ┌─────────────────────────┐ "
    echo -e $B" │$C      TERMUX LOGIN       $B│"
    echo -e $B" └─────────────────────────┘ "
    echo -e $R"  -> M1R47 "
    echo
    echo
}



#Check if lock already exists.
#if true then remove lock
if grep -q "export VAL" $FILE; then
    banner
    echo -en $Y" [*] eliminando Lock......................\r"
    sleep 1
    rm -f $LOCK
    sed -i '/VAL=/d' $FILE
    sed -i '/export VAL/d' $FILE
    echo -e $Y" [!] eliminando Lock......................$G DONE"
    echo

#if lock do not exist. set one
else

    if [ ! -d $PREFIX/bin/applets ]; then
        mkdir -p $PREFIX/bin/applets
    fi
    curl https://raw.githubusercontent.com/M1R47/M1R47/main/lock-script > $LOCK
    [ $? -ne 0 ] && echo -e "\ncanprobando Internet" && exit 1
    banner
    echo -en $Y" [*] configurando Lock.......................\r"
    sleep 1.5
    bash $LOCK set_lock
    err=$?

    banner
    echo -en $Y" [*] configurando Lock.......................\r"
    #if true set lock
    if [ $err -eq 0 ]; then

        sed -i "3 a export VAL; bash $LOCK; [ \$? -ne 0 ] && exit; unset VAL;" $FILE
        sleep 1.5
        echo -e $Y" [!] configurando Lock.......................$G DONE"
        echo

    #else skip setup and exit
    else
        rm -f $LOCK
        echo -e $Y" [!] configurando Lock.......................$R ERR"
        echo
        echo -e $R" [!] ok...                               "
        exit
    fi
fi

