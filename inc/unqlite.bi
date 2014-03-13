/'
 * This Header is licensed under the same license as UnQLite but is
 * Copyright (c) 2014 Ebben Feagan http://mud.owlbox.net
 *
 * Symisc UnQLite: An Embeddable NoSQL (Post Modern) Database Engine.
 * Copyright (C) 2012-2013, Symisc Systems http://unqlite.org/
 * Version 1.1.6
 * For information on licensing, redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES
 * please contact Symisc Systems via:
 *       legal@symisc.net
 *       licensing@symisc.net
 *       contact@symisc.net
 * or visit:
 *      http://unqlite.org/licensing.html
 */
/*
 * Copyright (C) 2012, 2013 Symisc Systems, S.U.A.R.L [M.I.A.G Mrad Chems Eddine <chm@symisc.net>].
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY SYMISC SYSTEMS ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 * NON-INFRINGEMENT, ARE DISCLAIMED.  IN NO EVENT SHALL SYMISC SYSTEMS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 '/
#ifndef __unqlite_bi__
#define __unqlite_bi__

#include once "crt/stdarg.bi"

#if __FB_MT__ = -1
	#inclib "unqlite-mt"
#else
	#inclib "unqlite"
#endif

#define UNQLITE_VERSION "1.1.6"
#define UNQLITE_VERSION_NUMBER 1001006
#define UNQLITE_SIG "unqlite/1.1.6"
#define UNQLITE_IDENT "unqlite:b172a1e2c3f62fb35c8e1fb2795121f82356cad6"
#define UNQLITE_COPYRIGHT "Copyright (C) Symisc Systems, S.U.A.R.L [Mrad Chems Eddine <chm@symisc.net>] 2012-2013, http://unqlite.org/"

type unqlite_io_stream as any
type jx9_io_stream as uqlite_io_stream
type unqlite_context as any
type jx9_context as unqlite_context
type unqlite_value as any
type jx9_value as unqlite_value
type unqlite_vm as any
type unqlite as any

type sxi64 as longint
type sxu64 as ulongint

type ProcConsumer as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer

type SyMutex as any

type syiovec
#ifdef __FB_WIN32__
	nLen as uinteger
	pBase as ubyte ptr
#else
	pBase as any ptr
	nLen as uinteger
#endif
end type

type SyString
	sdata as zstring ptr
	nByte as uinteger
end type

type Sytm
	tm_sec as integer
	tm_min as integer
	tm_hour as integer
	tm_mday as integer
	tm_mon as integer
	tm_year as integer
	tm_wday as integer
	tm_yday as integer
	tm_isdst as integer
	tm_zone as zstring ptr
	tm_gmtoff as integer
end type

'/* Convert a tm structure (struct tm *) found in <time.h> to a Sytm structure */
#macro STRUCT_TM_TO_SYTM(pTM, pSYTM)
	(pSYTM)->tm_hour = (pTM)->tm_hour
	(pSYTM)->tm_min	 = (pTM)->tm_min
	(pSYTM)->tm_sec	 = (pTM)->tm_sec
	(pSYTM)->tm_mon	 = (pTM)->tm_mon
	(pSYTM)->tm_mday = (pTM)->tm_mday
	(pSYTM)->tm_year = (pTM)->tm_year + 1900
	(pSYTM)->tm_yday = (pTM)->tm_yday
	(pSYTM)->tm_wday = (pTM)->tm_wday
	(pSYTM)->tm_isdst = (pTM)->tm_isdst
	(pSYTM)->tm_gmtoff = 0
	(pSYTM)->tm_zone = 0
#endmacro

#ifdef __FB_WIN32__
''/* Convert a SYSTEMTIME structure (LPSYSTEMTIME: Windows Systems only ) to a Sytm structure */
#macro SYSTEMTIME_TO_SYTM(pSYSTIME, pSYTM)
	 (pSYTM)->tm_hour = (pSYSTIME)->wHour
	 (pSYTM)->tm_min  = (pSYSTIME)->wMinute
	 (pSYTM)->tm_sec  = (pSYSTIME)->wSecond
	 (pSYTM)->tm_mon  = (pSYSTIME)->wMonth - 1
	 (pSYTM)->tm_mday = (pSYSTIME)->wDay
	 (pSYTM)->tm_year = (pSYSTIME)->wYear
	 (pSYTM)->tm_yday = 0
	 (pSYTM)->tm_wday = (pSYSTIME)->wDayOfWeek
	 (pSYTM)->tm_gmtoff = 0
	 (pSYTM)->tm_isdst = -1
	 (pSYTM)->tm_zone = 0
