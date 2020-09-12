function git
    type -q $SCMPUFF_GIT_CMD; or set -x SCMPUFF_GIT_CMD (which git)

    if test (count $argv) -eq 0
        eval $SCMPUFF_GIT_CMD
        set -l s $status
        return $s
    end

    switch $argv[1]
        case blame log rebase merge
            eval command (scmpuff expand -- "$SCMPUFF_GIT_CMD" $argv)
        case checkout diff rm reset
            eval command (scmpuff expand --relative -- "$SCMPUFF_GIT_CMD" $argv)
        case commit add
            eval command (scmpuff expand -- "$SCMPUFF_GIT_CMD" $argv)
            scmpuff_status
        case config
            eval command "$SCMPUFF_GIT_CMD" (string escape -- $argv)
        case '*'
            eval command "$SCMPUFF_GIT_CMD" $argv
    end
end