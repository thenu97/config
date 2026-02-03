function kctx
    set ctx (kubectl ctx | grep $argv[1])
    if test -n "$ctx"
        kubectl ctx $ctx
    else
        echo "No matching context for $argv[1]"
    end
end