#endmacro
#endif

type SyMemMethods
	xAlloc as sub cdecl(byval as uinteger)
	xRealloc as sub cdecl(byval as any ptr, byval as uinteger)
	xFree as sub cdecl(byval as any ptr)
	xChunkSize as function cdecl(byval as any ptr) as uinteger
	xInit as function cdecl(byval as any ptr) as integer
	xRelease as sub cdecl(byval as any ptr)
	pUserData as any ptr
end type

type ProcMemError as function cdecl(byval as any ptr) as integer

type SyMutexMethods
	xGlobalInit as function cdecl() as integer
	xGlobalRelease as sub cdecl()
	xNew as function cdecl(byval as integer) as SyMutex ptr
	xRelease as sub cdecl(byval as SyMutex ptr)
	xEnter as sub cdecl(byval as SyMutex ptr)
	xTryEnter as function cdecl(byval as SyMutex ptr) as integer
	xLeave as sub cdecl(byval as SyMutex ptr)
end type

#define SXRET_OK 0
#define SXERR_MEM (-1)
#define SXERR_IO (-2)
#define SXERR_EMPTY (-3)
#define SXERR_LOCKED (-4)
#define SXERR_ORANGE (-5)
#define SXERR_NOTFOUND (-6)
#define SXERR_LIMIT (-7)
#define SXERR_MORE (-8)
#define SXERR_INVALID (-9)
#define SXERR_ABORT (-10)
#define SXERR_EXISTS (-11)
#define SXERR_SYNTAX (-12)
#define SXERR_UNKNOWN (-13)
#define SXERR_BUSY (-14)
#define SXERR_OVERFLOW (-15)
#define SXERR_WILLBLOCK (-16)
#define SXERR_NOTIMPLEMENTED (-17)
#define SXERR_EOF (-18)
#define SXERR_PERM (-19)
#define SXERR_NOOP (-20)
#define SXERR_FORMAT (-21)
#define SXERR_NEXT (-22)
#define SXERR_OS (-23)
#define SXERR_CORRUPT (-24)
#define SXERR_CONTINUE (-25)
#define SXERR_NOMATCH (-26)
#define SXERR_RESET (-27)
#define SXERR_DONE (-28)
#define SXERR_SHORT (-29)
#define SXERR_PATH (-30)
#define SXERR_TIMEOUT (-31)
#define SXERR_BIG (-32)
#define SXERR_RETRY (-33)
#define SXERR_IGNORE (-63)

type unqlite_real as double
type unqlite_int64 as sxi64

