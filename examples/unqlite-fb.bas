#include once "unqlite.bi"

declare function xPrint cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer

dim pDB as unqlite ptr

var rc = unqlite_open(@pDB,"test.unqlite",UNQLITE_OPEN_CREATE)
if rc <> UNQLITE_OK then
    print "Could not open the database"
    end __LINE__
end if

rc = unqlite_kv_store(pDB,"test",-1,@"Hello World",11)
if rc <> UNQLITE_OK then
    print "Could not store test in the database."
    unqlite_close(pDB)
    end __LINE__
end if

unqlite_kv_fetch_callback(pDB,"test",-1,@xPrint,0)

unqlite_close(pDB)

function xPrint cdecl(byval value as any ptr, byval vlen as uinteger, byval __ as any ptr) as integer
    var x = cast(zstring ptr,value)
    ? *x
    return UNQLITE_OK
end function
