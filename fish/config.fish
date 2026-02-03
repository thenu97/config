if status is-interactive
    # Commands to run in interactive sessions can go here
    set -Ux TERM xterm-256color
    export TG_PROVIDER_CACHE=true
    set -Ux TF_VAR_env_dir /Users/thenuja.viknarajah/code/envs
    set -gx PATH $HOME/.krew/bin $PATH
    pyenv init - | source
    source $HOME/.config/fish/functions/kube_context.fish
    function fish_right_prompt
        #intentionally left blank
    end
end

if status is-login
    if not test -e /tmp/fish_startup_done_$USER
        ssh-add ~/.ssh/gitlab_id_ed25519
        touch /tmp/fish_startup_done_$USER
    end
end