#define UNQLITE_OK 0
#define UNQLITE_NOMEM (-1)
#define UNQLITE_ABORT (-10)
#define UNQLITE_IOERR (-2)
#define UNQLITE_CORRUPT (-24)
#define UNQLITE_LOCKED (-4)
#define UNQLITE_BUSY (-14)
#define UNQLITE_DONE (-28)
#define UNQLITE_PERM (-19)
#define UNQLITE_NOTIMPLEMENTED (-17)
#define UNQLITE_NOTFOUND (-6)
#define UNQLITE_NOOP (-20)
#define UNQLITE_INVALID (-9)
#define UNQLITE_EOF (-18)
#define UNQLITE_UNKNOWN (-13)
#define UNQLITE_LIMIT (-7)
#define UNQLITE_EXISTS (-11)
#define UNQLITE_EMPTY (-3)
#define UNQLITE_COMPILE_ERR (-70)
#define UNQLITE_VM_ERR (-71)
#define UNQLITE_FULL (-73)
#define UNQLITE_CANTOPEN (-74)
#define UNQLITE_READ_ONLY (-75)
#define UNQLITE_LOCKERR (-76)
#define UNQLITE_CONFIG_JX9_ERR_LOG 1
#define UNQLITE_CONFIG_MAX_PAGE_CACHE 2
#define UNQLITE_CONFIG_ERR_LOG 3
#define UNQLITE_CONFIG_KV_ENGINE 4
#define UNQLITE_CONFIG_DISABLE_AUTO_COMMIT 5
#define UNQLITE_CONFIG_GET_KV_NAME 6
#define UNQLITE_VM_CONFIG_OUTPUT 1
#define UNQLITE_VM_CONFIG_IMPORT_PATH 2
#define UNQLITE_VM_CONFIG_ERR_REPORT 3
#define UNQLITE_VM_CONFIG_RECURSION_DEPTH 4
#define UNQLITE_VM_OUTPUT_LENGTH 5
#define UNQLITE_VM_CONFIG_CREATE_VAR 6
#define UNQLITE_VM_CONFIG_HTTP_REQUEST 7
#define UNQLITE_VM_CONFIG_SERVER_ATTR 8
#define UNQLITE_VM_CONFIG_ENV_ATTR 9
#define UNQLITE_VM_CONFIG_EXEC_VALUE 10
#define UNQLITE_VM_CONFIG_IO_STREAM 11
#define UNQLITE_VM_CONFIG_ARGV_ENTRY 12
#define UNQLITE_VM_CONFIG_EXTRACT_OUTPUT 13
#define UNQLITE_KV_CONFIG_HASH_FUNC 1
#define UNQLITE_KV_CONFIG_CMP_FUNC 2
#define UNQLITE_LIB_CONFIG_USER_MALLOC 1
#define UNQLITE_LIB_CONFIG_MEM_ERR_CALLBACK 2
#define UNQLITE_LIB_CONFIG_USER_MUTEX 3
#define UNQLITE_LIB_CONFIG_THREAD_LEVEL_SINGLE 4
#define UNQLITE_LIB_CONFIG_THREAD_LEVEL_MULTI 5
#define UNQLITE_LIB_CONFIG_VFS 6
#define UNQLITE_LIB_CONFIG_STORAGE_ENGINE 7
#define UNQLITE_LIB_CONFIG_PAGE_SIZE 8
#define UNQLITE_OPEN_READONLY &h00000001
#define UNQLITE_OPEN_READWRITE &h00000002
#define UNQLITE_OPEN_CREATE &h00000004
#define UNQLITE_OPEN_EXCLUSIVE &h00000008
#define UNQLITE_OPEN_TEMP_DB &h00000010
#define UNQLITE_OPEN_NOMUTEX &h00000020
#define UNQLITE_OPEN_OMIT_JOURNALING &h00000040
#define UNQLITE_OPEN_IN_MEMORY &h00000080
#define UNQLITE_OPEN_MMAP &h00000100
#define UNQLITE_SYNC_NORMAL &h00002
#define UNQLITE_SYNC_FULL &h00003
#define UNQLITE_SYNC_DATAONLY &h00010
#define UNQLITE_LOCK_NONE 0
#define UNQLITE_LOCK_SHARED 1
#define UNQLITE_LOCK_RESERVED 2
#define UNQLITE_LOCK_PENDING 3
#define UNQLITE_LOCK_EXCLUSIVE 4

type unqlite_file as unqlite_file_

type unqlite_io_methods
	iVersion as integer
	xClose as function cdecl(byval as unqlite_file ptr) as integer
	xRead as function cdecl(byval as unqlite_file ptr, byval as any ptr, byval as unqlite_int64, byval as unqlite_int64) as integer
	xWrite as function cdecl(byval as unqlite_file ptr, byval as any ptr, byval as unqlite_int64, byval as unqlite_int64) as integer
	xTruncate as function cdecl(byval as unqlite_file ptr, byval as unqlite_int64) as integer
	xSync as function cdecl(byval as unqlite_file ptr, byval as integer) as integer
	xFileSize as function cdecl(byval as unqlite_file ptr, byval as unqlite_int64 ptr) as integer
	xLock as function cdecl(byval as unqlite_file ptr, byval as integer) as integer
	xUnlock as function cdecl(byval as unqlite_file ptr, byval as integer) as integer
	xCheckReservedLock as function cdecl(byval as unqlite_file ptr, byval as integer ptr) as integer
	xSectorSize as function cdecl(byval as unqlite_file ptr) as integer
end type

type unqlite_file_
	pMethods as unqlite_io_methods ptr
end type

