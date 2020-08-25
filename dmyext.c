extern void Init_bigdecimal();

extern void Init_complex();

extern void Init_Cont();
extern void Init_continuation();
extern void Init_fiber();

extern void Init_cparse();

extern void Init_date_core();

extern void Init_digest();
extern void Init_bubblebabble();
extern void Init_md5();
extern void Init_rmd160();
extern void Init_sha1();
extern void Init_sha2();

extern void Init_etc();

extern void Init_fcntl();

extern void Init_iconv();

extern void Init_rational();

extern void Init_stringio();

extern void Init_strscan();

extern void Init_Thread();

extern void Init_zlib();

void
Init_ext(void)
{
  Init_bigdecimal();

  Init_complex();

  Init_Cont();
  Init_continuation();
  Init_fiber();

  Init_cparse();

  Init_date_core();

  Init_digest();
  Init_bubblebabble();
  Init_md5();
  Init_rmd160();
  Init_sha1();
  Init_sha2();

  Init_etc();

  Init_fcntl();

  Init_iconv();

  Init_rational();

  Init_stringio();

  Init_strscan();

  Init_Thread();

  Init_zlib();
}
