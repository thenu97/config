function fish_prompt
    set user (whoami)
    set host (hostname | cut -d . -f 1)
    set cwd (prompt_pwd)

    # get current context quietly (no error output)
    set ctx (command kubectl config current-context ^/dev/null 2>/dev/null)

    set kube_part ""
    if test -n "$ctx"
        # strip ARN and show only the bit after the last slash
        set parts (string split "/" $ctx)
        set short_ctx $parts[-1]

        # get namespace quietly; if it fails, default to "default"
        set ns (command kubectl config view --minify --output 'jsonpath={.contexts[0].context.namespace}' 2>/dev/null)
        if test -z "$ns"
            set ns "default"
        end

        set kube_part "($short_ctx:$ns)"
    end


    # --- Git branch (if repo) ---
    set git_branch ""
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set branch (command git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            set git_branch "($branch)"
        end
    end

    echo -n (set_color blue)$user@(set_color magenta)$host" "(set_color normal)$cwd" "$git_branch" "$kube_part" ❯ "
end

