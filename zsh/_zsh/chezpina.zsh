local KEYFILE
KEYFILE="${HOME}/.ssh/chezpina-${USER}-cert.pub"

chezpina_ssh_check() {
    if [[ ! -f "$KEYFILE" ]]; then
        echo "No key at $KEYFILE"
        return
    fi

    NOW=$(date +'%Y-%m-%dT%H:%M:%S')
    THEN=$(ssh-keygen -L -f "$KEYFILE" | grep Valid | sed -e 's/.*to \(.*\)$/\1/')

    if [[ "$NOW" > "$THEN" ]]; then
        echo "expired"
        add_prompt_error "SSH_EXPIRED"
    fi
}


chezpina_init() {
    prompt_error_check_functions+=(chezpina_ssh_check)
}
