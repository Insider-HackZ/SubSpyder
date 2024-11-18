#!/bin/bash
green="\e[32m"
blue="\e[34m"
yellow="\e[33m"
end="\e[0m"

show_help() {
    echo "SubSpyder - A tool for subdomain enumeration and live domain checks"
    echo ""
    echo "Usage: ./Subspyder.sh [options]"
    echo ""
    echo "Options:"
    echo "  -d, --domain <domain>        Specify the target domain for subdomain enumeration"
    echo "  -o, --output <folder>        Specify the output folder to save results "
    echo "  -t, --threads <number>       Specify the number of threads (default: 20)"
    echo "  -h, --help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./subspyder.sh -d example.com"
    echo "  ./subspyder.sh -d example.com -o /path/to/output -t 20"
    echo ""
}

function banner() {
  cat << "EOF"
        _____       __   _____                 __         
       / ___/__  __/ /_ / ___/____  __  ______/ /__  _____
       \__ \/ / / / __ \\__ \/ __ \/ / / / __  / _ \/ ___/
      ___/ / /_/ / /_/ /__/ / /_/ / /_/ / /_/ /  __/ /
     /____/\__,_/_.___/____/ .___/\__, /\__,_/\___/_/
                          /_/    /____/ Developed by:@harshj054
EOF
}
banner|lolcat

check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "[!] $1 not found, skipping..."
        return 1
    else
        return 0
    fi
}
# Default values
domain=""
output_file=""
thread=20

# Parse command line options
while [[ "$1" =~ ^- ]]; do
    case "$1" in
        -d|--domain)
            domain=$2
            shift 2
            ;;
        -o|--output)
            output_file=$2
            shift 2
            ;;
        -t|--threads)
            thread=$2
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if domain is provided
if [ -z "$domain" ]; then
    echo "Usage: $0 -d <domain> [-o <output_file>] [-t <threads>]"
    exit 1
fi

if [ -z "$output_file" ]; then
    output_file="./.tmp"  
    mkdir -p "$output_file"  
else
    mkdir -p "$output_file"  
    echo "[*] Using specified output folder: $output_file"
fi
echo "[+] Starting subdomain enumeration for $domain"


tools=("crt" "amass" "findomain" "subfinder" "assetfinder" "abuseipdb")

for tool in "${tools[@]}"; do
    if [[ "$tool" == "crt" || "$tool" == "abuseipdb" ]] || check_tool "$tool"; then
        echo -e "$blue[*] Finding subdomains for $domain using $tool$end"
        case $tool in
        "abuseipdb")
            curl -s "https://www.abuseipdb.com/whois/$domain" -H "user-agent: firefox" -b "abuseipdb_session=" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' | sed -e "s/$/.$domain/" | anew $output_file/abuseipdb.txt > /dev/null 2>&1
            count=$(cat "$output_file/abuseipdb.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        "subfinder")
            subfinder -d "$domain" -o "$output_file/subfinder.txt" > /dev/null 2>&1
            count=$(cat "$output_file/subfinder.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        "amass")
            amass enum -passive -norecursive -noalts -d "$domain" -o "$output_file/amaas.txt" > /dev/null 2>&1
            count=$(cat "$output_file/amaas.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        "assetfinder")
            assetfinder --subs-only "$domain" > "$output_file/assetfinder.txt" 2>/dev/null
             count=$(cat "$output_file/assetfinder.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        "crt")
             curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[] | .name_value | split("\n")[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u >> "$output_file/crt_sh.txt"
             count=$(cat "$output_file/crt_sh.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        "findomain")
            findomain -t $domain -u $output_file/findomain.txt &>/dev/null
             count=$(cat "$output_file/findomain.txt" | wc -l)
            echo -e "$green[+] $tool: $end $count"
            ;;
        *)
            echo "[!] Tool $tool is not configured correctly or not supported."
            ;;
        esac
    fi
done
echo "[*] Subdomain enumeration completed."
cat $output_file/*.txt | sort -u > "$output_file/all.txt"
count=$(cat "$output_file/all.txt" | wc -l)
echo -e "[-] Total unique sub-domains found: $yellow$count$end"

echo -e "$blue[*] Checking for Live Sub-Domain.$end"
cat $output_file/all.txt| httprobe -c $thread > Live_$domain.txt
count=$(cat "Live_$domain.txt" | wc -l)
echo -e "[-] Total Live sub-domains found: $yellow$count$end"
mv "$output_file/all.txt" "All_$domain.txt"

rm -rf $output_file

if [ "$output_file" != "./.tmp" ]; then
    mkdir -p "$output_file"
    echo "[*] Saving output in user-defined folder: $output_file"
    mv "All_$domain.txt" "$output_file/All_$domain.txt"
    mv "Live_$domain.txt" "$output_file/Live_$domain.txt"
fi
