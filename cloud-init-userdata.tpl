#!/bin/bash

# Function to retrieve and update SSH key parameters
retrieve_and_update_ssh_key() {
    local key_type="$1"
    local lowercase_key_type="$${key_type,,}"
    local public_parameter_name="${param_path}/SSH_HOST_$${key_type}_PUBLIC_KEY"
    local private_parameter_name="${param_path}/SSH_HOST_$${key_type}_PRIVATE_KEY"
    local public_key_file="/etc/ssh/ssh_host_$${lowercase_key_type}_key.pub"
    local private_key_file="/etc/ssh/ssh_host_$${lowercase_key_type}_key"

    echo "Retrieving the Host SSH $${key_type} public key from Parameter Store..."
    parameter_value=$(aws ssm get-parameter --name "$public_parameter_name" --region ${region} --with-decryption --query "Parameter.Value" --output text)
    echo "Retrieved Host SSH $${key_type} public key: $parameter_value"

    # Check if $parameter_value is empty or contains only whitespace characters
    if [[ -z "$parameter_value" || "$parameter_value" =~ ^[[:space:]]+$ ]]; then
        echo "The Host SSH $${key_type} public key does not exist or is empty or contains only whitespace characters."
        echo "Reading the contents of $public_key_file..."
        parameter_value=$(cat "$public_key_file")
        echo "Read Host SSH $${key_type} public key: $parameter_value"

        if [[ -n "$parameter_value" ]]; then
            echo "Writing Host SSH $${key_type} public key to the parameter..."
            aws ssm put-parameter --name "$public_parameter_name" --value "$parameter_value" --type SecureString --region ${region} --overwrite
            echo "Host SSH $${key_type} public key written to the parameter $public_parameter_name"
        else
            echo "The Host SSH $${key_type} public key from $public_key_file is empty or contains only whitespace characters. Skipping parameter update."
        fi
    else
        echo "Host SSH $${key_type} public key exists and is non-empty."
        echo "Writing the contents of the Host SSH $${key_type} public key to $public_key_file..."
        echo "$parameter_value" > "$public_key_file"
        echo "Host SSH $${key_type} public key written to $public_key_file"
    fi

    echo "Retrieving the Host SSH $${key_type} private key from Parameter Store..."
    parameter_value=$(aws ssm get-parameter --name "$${private_parameter_name}" --region ${region} --with-decryption --query "Parameter.Value" --output text)
    echo "Retrieved Host SSH $${key_type} private key: $parameter_value"

    # Check if $parameter_value is empty or contains only whitespace characters
    if [[ -z "$parameter_value" || "$parameter_value" =~ ^[[:space:]]+$ ]]; then
        echo "The Host SSH $${key_type} private key does not exist or is empty or contains only whitespace characters."
        echo "Reading the contents of $private_key_file..."
        parameter_value=$(cat "$private_key_file")
        echo "Read Host SSH $${key_type} private key: $parameter_value"

        if [[ -n "$parameter_value" ]]; then
            echo "Writing Host SSH $${key_type} private key to the parameter..."
            aws ssm put-parameter --name "$${private_parameter_name}" --value "$parameter_value" --type SecureString --region ${region} --overwrite
            echo "Host SSH $${key_type} private key written to the parameter $${private_parameter_name}"
        else
            echo "The Host SSH $${key_type} private key from $private_key_file is empty or contains only whitespace characters. Skipping parameter update."
        fi
    else
        echo "Host SSH $${key_type} private key exists and is non-empty."
        echo "Writing the contents of the Host SSH $${key_type} private key to $private_key_file..."
        echo "$parameter_value" > "$private_key_file"
        echo "Host SSH $${key_type} private key written to $private_key_file"
    fi
}
# Loop through the ssh_keys and append them to the authorized_keys file
%{ for key in ssh_keys ~}
echo "${key}" >> /home/ec2-user/.ssh/authorized_keys
%{ endfor ~}

# Retrieve and update SSH keys for different types
retrieve_and_update_ssh_key "ECDSA"
retrieve_and_update_ssh_key "ED25519"
retrieve_and_update_ssh_key "RSA"
