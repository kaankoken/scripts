#! /bin/bash

function helper {
    echo '''
    Usage: create-sh-binary [OPTIONS]

    -h or --help: show this help message and exit
    -f or --file: input bash file to be converted to binary
    -o or --output: output file name

    Example 
    create-sh-binary.sh -f your-bash-file.sh -o your-binary-file
    or
    create-sh-binary -f your-bash-file.sh
    or
    create-sh-binary -f path/to/your-bash-file.sh -o path/to/your-binary-file
    '''
}

if [[ $@ == *"-h"* || $@ == *"--help"* ]]
then
    helper
else
    GOOD_TO_GO=false
    if [[ $@ == *"-f "* || $@ == *"-o "* ]]
    then
        GOOD_TO_GO=true
    fi

    if [[ $@ == *"--file "* || $@ == *"--output "* ]]
    then
        GOOD_TO_GO=true
    fi
        if [ $GOOD_TO_GO == false ]
    then
        echo "Invalid arguments"
        helper
        exit 1
    fi

    # split arguments into an array with spaces as delimiter
    IFS=' ' read -r -a args <<< "$@"
    if [[ "${#args[@]}" != "2" && "${#args[@]}" != "4" ]]
    then
        echo "Not enough arguments"
        helper
        exit 1
    fi

    for i in "${!args[@]}"
    do
        if [ "${args[$i]}" == "-f" ] || [ "${args[$i]}" == "--file" ]
        then
            file=${args[$i+1]}
        fi
        if [ "${args[$i]}" == "-o" ] || [ "${args[$i]}" == "--output" ]
        then
            output=${args[$i+1]}
        fi
    done

    if [ -z "$file" ]
    then
        echo "No input file specified"
        helper
        exit 1
    fi

    if [ -z "$output" ]
    then
        # split arguments into an array with spaces as delimiter
        IFS=' ' read -r -a args2 <<< "$@"
        output=${args2[${#args2[@]} - 1]}

        # split arguments into an array with '.' as delimiter
        IFS='.' read -r -a args2 <<< "$output"
        output=${args2[0]}
    fi
    
    shc -f $file -o $output
fi
