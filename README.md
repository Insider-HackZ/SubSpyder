# SubSpyder: Subdomain Enumeration and Live Domain Checker

SubSpyder is a Bash script designed for efficient subdomain enumeration and live domain verification. It uses a combination of open-source tools and APIs to find subdomains and check if they are accessible. The script supports multithreading for faster live domain checks and saves the results in specified output folders.

https://github.com/user-attachments/assets/b357037b-c01f-4d36-ad1e-00ebfb6144ef

## Features

- **Subdomain Enumeration**: Uses multiple tools (`crt.sh`, `amass`, `findomain`, `subfinder`, `assetfinder`, and `abuseipdb`) to discover subdomains.
- **Live Domain Check**: Utilizes `httprobe` to verify if subdomains are live.
- **Custom Output Directory**: Saves results in a specified directory.
- **Multithreading**: Allows specifying the number of threads for faster processing.

## Requirements

Before using SubSpyder, make sure you have the following dependencies installed:

- **Tools**:
  - `amass`
  - `findomain`
  - `subfinder`
  - `assetfinder`
  - `jq`
  - `httprobe`
  - `anew`
  - `curl`
- **Bash**: Ensure the script is run in a Unix-based environment with `bash` support.

## Installation

**Clone the repository**:

```bash
git clone https://github.com/Insider-HackZ/SubSpyder.git
cd SubSpyder
chmod +x setup.sh
chmod +x SubSpyder.sh
sudo ./setup.sh
```

1. **Install the required tools**. You can install them using package managers like `apt`, `brew`, or by downloading binaries directly from their respective repositories.

2. **Check if all tools are available**:

   ```
   ./subspyder.sh -h
   ```

   This will list the available options if the dependencies are installed correctly.

## Usage

To run the script, use the following command format:

```
./subspyder.sh -d <domain> [-o <output_folder>] [-t <threads>]
```

### Options

- `-d, --domain <domain>`: Specify the target domain for subdomain enumeration.
- `-o, --output <folder>`: Specify the output folder to save the results (default: `./.tmp`).
- `-t, --threads <number>`: Specify the number of threads for live domain checking (default: 20).
- `-h, --help`: Show the help message with usage details.

### Examples

1. **Basic Subdomain Enumeration**:

   ```
   ./subspyder.sh -d example.com
   ```

2. **Specify Output Folder**:

   ```
   ./subspyder.sh -d example.com -o /path/to/output
   ```

3. **Multithreaded Live Domain Check**:

   ```
   ./subspyder.sh -d example.com -t 30
   ```

## Output

- **All Subdomains**: A file named `All_<domain>.txt` containing all unique subdomains found.
- **Live Subdomains**: A file named `Live_<domain>.txt` containing only the live subdomains.
- If an output folder is specified, the results will be saved in that folder.

## Example Output

Running the tool will generate output like:

```
[+] Starting subdomain enumeration for example.com
[*] Finding subdomains for example.com using amass
[+] amass: 50
[*] Finding subdomains for example.com using findomain
[+] findomain: 40
...
[*] Subdomain enumeration completed.
[-] Total unique sub-domains found: 120
[*] Checking for Live Sub-Domain.
[-] Total Live sub-domains found: 80
```

## Acknowledgments

- Thanks to the developers of the tools integrated into SubSpyder: `amass`, `findomain`, `subfinder`, `assetfinder`, `crt.sh`, `abuseipdb`, and `httprobe`.
- Developed by: [@harshj054](https://www.linkedin.com/in/harsh-jain-7648382b7/)

> If anyone would like to contribute to the development of Insider-HackZ/APIScout, please send an email to [official@bytebloggerbase.com](mailto:official@bytebloggerbase.com).

