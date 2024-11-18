#!/bin/bash

# Function to check if a tool is installed
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "[!] $1 is not installed. Installing..."
        return 1
    else
        echo "[+] $1 is already installed."
        return 0
    fi
}

# Install necessary tools
install_tools() {
    # Check and install required tools
    tools=("curl" "jq" "amass" "subfinder" "assetfinder" "findomain" "httprobe")

    for tool in "${tools[@]}"; do
        if ! check_tool "$tool"; then
            case $tool in
            "curl")
                sudo apt-get install curl -y
                ;;
            "jq")
                sudo apt-get install jq -y
                ;;
            "amass")
                sudo apt-get install amass -y
                ;;
            "subfinder")
                echo "[+] Installing Subfinder..."
                # Install Subfinder using Go (as an example)
                GO111MODULE=on go get -u github.com/projectdiscovery/subfinder/v2/cmd/subfinder
                ;;
            "assetfinder")
                echo "[+] Installing Assetfinder..."
                # Install Assetfinder using Go (as an example)
                GO111MODULE=on go get -u github.com/tomnomnom/assetfinder
                ;;
            "findomain")
                echo "[+] Installing Findomain..."
                # Findomain installation (as an example)
                wget https://github.com/Findomain/Findomain/releases/download/v7.0.0/findomain-linux -O findomain
                chmod +x findomain
                sudo mv findomain /usr/local/bin
                ;;
            "httprobe")
                echo "[+] Installing httprobe..."
                # Install httprobe using Go (as an example)
                GO111MODULE=on go get -u github.com/tomnomnom/httprobe
                ;;
            *)
                echo "[!] Unsupported tool: $tool"
                ;;
            esac
        fi
    done
}

# Install dependencies
install_dependencies() {
    echo "[*] Installing dependencies..."

    # Install jq for JSON processing
    if ! check_tool "jq"; then
        sudo apt-get install jq -y
    fi

    # Install curl
    if ! check_tool "curl"; then
        sudo apt-get install curl -y
    fi

    # Install amass (subdomain enumeration tool)
    if ! check_tool "amass"; then
        sudo apt-get install amass -y
    fi

    # Install Subfinder
    if ! check_tool "subfinder"; then
        echo "[+] Installing Subfinder..."
        GO111MODULE=on go get -u github.com/projectdiscovery/subfinder/v2/cmd/subfinder
    fi

    # Install Assetfinder
    if ! check_tool "assetfinder"; then
        echo "[+] Installing Assetfinder..."
        GO111MODULE=on go get -u github.com/tomnomnom/assetfinder
    fi

    # Install Findomain
    if ! check_tool "findomain"; then
        echo "[+] Installing Findomain..."
        wget https://github.com/Findomain/Findomain/releases/download/v7.0.0/findomain-linux -O findomain
        chmod +x findomain
        sudo mv findomain /usr/local/bin
    fi

    # Install httprobe
    if ! check_tool "httprobe"; then
        echo "[+] Installing httprobe..."
        GO111MODULE=on go get -u github.com/tomnomnom/httprobe
    fi
}

# Run the installation process
install_tools
install_dependencies

# Final message
echo "[*] Setup completed successfully!"
