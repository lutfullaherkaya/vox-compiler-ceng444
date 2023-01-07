# LUTO-VOX

Bu, Vox dilinin Risc V derleyicisidir.

Havalı özellikler:
- Vektörler heterojendir.
- Vektör içinde her şey olabilir, vektör bile.
- Standart kütüphanesi vardır.
- Değişkenler dinamik tiplidir.
- Vektörler birbiriyle toplanabilir ve bunu yaparken sadece değerler toplanır, tipler atlanır. bunun için stride komutları var.
- Constant folding yapılarak sabitler derleme zamanında hesaplanır.
- Ölü kodlar atılır. (return sonrası kodlar, if (true), while(false), vs.)

Vox Standart Kütüphanesi
- `fun len(v: vector|string) -> int`
- `fun type(v: VoxObject) -> string`