type unqlite_vfs
	zName as zstring ptr
	iVersion as integer
	szOsFile as integer
	mxPathname as integer
	xOpen as function cdecl(byval as unqlite_vfs ptr, byval as zstring ptr, byval as unqlite_file ptr, byval as uinteger) as integer
	xDelete as function cdecl(byval as unqlite_vfs ptr, byval as zstring ptr, byval as integer) as integer
	xAccess as function cdecl(byval as unqlite_vfs ptr, byval as zstring ptr, byval as integer, byval as integer ptr) as integer
	xFullPathname as function cdecl(byval as unqlite_vfs ptr, byval as zstring ptr, byval as integer, byval as zstring ptr) as integer
	xTmpDir as function cdecl(byval as unqlite_vfs ptr, byval as zstring ptr, byval as integer) as integer
	xSleep as function cdecl(byval as unqlite_vfs ptr, byval as integer) as integer
	xCurrentTime as function cdecl(byval as unqlite_vfs ptr, byval as Sytm ptr) as integer
	xGetLastError as function cdecl(byval as unqlite_vfs ptr, byval as integer, byval as zstring ptr) as integer
end type

#define UNQLITE_ACCESS_EXISTS 0
#define UNQLITE_ACCESS_READWRITE 1
#define UNQLITE_ACCESS_READ 2

type pgno as sxu64

type unqlite_page
	zData as ubyte ptr
	pUserData as any ptr
	pgno_ as pgno
end type

type unqlite_kv_handle as any ptr

type unqlite_kv_methods as unqlite_kv_methods_

type unqlite_kv_io
	pHandle as unqlite_kv_handle
	pMethods as unqlite_kv_methods ptr
	xGet as function cdecl(byval as unqlite_kv_handle, byval as pgno, byval as unqlite_page ptr ptr) as integer
	xLookup as function cdecl(byval as unqlite_kv_handle, byval as pgno, byval as unqlite_page ptr ptr) as integer
	xNew as function cdecl(byval as unqlite_kv_handle, byval as unqlite_page ptr ptr) as integer
	xWrite as function cdecl(byval as unqlite_page ptr) as integer
	xDontWrite as function cdecl(byval as unqlite_page ptr) as integer
	xDontJournal as function cdecl(byval as unqlite_page ptr) as integer
	xDontMkHot as function cdecl(byval as unqlite_page ptr) as integer
	xPageRef as function cdecl(byval as unqlite_page ptr) as integer
	xPageUnref as function cdecl(byval as unqlite_page ptr) as integer
	xPageSize as function cdecl(byval as unqlite_kv_handle) as integer
	xReadOnly as function cdecl(byval as unqlite_kv_handle) as integer
	xTmpPage as function cdecl(byval as unqlite_kv_handle) as ubyte ptr
	xSetUnpin as sub cdecl(byval as unqlite_kv_handle, byval as sub cdecl(byval as any ptr))
	xSetReload as sub cdecl(byval as unqlite_kv_handle, byval as sub cdecl(byval as any ptr))
	xErr as sub cdecl(byval as unqlite_kv_handle, byval as zstring ptr)
end type

type unqlite_kv_engine
	pIo as unqlite_kv_io ptr
end type

type unqlite_kv_cursor
	pStore as unqlite_kv_engine ptr
end type

#define UNQLITE_CURSOR_MATCH_EXACT 1
#define UNQLITE_CURSOR_MATCH_LE 2
#define UNQLITE_CURSOR_MATCH_GE 3


type unqlite_kv_methods_
	zName as zstring ptr
	szKv as integer
	szCursor as integer
	iVersion as integer
	xInit as function cdecl(byval as unqlite_kv_engine ptr, byval as integer) as integer
	xRelease as sub cdecl(byval as unqlite_kv_engine ptr)
	xConfig as function cdecl(byval as unqlite_kv_engine ptr, byval as integer, byval as va_list) as integer
	xOpen as function cdecl(byval as unqlite_kv_engine ptr, byval as pgno) as integer
	xReplace as function cdecl(byval as unqlite_kv_engine ptr, byval as any ptr, byval as integer, byval as any ptr, byval as unqlite_int64) as integer
	xAppend as function cdecl(byval as unqlite_kv_engine ptr, byval as any ptr, byval as integer, byval as any ptr, byval as unqlite_int64) as integer
	xCursorInit as sub cdecl(byval as unqlite_kv_cursor ptr)
	xSeek as function cdecl(byval as unqlite_kv_cursor ptr, byval as any ptr, byval as integer, byval as integer) as integer
	xFirst as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xLast as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xValid as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xNext as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xPrev as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xDelete as function cdecl(byval as unqlite_kv_cursor ptr) as integer
	xKeyLength as function cdecl(byval as unqlite_kv_cursor ptr, byval as integer ptr) as integer
	xKey as function cdecl(byval as unqlite_kv_cursor ptr, byval as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval as any ptr) as integer
	xDataLength as function cdecl(byval as unqlite_kv_cursor ptr, byval as unqlite_int64 ptr) as integer
	xData as function cdecl(byval as unqlite_kv_cursor ptr, byval as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval as any ptr) as integer
	xReset as sub cdecl(byval as unqlite_kv_cursor ptr)
	xCursorRelease as sub cdecl(byval as unqlite_kv_cursor ptr)
