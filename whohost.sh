
#!/bin/bash

# Check if a URLs file exists
if [ -f "urls.txt" ]; then
    # Read URLs from the file
    mapfile -t urls < "urls.txt"
    
    # Process each URL in the file
    for url in "${urls[@]}"; do
        # Extract the domain from the URL
        domain=$(echo "$url" | awk -F[/:] '{print $4}')
        
        # Use the host command with the extracted domain and extract IP addresses
        ip_addresses=$(host "$domain" | awk '/has address/ {print $4}')

        # Display the extracted IP addresses
        echo "IP addresses for $domain:"
        echo "$ip_addresses"

        # Prompt the user whether to run the whois command
        read -p "Do you want to run whois on the IP addresses? (y/n): " choice

        if [ "$choice" != "y" ]; then
            echo "Exiting script."
            exit 0
        fi

        # Run whois on the extracted IP addresses and display specific information
        for ip in $ip_addresses; do
            echo "Whois information for $ip:"
            whois_output=$(whois "$ip")

            # Extract and display NetRange section
            echo "NetRange Section:"
            echo "$whois_output" | awk -F':' '/^(NetRange|CIDR|NetName|Updated)/ {print "    "$1 ": " $2}' | sed 's/^ *//'
            echo "-----------------------------------------"

            # Extract and display Organization section
            echo "Organization Section:"
            echo "$whois_output" | awk -F':' '/^(OrgName|OrgId|Country|Updated)/ {print "    "$1 ": " $2}' | sed 's/^ *//'
            echo "-----------------------------------------"
        done
    done
else
    # Check if a URL is provided as a command-line argument
    if [ -z "$1" ]; then
        echo "Usage: $0 <url>"
        exit 1
    fi

    # Extract the domain from the provided URL
    domain=$(echo "$1" | awk -F[/:] '{print $4}')

    # Use the host command with the extracted domain and extract IP addresses
    ip_addresses=$(host "$domain" | awk '/has address/ {print $4}')

    # Display the extracted IP addresses
    echo "IP addresses for $domain:"
    echo "$ip_addresses"

    # Prompt the user whether to run the whois command
    read -p "Do you want to run whois on the IP addresses? (y/n): " choice

    if [ "$choice" != "y" ]; then
        echo "Exiting script."
        exit 0
    fi

    # Run whois on the extracted IP addresses and display specific information
    for ip in $ip_addresses; do
        echo "Whois information for $ip:"
        whois_output=$(whois "$ip")

        # Extract and display NetRange section
        echo "NetRange Section:"
        echo "$whois_output" | awk -F':' '/^(NetRange|CIDR|NetName|Updated)/ {print "    "$1 ": " $2}' | sed 's/^ *//'
        echo "-----------------------------------------"

        # Extract and display Organization section
        echo "Organization Section:"
        echo "$whois_output" | awk -F':' '/^(OrgName|OrgId|Country|Updated)/ {print "    "$1 ": " $2}' | sed 's/^ *//'
        echo "-----------------------------------------"
    done
fi
