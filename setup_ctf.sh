#!/bin/bash

set -e  # Exit if any command fails

# Define the number of levels
LEVELS=11

# Base directory for home directories
BASE_DIR="/home"

# Create random passwords for each level
PASSWORDS=()
for i in $(seq 0 $LEVELS); do
    PASSWORDS[$i]=$(openssl rand -base64 12)
done

# Create users and set up challenges
for i in $(seq 0 $LEVELS); do
    USER="lab$i"
    HOME_DIR="$BASE_DIR/$USER"
    
    echo "[+] Creating user: $USER"
    
    # Create user with no password and home directory
    useradd -m -s /bin/bash "$USER"
    
    # Set password for the user
    echo "$USER:${PASSWORDS[$i]}" | chpasswd
    
    # Set proper permissions for home directory
    chmod 750 "$HOME_DIR"
    chown "$USER:$USER" "$HOME_DIR"

    # Add welcome message and hint to .profile
    cat >> "$HOME_DIR/.profile" << EOL

echo "
╔════════════════════════════════════════════╗
║             Welcome to Level $i              
║════════════════════════════════════════════║"

case $i in
    0)
        echo "║ HINT: Sometimes things are just plain    ║
║      text. Look around!                  ║"
    ;;
    1)
        echo "║ HINT: There's a needle in this haystack  ║
║      of A's. Can you find it?           ║"
    ;;
    2)
        echo "║ HINT: Not everything that exists can be  ║
║      seen at first glance...            ║"
    ;;
    3)
        echo "║ HINT: Permissions are key! What can you  ║
║      do when you can't do anything?     ║"
    ;;
    4)
        echo "║ HINT: One of these files is not like    ║
║      the others...                      ║"
    ;;
    5)
        echo "║ HINT: Compressed files might hold        ║
║      secrets. Do you know how to unzip? ║"
    ;;
    6)
        echo "║ HINT: Base64 is a common way to encode  ║
║      data. Can you decode it?           ║"
    ;;
    7)
        echo "║ HINT: System logs contain a lot of      ║
║      information. Read carefully!       ║"
    ;;
    8)
        echo "║ HINT: Your shell environment holds many ║
║      secrets. Can you find them?        ║"
    ;;
    9)
        echo "║ HINT: Scripts have permissions too.     ║
║      How can you execute this one?      ║"
    ;;
    10)
        echo "║ HINT: This Python script has bugs.      ║
║      Debug and fix it to get the flag!  ║"
    ;;
esac
echo "╚════════════════════════════════════════════╝

Current level: lab$i
Try to find the password for the next level!
"
EOL
    
    # Set proper permissions for .profile
    chown "$USER:$USER" "$HOME_DIR/.profile"
    chmod 700 "$HOME_DIR/.profile"

    # Create a flag for the user containing the password for the next user
    if [[ $i -lt $LEVELS ]]; then
        NEXT_PASSWORD="${PASSWORDS[$((i + 1))]}"
    else
        NEXT_PASSWORD="Congratulations! You've completed all levels!"
    fi
    
    # Set up challenge files
    case $i in
        0)
            su - "$USER" -c "echo '$NEXT_PASSWORD' > '$HOME_DIR/password.txt'"
        ;;
        1)
            # Generate between 100-1000 'A's, add the password somewhere in between
            su - "$USER" -c "for i in \$(seq \$((RANDOM % 900 + 100))); do echo -n 'A' >> '$HOME_DIR/find_me.txt'; done && echo '$NEXT_PASSWORD' >> '$HOME_DIR/find_me.txt' && for i in \$(seq \$((RANDOM % 900 + 100))); do echo -n 'A' >> '$HOME_DIR/find_me.txt'; done"
        ;;
        2)
            su - "$USER" -c "echo '$NEXT_PASSWORD' > '$HOME_DIR/.hidden_password'"
        ;;
        3)
            su - "$USER" -c "echo '$NEXT_PASSWORD' > '$HOME_DIR/secret.txt'"
            chmod 000 "$HOME_DIR/secret.txt"
            chown "$USER:$USER" "$HOME_DIR/secret.txt"
        ;;
        4)
            su - "$USER" -c "mkdir '$HOME_DIR/many_files'"
            for j in {1..50}; do
                su - "$USER" -c "openssl rand -base64 12 > '$HOME_DIR/many_files/file$j.txt'"
            done
            su - "$USER" -c "echo '$NEXT_PASSWORD' > '$HOME_DIR/many_files/file51.txt'"
            for j in {52..73}; do
                su - "$USER" -c "openssl rand -base64 12 > '$HOME_DIR/many_files/file$j.txt'"
            done
        ;;
        5)
            # Create the password file and zip it
            su - "$USER" -c "echo '$NEXT_PASSWORD' > '$HOME_DIR/hidden.txt'"
            su - "$USER" -c "cd '$HOME_DIR' && zip -m hidden.zip hidden.txt"
        ;;
        6)
            su - "$USER" -c "echo -n '$NEXT_PASSWORD' | base64 > '$HOME_DIR/encoded.txt'"
        ;;
        7)
            # Create a realistic-looking syslog file with the password hidden in it
            su - "$USER" -c "cat > '$HOME_DIR/system.log' << EOL
