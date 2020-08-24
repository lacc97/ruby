extern void Init_bigdecimal();

extern void Init_cparse();

extern void Init_digest();
extern void Init_bubblebabble();
extern void Init_md5();
extern void Init_rmd160();
extern void Init_sha1();
extern void Init_sha2();

extern void Init_etc();

extern void Init_fcntl();

extern void Init_iconv();

extern void Init_stringio();

extern void Init_strscan();

extern void Init_thread();

extern void Init_zlib();

void
Init_ext(void)
{
  Init_bigdecimal();

  Init_cparse();

  Init_digest();
  Init_bubblebabble();
  Init_md5();
  Init_rmd160();
  Init_sha1();
  Init_sha2();

  Init_etc();

  Init_fcntl();

  Init_iconv();

  Init_stringio();

  Init_strscan();

  Init_thread();

  Init_zlib();
}
