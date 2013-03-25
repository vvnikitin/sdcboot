$ WRITE SYS$OUTPUT "Compiling ALLOCA..."
$ CC ALLOCA.C   /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling DFA..."
$ CC DFA.C      /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling GETOPT..."
$ CC GETOPT.C   /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling GREP..."
$ CC GREP.C     /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling KWSET..."
$ CC KWSET.C    /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling OBSTACK..."
$ CC OBSTACK.C  /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling REGEX..."
$ CC REGEX.C    /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Compiling SEARCH..."
$ CC SEARCH.C   /DEFINE=(HAVE_STRING_H,HAVE_MEMCHR,HAVE_STRERROR)
$ WRITE SYS$OUTPUT "Linking..."
$ LINK GREP,ALLOCA,DFA,GETOPT,KWSET,OBSTACK,REGEX,SEARCH
$ EXIT
