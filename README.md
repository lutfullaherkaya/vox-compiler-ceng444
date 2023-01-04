# LUTO-VOX

Bu, Vox dilinin Risc V derleyicisidir.

Havalı özellikler:
- Vektörler heterojendir.
- Vektör içinde her şey olabilir, vektör bile.
- Standart kütüphanesi vardır.
- Değişkenler dinamik tiplidir.
- Vektörler birbiriyle toplanabilir ve bunu yaparken sadece değerler toplanır, tipler atlanır. bunun için stride komutları var.

Vox Standart Kütüphanesi
- `fun len(v: vector|string) -> int`
- `fun type(v: VoxObject) -> string`
