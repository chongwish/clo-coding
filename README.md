# NAME

clo-coding - Char coding transform

# SYNOPSIS

    clo => Common Lisp Only
    coding => Encode/Decode the code

# Usage

    # load to system
    # link to the asd or ql path
    $> ln -s {clo-operator-path} {asd/ql-path}
    # or copy
    $> copy {clo-operator-path} {asd/ql-path}

    # utf8
    CL-User> (clo-coding.utf8:encode "你好")
    (14990752 15050173)

    CL-User> (clo-coding.utf8:decode '(14990752 15050173))
    (#\U4F60 #\U597D) => "你好"
