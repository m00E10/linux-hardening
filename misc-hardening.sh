gpasswd -d $user adm
echo "password    required    pam_unix.so sha512 shadow nullok rounds=65536"             > /etc/pam.d/passwd
echo "b08dfa6083e7567a1921a715000001fb"                                                  > /etc/machine-id
pacman -S macchanger --noconfirm
macchanger wlan0 -e -m "de:ad:be:ef:ca:fe"

# change /etc/profile umask to 0077
# remove all mirrors from /etc/pacman.d/mirrorlist that dont contain https
