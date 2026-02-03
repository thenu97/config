function k9() {
    ops_root='/Users/thenuja.viknarajah/code/ops'
    if [ "$#" -ne 1 ]; then
        echo "Usage: k9 <env_number>"
        return 1
    fi

    local env_id
    env_id=$(printf "%06d" "$1")

    if [[ ! "$env_id" =~ ^[0-9]{6}$ ]]; then
        echo "Error: Environment number must be a number."
        return 1
    fi

    local envs_path="${ops_root}/etc/envs/${env_id}/main.yml"

    if [ ! -f "$envs_path" ]; then
        echo "Error: File '$envs_path' not found."
        return 1
    fi

    aws_account=$(grep 'luminance_aws_account' "$envs_path" | awk -F': ' '{print $2}')
    cloud_region=$(grep 'luminance_cloud_region' "$envs_path" | awk -F': ' '{print $2}')

    echo "Env: $env_id"
    echo "AWS Account: $aws_account"
    echo "Cloud Region: $cloud_region"

    typeset -A aws_account_ids
    aws_account_ids=(
        "prod-all-0"  "265272452509"
        "prod-eu-0"  "036566361716"
        "prod-us-0"  "992382844910"
        # Add more mappings as needed
    )

    # Get the AWS account ID from the associative array
    local aws_account_id="${aws_account_ids[$aws_account]}"

    local region_path="${ops_root}/etc/ansible/group_vars/aws_account/${aws_account}/${cloud_region}/main.yml"
    cluster_name=$(grep 'cluster_name' "$region_path" | awk -F': ' '{print $2}')

    local context="arn:aws:eks:${cloud_region}:${aws_account_id}:cluster/${cluster_name}"
    echo "Context: $context"

