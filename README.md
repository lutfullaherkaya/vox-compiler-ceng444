# LUTO-VOX

Bu, Vox dilinin Risc V derleyicisidir.

## Önemli Bağlantılar
[Ceng444 Reposu](https://github.com/cemonem/ceng444)

[ceng444fall2022_recit2](https://github.com/cemonem/ceng444fall2022_recit2)

## Kurulum
### Derleme:
Lex ve Parse işlemlerinde `sly` kullanılır:

```
pip install sly
```

Derlemek için:
```
python3 tester.py compile --save dosya.vox
```
### Assemble etme:
Bunun için spike kullanılır. Spike kurulumu için `riscv-simulation-guides` klasörüne bakabilirsiniz.

```
riscv64-unknown-linux-gnu-gcc -march=rv64gcv -static ornek.vox.s vox_lib.c lib_vox_vector.s -o dosya
```
### Çalıştırma:
```
spike --isa=RV64IMAFDCV $(which pk) dosya
```
### Hata ayıklama
Try running it on QEMU and remote debugging with gdb at the same time from port 1234:

```
qemu-riscv64 -g 1234 -cpu rv64,v=true,zba=true,vlen=128,vext_spec=v1.0 ornek
```

From another terminal:
```
riscv64-unknown-linux-gnu-gdb ornek
(gdb) target remote :1234
(gdb)break *strveccpy
(gdb)continue
(gdb)disas
(gdb)try inspecting some registers here: $sp, $a0, $a1, $v1 ...
(gdb)stepi, and other stuff...
(gdb)quit
```



## Havalı özellikler:
- Değişkenler tamamen dinamik tiplidir.
- Vektörler heterojendir.
- Vektör içinde her şey olabilir, vektör bile.
- Standart kütüphanesi vardır.
- Değişkenler dinamik tiplidir.
- Vektörler birbiriyle toplanabilir ve bunu yaparken sadece değerler toplanır, tipler atlanır. bunun için stride komutları var.
- Constant folding yapılarak sabitler derleme zamanında hesaplanır.
- Ölü kodlar atılır. (return sonrası kodlar, if (true), while(false), vs.)
- Vektörler pass by reference yapar.
- Lokal vektör döndürmek yasaktır.

## Gazoz için yapılanlar:
- Lower amount of temporary variables, better register allocation and lower register spill.
- Functions with more than 7 formal parameters.
- Vectors can hold a mixture of types and other vectors.
- Basic blocklar oluşturulup dag yapıldı, bunun sayesinde blok içi constant folding, constand propogation ve common subexpression elimination yapılıyor. 
- Register allocation yapılmaya çalışıldı basic block bazında.

## Gazoz için zaman yetmeyenler:
- Reals in addition to integers (just like Javascript).
- Garbage collection.
- Runtime errors.
- Cool additional syntactic sugar (like list expressions in Python).
- Fonksiyondan lokal vektör döndürme
- Branch if komutlarında sabit parametre olursa sabit parametre olursa direkt jump yapılabilir 

## Vox Standart Kütüphanesi
- `fun len(v: vector|string) -> int`
- `fun type(v: VoxObject) -> string`