end type

#define UNQLITE_JOURNAL_FILE_SUFFIX "_unqlite_journal"
#define UNQLITE_CTX_ERR 1
#define UNQLITE_CTX_WARNING 2
#define UNQLITE_CTX_NOTICE 3

declare function unqlite_open cdecl alias "unqlite_open" (byval ppDB as unqlite ptr ptr, byval zFilename as zstring ptr, byval iMode as uinteger) as integer
declare function unqlite_config cdecl alias "unqlite_config" (byval pDb as unqlite ptr, byval nOp as integer, ...) as integer
declare function unqlite_close cdecl alias "unqlite_close" (byval pDb as unqlite ptr) as integer
declare function unqlite_kv_store cdecl alias "unqlite_kv_store" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval pData as any ptr, byval nDataLen as unqlite_int64) as integer
declare function unqlite_kv_append cdecl alias "unqlite_kv_append" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval pData as any ptr, byval nDataLen as unqlite_int64) as integer
declare function unqlite_kv_store_fmt cdecl alias "unqlite_kv_store_fmt" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_kv_append_fmt cdecl alias "unqlite_kv_append_fmt" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_kv_fetch cdecl alias "unqlite_kv_fetch" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval pBuf as any ptr, byval pBufLen as unqlite_int64 ptr) as integer
declare function unqlite_kv_fetch_callback cdecl alias "unqlite_kv_fetch_callback" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer, byval xConsumer as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_kv_delete cdecl alias "unqlite_kv_delete" (byval pDb as unqlite ptr, byval pKey as zstring ptr, byval nKeyLen as integer) as integer
declare function unqlite_kv_config cdecl alias "unqlite_kv_config" (byval pDb as unqlite ptr, byval iOp as integer, ...) as integer
declare function unqlite_compile cdecl alias "unqlite_compile" (byval pDb as unqlite ptr, byval zJx9 as zstring ptr, byval nByte as integer, byval ppOut as unqlite_vm ptr ptr) as integer
declare function unqlite_compile_file cdecl alias "unqlite_compile_file" (byval pDb as unqlite ptr, byval zPath as zstring ptr, byval ppOut as unqlite_vm ptr ptr) as integer
declare function unqlite_vm_config cdecl alias "unqlite_vm_config" (byval pVm as unqlite_vm ptr, byval iOp as integer, ...) as integer
declare function unqlite_vm_exec cdecl alias "unqlite_vm_exec" (byval pVm as unqlite_vm ptr) as integer
declare function unqlite_vm_reset cdecl alias "unqlite_vm_reset" (byval pVm as unqlite_vm ptr) as integer
declare function unqlite_vm_release cdecl alias "unqlite_vm_release" (byval pVm as unqlite_vm ptr) as integer
declare function unqlite_vm_dump cdecl alias "unqlite_vm_dump" (byval pVm as unqlite_vm ptr, byval xConsumer as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_vm_extract_variable cdecl alias "unqlite_vm_extract_variable" (byval pVm as unqlite_vm ptr, byval zVarname as zstring ptr) as unqlite_value ptr
declare function unqlite_kv_cursor_init cdecl alias "unqlite_kv_cursor_init" (byval pDb as unqlite ptr, byval ppOut as unqlite_kv_cursor ptr ptr) as integer
declare function unqlite_kv_cursor_release cdecl alias "unqlite_kv_cursor_release" (byval pDb as unqlite ptr, byval pCur as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_seek cdecl alias "unqlite_kv_cursor_seek" (byval pCursor as unqlite_kv_cursor ptr, byval pKey as any ptr, byval nKeyLen as integer, byval iPos as integer) as integer
declare function unqlite_kv_cursor_first_entry cdecl alias "unqlite_kv_cursor_first_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_last_entry cdecl alias "unqlite_kv_cursor_last_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_valid_entry cdecl alias "unqlite_kv_cursor_valid_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_next_entry cdecl alias "unqlite_kv_cursor_next_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_prev_entry cdecl alias "unqlite_kv_cursor_prev_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_key cdecl alias "unqlite_kv_cursor_key" (byval pCursor as unqlite_kv_cursor ptr, byval pBuf as any ptr, byval pnByte as integer ptr) as integer
declare function unqlite_kv_cursor_key_callback cdecl alias "unqlite_kv_cursor_key_callback" (byval pCursor as unqlite_kv_cursor ptr, byval xConsumer as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_kv_cursor_data cdecl alias "unqlite_kv_cursor_data" (byval pCursor as unqlite_kv_cursor ptr, byval pBuf as any ptr, byval pnData as unqlite_int64 ptr) as integer
declare function unqlite_kv_cursor_data_callback cdecl alias "unqlite_kv_cursor_data_callback" (byval pCursor as unqlite_kv_cursor ptr, byval xConsumer as function cdecl(byval as any ptr, byval as uinteger, byval as any ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_kv_cursor_delete_entry cdecl alias "unqlite_kv_cursor_delete_entry" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_kv_cursor_reset cdecl alias "unqlite_kv_cursor_reset" (byval pCursor as unqlite_kv_cursor ptr) as integer
declare function unqlite_begin cdecl alias "unqlite_begin" (byval pDb as unqlite ptr) as integer
declare function unqlite_commit cdecl alias "unqlite_commit" (byval pDb as unqlite ptr) as integer
declare function unqlite_rollback cdecl alias "unqlite_rollback" (byval pDb as unqlite ptr) as integer
declare function unqlite_util_load_mmaped_file cdecl alias "unqlite_util_load_mmaped_file" (byval zFile as zstring ptr, byval ppMap as any ptr ptr, byval pFileSize as unqlite_int64 ptr) as integer
declare function unqlite_util_release_mmaped_file cdecl alias "unqlite_util_release_mmaped_file" (byval pMap as any ptr, byval iFileSize as unqlite_int64) as integer
declare function unqlite_util_random_string cdecl alias "unqlite_util_random_string" (byval pDb as unqlite ptr, byval zBuf as zstring ptr, byval buf_size as uinteger) as integer
declare function unqlite_util_random_num cdecl alias "unqlite_util_random_num" (byval pDb as unqlite ptr) as uinteger
declare function unqlite_create_function cdecl alias "unqlite_create_function" (byval pVm as unqlite_vm ptr, byval zName as zstring ptr, byval xFunc as function cdecl(byval as unqlite_context ptr, byval as integer, byval as unqlite_value ptr ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_delete_function cdecl alias "unqlite_delete_function" (byval pVm as unqlite_vm ptr, byval zName as zstring ptr) as integer
declare function unqlite_create_constant cdecl alias "unqlite_create_constant" (byval pVm as unqlite_vm ptr, byval zName as zstring ptr, byval xExpand as sub cdecl(byval as unqlite_value ptr, byval as any ptr), byval pUserData as any ptr) as integer
declare function unqlite_delete_constant cdecl alias "unqlite_delete_constant" (byval pVm as unqlite_vm ptr, byval zName as zstring ptr) as integer
declare function unqlite_vm_new_scalar cdecl alias "unqlite_vm_new_scalar" (byval pVm as unqlite_vm ptr) as unqlite_value ptr
declare function unqlite_vm_new_array cdecl alias "unqlite_vm_new_array" (byval pVm as unqlite_vm ptr) as unqlite_value ptr
declare function unqlite_vm_release_value cdecl alias "unqlite_vm_release_value" (byval pVm as unqlite_vm ptr, byval pValue as unqlite_value ptr) as integer
declare function unqlite_context_new_scalar cdecl alias "unqlite_context_new_scalar" (byval pCtx as unqlite_context ptr) as unqlite_value ptr
declare function unqlite_context_new_array cdecl alias "unqlite_context_new_array" (byval pCtx as unqlite_context ptr) as unqlite_value ptr
declare sub unqlite_context_release_value cdecl alias "unqlite_context_release_value" (byval pCtx as unqlite_context ptr, byval pValue as unqlite_value ptr)
declare function unqlite_value_int cdecl alias "unqlite_value_int" (byval pVal as unqlite_value ptr, byval iValue as integer) as integer
declare function unqlite_value_int64 cdecl alias "unqlite_value_int64" (byval pVal as unqlite_value ptr, byval iValue as unqlite_int64) as integer
declare function unqlite_value_bool cdecl alias "unqlite_value_bool" (byval pVal as unqlite_value ptr, byval iBool as integer) as integer
declare function unqlite_value_null cdecl alias "unqlite_value_null" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_double cdecl alias "unqlite_value_double" (byval pVal as unqlite_value ptr, byval Value as double) as integer
declare function unqlite_value_string cdecl alias "unqlite_value_string" (byval pVal as unqlite_value ptr, byval zString as zstring ptr, byval nLen as integer) as integer
declare function unqlite_value_string_format cdecl alias "unqlite_value_string_format" (byval pVal as unqlite_value ptr, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_value_reset_string_cursor cdecl alias "unqlite_value_reset_string_cursor" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_resource cdecl alias "unqlite_value_resource" (byval pVal as unqlite_value ptr, byval pUserData as any ptr) as integer
declare function unqlite_value_release cdecl alias "unqlite_value_release" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_to_int cdecl alias "unqlite_value_to_int" (byval pValue as unqlite_value ptr) as integer
declare function unqlite_value_to_bool cdecl alias "unqlite_value_to_bool" (byval pValue as unqlite_value ptr) as integer
declare function unqlite_value_to_int64 cdecl alias "unqlite_value_to_int64" (byval pValue as unqlite_value ptr) as unqlite_int64
declare function unqlite_value_to_double cdecl alias "unqlite_value_to_double" (byval pValue as unqlite_value ptr) as double
declare function unqlite_value_to_string cdecl alias "unqlite_value_to_string" (byval pValue as unqlite_value ptr, byval pLen as integer ptr) as zstring ptr
declare function unqlite_value_to_resource cdecl alias "unqlite_value_to_resource" (byval pValue as unqlite_value ptr) as any ptr
declare function unqlite_value_compare cdecl alias "unqlite_value_compare" (byval pLeft as unqlite_value ptr, byval pRight as unqlite_value ptr, byval bStrict as integer) as integer
declare function unqlite_result_int cdecl alias "unqlite_result_int" (byval pCtx as unqlite_context ptr, byval iValue as integer) as integer
declare function unqlite_result_int64 cdecl alias "unqlite_result_int64" (byval pCtx as unqlite_context ptr, byval iValue as unqlite_int64) as integer
declare function unqlite_result_bool cdecl alias "unqlite_result_bool" (byval pCtx as unqlite_context ptr, byval iBool as integer) as integer
declare function unqlite_result_double cdecl alias "unqlite_result_double" (byval pCtx as unqlite_context ptr, byval Value as double) as integer
declare function unqlite_result_null cdecl alias "unqlite_result_null" (byval pCtx as unqlite_context ptr) as integer
declare function unqlite_result_string cdecl alias "unqlite_result_string" (byval pCtx as unqlite_context ptr, byval zString as zstring ptr, byval nLen as integer) as integer
declare function unqlite_result_string_format cdecl alias "unqlite_result_string_format" (byval pCtx as unqlite_context ptr, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_result_value cdecl alias "unqlite_result_value" (byval pCtx as unqlite_context ptr, byval pValue as unqlite_value ptr) as integer
declare function unqlite_result_resource cdecl alias "unqlite_result_resource" (byval pCtx as unqlite_context ptr, byval pUserData as any ptr) as integer
declare function unqlite_value_is_int cdecl alias "unqlite_value_is_int" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_float cdecl alias "unqlite_value_is_float" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_bool cdecl alias "unqlite_value_is_bool" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_string cdecl alias "unqlite_value_is_string" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_null cdecl alias "unqlite_value_is_null" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_numeric cdecl alias "unqlite_value_is_numeric" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_callable cdecl alias "unqlite_value_is_callable" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_scalar cdecl alias "unqlite_value_is_scalar" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_json_array cdecl alias "unqlite_value_is_json_array" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_json_object cdecl alias "unqlite_value_is_json_object" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_resource cdecl alias "unqlite_value_is_resource" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_value_is_empty cdecl alias "unqlite_value_is_empty" (byval pVal as unqlite_value ptr) as integer
declare function unqlite_array_fetch cdecl alias "unqlite_array_fetch" (byval pArray as unqlite_value ptr, byval zKey as zstring ptr, byval nByte as integer) as unqlite_value ptr
declare function unqlite_array_walk cdecl alias "unqlite_array_walk" (byval pArray as unqlite_value ptr, byval xWalk as function cdecl(byval as unqlite_value ptr, byval as unqlite_value ptr, byval as any ptr) as integer, byval pUserData as any ptr) as integer
declare function unqlite_array_add_elem cdecl alias "unqlite_array_add_elem" (byval pArray as unqlite_value ptr, byval pKey as unqlite_value ptr, byval pValue as unqlite_value ptr) as integer
declare function unqlite_array_add_strkey_elem cdecl alias "unqlite_array_add_strkey_elem" (byval pArray as unqlite_value ptr, byval zKey as zstring ptr, byval pValue as unqlite_value ptr) as integer
declare function unqlite_array_count cdecl alias "unqlite_array_count" (byval pArray as unqlite_value ptr) as integer
declare function unqlite_context_output cdecl alias "unqlite_context_output" (byval pCtx as unqlite_context ptr, byval zString as zstring ptr, byval nLen as integer) as integer
declare function unqlite_context_output_format cdecl alias "unqlite_context_output_format" (byval pCtx as unqlite_context ptr, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_context_throw_error cdecl alias "unqlite_context_throw_error" (byval pCtx as unqlite_context ptr, byval iErr as integer, byval zErr as zstring ptr) as integer
declare function unqlite_context_throw_error_format cdecl alias "unqlite_context_throw_error_format" (byval pCtx as unqlite_context ptr, byval iErr as integer, byval zFormat as zstring ptr, ...) as integer
declare function unqlite_context_random_num cdecl alias "unqlite_context_random_num" (byval pCtx as unqlite_context ptr) as uinteger
declare function unqlite_context_random_string cdecl alias "unqlite_context_random_string" (byval pCtx as unqlite_context ptr, byval zBuf as zstring ptr, byval nBuflen as integer) as integer
declare function unqlite_context_user_data cdecl alias "unqlite_context_user_data" (byval pCtx as unqlite_context ptr) as any ptr
declare function unqlite_context_push_aux_data cdecl alias "unqlite_context_push_aux_data" (byval pCtx as unqlite_context ptr, byval pUserData as any ptr) as integer
declare function unqlite_context_peek_aux_data cdecl alias "unqlite_context_peek_aux_data" (byval pCtx as unqlite_context ptr) as any ptr
declare function unqlite_context_result_buf_length cdecl alias "unqlite_context_result_buf_length" (byval pCtx as unqlite_context ptr) as uinteger
declare function unqlite_function_name cdecl alias "unqlite_function_name" (byval pCtx as unqlite_context ptr) as zstring ptr
declare function unqlite_context_alloc_chunk cdecl alias "unqlite_context_alloc_chunk" (byval pCtx as unqlite_context ptr, byval nByte as uinteger, byval ZeroChunk as integer, byval AutoRelease as integer) as any ptr
declare function unqlite_context_realloc_chunk cdecl alias "unqlite_context_realloc_chunk" (byval pCtx as unqlite_context ptr, byval pChunk as any ptr, byval nByte as uinteger) as any ptr
declare sub unqlite_context_free_chunk cdecl alias "unqlite_context_free_chunk" (byval pCtx as unqlite_context ptr, byval pChunk as any ptr)
declare function unqlite_lib_config cdecl alias "unqlite_lib_config" (byval nConfigOp as integer, ...) as integer
declare function unqlite_lib_init cdecl alias "unqlite_lib_init" () as integer
declare function unqlite_lib_shutdown cdecl alias "unqlite_lib_shutdown" () as integer
declare function unqlite_lib_is_threadsafe cdecl alias "unqlite_lib_is_threadsafe" () as integer
declare function unqlite_lib_version cdecl alias "unqlite_lib_version" () as zstring ptr
declare function unqlite_lib_signature cdecl alias "unqlite_lib_signature" () as zstring ptr
declare function unqlite_lib_ident cdecl alias "unqlite_lib_ident" () as zstring ptr
declare function unqlite_lib_copyright cdecl alias "unqlite_lib_copyright" () as zstring ptr

#endif