[2024-03-15 08:23:45] sshd[2547]: Failed password for invalid user admin from 192.168.1.100 port 43150 ssh2
[2024-03-15 08:23:47] kernel: [UFW BLOCK] IN=eth0 OUT= MAC=00:1a:2b:3c:4d:5e SRC=10.0.0.15 DST=10.0.0.1 LEN=40
[2024-03-15 08:24:01] cron[3420]: (root) CMD (/usr/local/bin/backup.sh)
[2024-03-15 08:24:15] auth: password authentication failed for user root
[2024-03-15 08:24:30] backup: Successfully backed up /etc/passwd to remote server
[2024-03-15 08:24:45] system: Critical security update available: USN-4557-1
[2024-03-15 08:25:01] cron[3421]: (lab7) COMMAND (echo '$NEXT_PASSWORD' > /dev/null 2>&1)
[2024-03-15 08:25:15] sshd[2548]: Accepted password for user lab7 from 192.168.1.105 port 43151 ssh2
[2024-03-15 08:25:30] kernel: [UFW ALLOW] IN=eth0 OUT= MAC=00:1a:2b:3c:4d:5e SRC=10.0.0.20 DST=10.0.0.1 LEN=40
EOL"
        ;;
        8)
            su - "$USER" -c "echo 'export SECRET_PASSWORD=$NEXT_PASSWORD' >> '$HOME_DIR/.bashrc'"
        ;;
        9)
            su - "$USER" -c "echo -e '#!/bin/bash\necho \"$NEXT_PASSWORD\"' > '$HOME_DIR/get_password.sh'"
            chmod 000 "$HOME_DIR/get_password.sh"
        ;;
        10)
            # Create a Python script that requires debugging/modification to reveal password
            su - "$USER" -c "cat > '$HOME_DIR/get_flag.py' << EOL
#!/usr/bin/env python3
def decrypt_password(encoded):
    # Bug: reversed string is processed incorrectly
    decoded = ''
    for i in range(0, len(encoded), 2):
        decoded += chr(int(encoded[i:i+2], 16))
    return decoded

def main():
    # Password is hex-encoded and reversed
    encoded = '$(echo -n "$NEXT_PASSWORD" | xxd -p | rev)'

    try:
        # Artificial bug: causes error on first run
        with open('/tmp/debug.log', 'r') as f:
            print('Debug mode activated')

        result = decrypt_password(encoded)
        print(f'Flag: {result}')
    except:
        print('Error: Debug file not found. Create /tmp/debug.log to proceed.')

if __name__ == '__main__':
    main()
EOL"
            chmod +x "$HOME_DIR/get_flag.py"
            
            # Create a hint file
            su - "$USER" -c "echo 'Hint: The script has bugs. Fix them to get the flag.' > '$HOME_DIR/README.txt'"
        ;;
        11)
            su - "$USER" -c "echo 'Congratulations! You have completed all levels!' > '$HOME_DIR/congratulations.txt'"
        ;;
    esac
    
    # Set proper ownership and permissions for all files
    chown -R "$USER:$USER" "$HOME_DIR"
    chmod -R 700 "$HOME_DIR"
done

# Fix permissions for level 3's secret.txt after the general chmod
chmod 000 "/home/lab3/secret.txt"
chmod 000 "/home/lab9/get_password.sh"
chmod +x "/home/lab9/get_password.sh"

# Save the initial password for lab0 so it can be retrieved
echo "Initial password for lab0: ${PASSWORDS[0]}" > /root/initial_password.txt

echo "[+] CTF Setup Complete!"
echo "[*] Players start by SSHing into lab0 using the password in /root/initial_password.txt"

exit 0