
#!/bin/bash

# Check if a URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

# Function to trace redirects and populate urls.txt
trace_redirects() {
    local url="$1"
    local redirect_trace=$(curl -Ls -o /dev/null -w %{url_effective} "$url")

    # Clear the existing content of urls.txt
    > urls.txt

    # Add the original URL to the file
    echo "$url" >> urls.txt

    # Add each redirect to the file
    while [ "$url" != "$redirect_trace" ]; do
        echo "$redirect_trace" >> urls.txt
        url="$redirect_trace"
        redirect_trace=$(curl -Ls -o /dev/null -w %{url_effective} "$url")
    done
}

# Call the function with the provided URL
trace_redirects "$1"

# Display the contents of urls.txt
echo "Redirect trace saved in urls.txt:"
cat urls.txt
