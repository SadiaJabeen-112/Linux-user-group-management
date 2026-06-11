#!/bin/bash

# ==========================================
# Interactive User & Group Management Tool
# ==========================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pause() {
    read -rp "Press Enter to continue..."
}

create_user() {
    read -rp "Enter username to create: " username

    if id "$username" &>/dev/null; then
        echo -e "${RED}User already exists.${NC}"
    else
        useradd -m "$username"

        read -rsp "Enter password: " password
        echo

        echo "$username:$password" | chpasswd

        echo -e "${GREEN}User '$username' created successfully.${NC}"
    fi
}

delete_user() {
    read -rp "Enter username to delete: " username

    if id "$username" &>/dev/null; then
        read -rp "Are you sure? (yes/no): " confirm

        if [[ "$confirm" == "yes" ]]; then
            userdel -r "$username"
            echo -e "${GREEN}User deleted successfully.${NC}"
        fi
    else
        echo -e "${RED}User does not exist.${NC}"
    fi
}

modify_user() {
    read -rp "Enter existing username: " username

    if id "$username" &>/dev/null; then
        read -rp "Enter new username: " newuser
        usermod -l "$newuser" "$username"
        echo -e "${GREEN}User renamed successfully.${NC}"
    else
        echo -e "${RED}User not found.${NC}"
    fi
}

lock_user() {
    read -rp "Enter username to lock: " username

    if id "$username" &>/dev/null; then
        passwd -l "$username"
        echo -e "${GREEN}User account locked.${NC}"
    else
        echo -e "${RED}User not found.${NC}"
    fi
}

unlock_user() {
    read -rp "Enter username to unlock: " username

    if id "$username" &>/dev/null; then
        passwd -u "$username"
        echo -e "${GREEN}User account unlocked.${NC}"
    else
        echo -e "${RED}User not found.${NC}"
    fi
}

reset_password() {
    read -rp "Enter username: " username

    if id "$username" &>/dev/null; then
        read -rsp "Enter new password: " password
        echo

        echo "$username:$password" | chpasswd

        echo -e "${GREEN}Password reset successful.${NC}"
    else
        echo -e "${RED}User not found.${NC}"
    fi
}

create_group() {
    read -rp "Enter group name: " groupname

    if getent group "$groupname" >/dev/null; then
        echo -e "${RED}Group already exists.${NC}"
    else
        groupadd "$groupname"
        echo -e "${GREEN}Group created successfully.${NC}"
    fi
}

delete_group() {
    read -rp "Enter group name: " groupname

    if getent group "$groupname" >/dev/null; then
        groupdel "$groupname"
        echo -e "${GREEN}Group deleted successfully.${NC}"
    else
        echo -e "${RED}Group not found.${NC}"
    fi
}

add_user_group() {
    read -rp "Enter username: " username
    read -rp "Enter group name: " groupname

    usermod -aG "$groupname" "$username"

    echo -e "${GREEN}User added to group successfully.${NC}"
}

remove_user_group() {
    read -rp "Enter username: " username
    read -rp "Enter group name: " groupname

    gpasswd -d "$username" "$groupname"

    echo -e "${GREEN}User removed from group successfully.${NC}"
}

user_info() {
    read -rp "Enter username: " username

    id "$username"
}

group_info() {
    read -rp "Enter group name: " groupname

    getent group "$groupname"
}

while true
do
    clear

    echo "======================================"
    echo " USER & GROUP MANAGEMENT TOOL"
    echo "======================================"
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Modify User"
    echo "4. Lock User"
    echo "5. Unlock User"
    echo "6. Reset Password"
    echo "7. Create Group"
    echo "8. Delete Group"
    echo "9. Add User to Group"
    echo "10. Remove User from Group"
    echo "11. Display User Information"
    echo "12. Display Group Information"
    echo "13. Exit"
    echo "======================================"

    read -rp "Select an option: " choice

    case $choice in
        1) create_user ;;
        2) delete_user ;;
        3) modify_user ;;
        4) lock_user ;;
        5) unlock_user ;;
        6) reset_password ;;
        7) create_group ;;
        8) delete_group ;;
        9) add_user_group ;;
        10) remove_user_group ;;
        11) user_info ;;
        12) group_info ;;
        13) echo "Goodbye!"; exit 0 ;;
        *) echo -e "${RED}Invalid Option${NC}" ;;
    esac

    pause
done