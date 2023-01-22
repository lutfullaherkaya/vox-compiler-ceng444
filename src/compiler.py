# hizli olmasi icin pypy kullanilabilir
from typing import Dict, Optional, Union, List, Callable, Any, Type, Tuple
import ast_tools
from ast_tools import VarDecl
from abc import ABC, abstractmethod
import misc
from AraDilYapici import AraDilYapiciVisitor
from AraDilYapici import ActivationRecord
from AraDilYapici import NameIdPair, to_tpl, to_name_id
import optimizer
import compiler_utils as cu
import sys

# SORUN: AYNI REGDE BİRDEN COK DEGİSKEN TUTUYORSUN AMA FOR FALAN OLUNCA SIÇIYOR. BASİC BLOCK BİTİNCE AYIRMAN LAZIM REGLERİ

# todo: ÖNEMLİ: hocaya iki farklı sürüm sun. birisi register allocation olmadan, diğeri register allocation ile.
# todo: ÖNEMLİ: allocaiton olmayan sürümde propogation varsa sil.
# todo: ÖNEMLİ: her şeyi test etmen lazım
# todo: currently I allocate stack for all variables and callee saved registers even if I don't actually use it.
"""
ÖNEMLİ: flow grapha falan girme. direkt register problemini çöz sadece.
todo: dag'den geri 3 adress kod donusumu gerekiyor.
http://epgp.inflibnet.ac.in/epgpdata/uploads/epgp_content/S000007CS/P001069/M020249/ET/1495622012Module32_Content_final.pdf

    

 

https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md
    serbest registerler:
    a0-a7 caller saved
    t0-t6 caller-saved: prosedür çağırmadan önce savelenir.
    s1-s11 callee saved: prosedür eğer değiştirecekse saveler.
    
    
    
    vektör implementasyonu
    vektör uzunluğunu vektörün ilk elemanından bir önceki eleman olarak (8 byte, 16 byte değil)
    tutuyorum ki her vector[i] dediğimde i +1 işlemini yapmayayım.
    değişken structuna yazsam olabilirdi, mesela 4 byte type deyip 4 byte vector length diyebilirdim ama demedim. 
    not: vektörler type ve değer çifti tutar, doğal olarak heterojen olurlar.
    
    https://www.geeksforgeeks.org/basic-blocks-in-compiler-design/
    https://www.geeksforgeeks.org/directed-acyclic-graph-in-compiler-design-with-examples/
    https://www.codingninjas.com/codestudio/library/dag-representation
    https://www.javatpoint.com/dag-representation-for-basic-blocks
    Bonus:
    
    After you are done with all of the compulsory steps, you can also implement optional features you'd like Vox to have. 
    These will help you get that Gazozuna Compiler award. Some of them could be:
    - Lower amount of temporary variables, better register allocation and lower register spill.
    - Reals in addition to integers (just like Javascript).
    - Garbage collection.
    - Runtime errors.
    ✓ Functions with more than 7 formal parameters.
    ✓ Vectors can hold a mixture of types and other vectors.
    - Cool additional syntactic sugar (like list expressions in Python).
    
    Yapılabilecek optimizasyonlar:
    constant folding yanında constant propogation:
    https://en.wikipedia.org/wiki/Constant_folding
    özet: değişiklik olmayana kadar bir folding bir propogation yap.
    
    https://en.wikipedia.org/wiki/Optimizing_compiler
    
    todo: 
    remove unused  variables
    hata kontrol visitor açıp şunu ekle: Compilation error: Return statement can only be used inside a function.
    sadece fonksiyon içerisinde değiştirilen registerler savelensin.
    compiler utils compilation error quit yapmamalı, sadece sonunda dosyaya assembly yazılmasını engellemelidir.
    
    vector_set işlemi ve vector_get işlemi grafı bozabilir dikkat et sayfa 538 dragon
    
    parametrelerden ayrıca local değişken yapmama gerek yok, direkt stackte var zaten parametreler (a reglerine sığmayan)
    type checking lazım illa. mesela vektör işlemlerinde vektörlerin tipi sayı olmalı. 
    Optimizasyon belki
    string + işlemi
    vector negatif index, belki pythondaki gibi atlamali seyler
    
    print(a) çalışmıyor
        
    argumanli ilk call tespit edilip argumanlari herhangi register yerine ax'lara yazilabilir. 
    
    __vox ile başlayan fonksiyonlarda globalleri spillemeye gerek yok sonuçta o fonksiyonların global
    kullanmadığını biliyoruz. hatta call ile çağrılan fonksiyon global kullanıyor mu kontrol edilebilir,
    sadece kullandıkları globalleri spilleriz recursive olarak falan ama o kadar ileri gitmeye gerek yok
        
    optimizasyon döngüsü çok uzun sürerse bıraksın onu ayarla. mesela 1 sn sürerse döngüden çıksın.
    reaching definition kullanmadığım için propogation çok verimli olmayabilir.
    
    sabit vektörleri de compile timede propogate et
    vektor[i] leri de compile timede propogate et
    

"""


def get_global_type_name(var_name):
    return f'{var_name}_type'


def get_global_value_name(var_name):
    return f'{var_name}_value'


def get_global_length_name(var_name):
    return f'{var_name}_length'


def get_global_vector_name(var_name):
    return f'{var_name}_vector'


def is_temp(var_name_id: NameIdPair):
    return var_name_id['name'].startswith('.tmp')


class AssemblyYapici(ABC):
    def __init__(self,
                 global_vars: Dict[str, VarDecl],
                 func_activation_records: Dict[str, ActivationRecord],
                 global_string_to_label: Dict[str, str],
                 ara_dil_satirlari: List[List[Any]]):
        self.global_vars: Dict[str, VarDecl] = global_vars
        self.fun_records: Dict[str, ActivationRecord] = func_activation_records
        self.global_string_to_label: Dict[str, str] = global_string_to_label
        self.aradil_sozlugu: Dict[str, Callable[[List[Any], int], List[str]]] = {}
        self.ara_dil_satirlari: List[List[Any]] = ara_dil_satirlari

    def aradilden_asm(self, komut, komut_indeksi=None):
        if komut[0] in self.aradil_sozlugu:
            asm = []
            if komut[0] != 'fun':
                asm.append('            # ' + cu.komut_stringi_yap(komut))
            asm.extend(self.aradil_sozlugu[komut[0]](komut, komut_indeksi))
            return asm
        else:
            return f'ERROR! Unknown IL {komut}'

    @abstractmethod
    def yap(self) -> List[str]:
        pass

    @abstractmethod
    def yap_dag_den(self, fun_dags: Dict[str, List["DAGBlock"]]) -> List[str]:
        pass


class RiscVFunctionInfo:
    def __init__(self, activation_record: ActivationRecord, risc_v_assembly_yapici: "RiscVAssemblyYapici"):
        self.callee_saved_regs: Dict[str, bool] = {}
        self.activation_record: ActivationRecord = activation_record
        self.current_stack_size = activation_record.son_goreli_adres
        self.sp_extra_offset = 0
        self.fp_extra_offset = 0
        self.reg_controller = RiscVRegController(risc_v_assembly_yapici)
        self.calls_another_fun = False  # first pass must set this if fun code contains call

    def get_total_stack_size(self):
        return self.sp_extra_offset + self.fp_extra_offset + self.current_stack_size

    def get_non_reg_arg_count(self):
        return max(self.activation_record.arg_count - 4, 0)

    def add_to_callee_saved_regs(self, regs: Union[str, List[str]]):
        """

        :param regs:registers to be saved when declaring a function and restored when exiting
        :return:
        """
        if isinstance(regs, str):
            regs = [regs]
        for reg in regs:
            if reg not in self.callee_saved_regs:
                self.callee_saved_regs[reg] = True
                self.fp_extra_offset += 8


class RiscVRegPair:
    def __init__(self, type_reg: Optional[str], value_reg: Optional[str], is_spillable=True):
        self.type: Optional[str] = type_reg
        self.val: Optional[str] = value_reg
        self.vars: List[NameIdPair] = []
        self.is_spillable: bool = is_spillable  # for example arg is not spillable


class RiscVRegController:
    def __init__(self, risc_v_assembly_yapici: "RiscVAssemblyYapici"):
        # todo: check if  t0, t1, t2 are used for purposes other than storing vars
        self.callee_saved_regs = ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10', 's11']
        self.callee_saved_regs_used: Dict[str, bool] = {}
        self.caller_saved_regs = ['t3', 't4', 't5', 't6', 'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7']
        self.reg_pairs: List[RiscVRegPair] = []
        self.var_name_id_to_reg: Dict[Tuple[str, int], RiscVRegPair] = {}
        self.risc_v_assembly_yapici: "RiscVAssemblyYapici" = risc_v_assembly_yapici

        self.reset_reg_pairs()

    def reset_reg_pairs(self):
        self.reg_pairs = [  # frees -> least-recently-used -> most-recently-used
            # important: dont mix caller saved and callee saved registers in pairs here.
            # todo: use calle saved registers first
            RiscVRegPair('s1', 's2'),
            RiscVRegPair('s3', 's4'),
            RiscVRegPair('s5', 's6'),
            RiscVRegPair('s7', 's8'),
            RiscVRegPair('s9', 's10'),
            RiscVRegPair('t3', 't4'),
            RiscVRegPair('t5', 't6'),
            RiscVRegPair('a0', 'a1'),
            RiscVRegPair('a2', 'a3'),
            RiscVRegPair('a4', 'a5'),
            RiscVRegPair('a6', 'a7'),
        ]

    def asm_get_free_reg_pair(self, asm_to_extend):
        asm = []
        for reg_pair in self.reg_pairs:
            if not reg_pair.vars and reg_pair.is_spillable:
                self.asm_mark_as_recently_used(reg_pair)
                asm_to_extend.extend(asm)
                return reg_pair

        reg_to_spill = self.get_reg_to_spill()
        self.asm_spill_reg_pair(reg_to_spill, asm)
        self.asm_mark_as_recently_used(reg_to_spill)
        asm_to_extend.extend(asm)
        return reg_to_spill

    def get_reg_with_type(self, reg_type: str):
        for reg_pair in self.reg_pairs:
            if reg_pair.type == reg_type:
                return reg_pair
        return None

    def get_reg_from_var_if_exists(self, var_name_id: NameIdPair):
        var_name_id_tpl = to_tpl(var_name_id)
        if var_name_id_tpl in self.var_name_id_to_reg:
            reg_pair = self.var_name_id_to_reg[var_name_id_tpl]
            self.asm_mark_as_recently_used(reg_pair)
            return reg_pair
        else:
            return None

    def get_reg_to_spill(self):
        """
        :return: decided to just return the least recently used because i use registers with assumption that
        for example for using and on two registers, i can request three registers consecutively and use them
        assuming that they stay at registers. when i request second register, the first register must not be spilled.
        also, if a register has multiple variables, it is more likely that it is more recently used.
        """
        least_var_count = len(self.reg_pairs[0].vars)
        least_var_count_reg_pair = self.reg_pairs[0]
        for reg_pair in self.reg_pairs:
            if reg_pair.is_spillable:
                return reg_pair
        # if len(reg_pair.vars) < least_var_count:
        #     least_var_count = len(reg_pair.vars)
        #     least_var_count_reg_pair = reg_pair
        return least_var_count_reg_pair

    def asm_clear_first_n_args(self, arg_count, asm_to_extend):
        asm = []
        if arg_count < 1:
            arg_count = 1  # always clear return registers a0 and a1
        for i in range(arg_count):
            reg_pair = self.get_reg_with_type(f'a{i * 2}')
            if reg_pair:
                reg_pair.is_spillable = False
        for i in range(arg_count):
            reg_pair = self.get_reg_with_type(f'a{i * 2}')
            if reg_pair:
                if reg_pair.vars:
                    self.asm_move_and_clear_reg_to_new_reg(reg_pair, asm)
        asm_to_extend.extend(asm)

    def asm_clear_nth_arg(self, n, asm_to_extend):
        """
        :param n: 0 indexed
        :param asm_to_extend:
        :return:
        """
        asm = []
        reg_pair = self.get_reg_with_type(f'a{n * 2}')
        if reg_pair:
            reg_pair.is_spillable = False

        reg_pair = self.get_reg_with_type(f'a{n * 2}')
        if reg_pair:
            if reg_pair.vars:
                self.asm_move_and_clear_reg_to_new_reg(reg_pair, asm)
        asm_to_extend.extend(asm)

    def mark_first_n_args_as_spillable(self, arg_count):
        if arg_count < 1:
            arg_count = 1  # always clear return registers a0 and a1
        for i in range(arg_count):
            reg_pair = self.get_reg_with_type(f'a{i * 2}')
            if reg_pair:
                reg_pair.is_spillable = True

    def asm_move_and_clear_reg_to_new_reg(self, reg_pair: RiscVRegPair, asm_to_extend):
        asm = []
        new_reg_pair = self.asm_get_free_reg_pair(asm)
        new_reg_pair.vars.extend(reg_pair.vars)
        reg_pair.vars.clear()
        for var_name_tpl in self.var_name_id_to_reg:
            if self.var_name_id_to_reg[var_name_tpl] == reg_pair:
                self.var_name_id_to_reg[var_name_tpl] = new_reg_pair
        asm.append(
            f'  mv {new_reg_pair.type}, {reg_pair.type}  #backend: clearing {reg_pair.type} for {"return val" if reg_pair.type == "a0" else "arg"}')
        asm.append(
            f'  mv {new_reg_pair.val}, {reg_pair.val}  #backend: clearing {reg_pair.val} for {"return val" if reg_pair.type == "a0" else "arg"}')

        asm_to_extend.extend(asm)

    def asm_spill_reg_pair(self, reg_pair: RiscVRegPair, asm_to_extend):
        asm = []
        for var in reg_pair.vars:
            asm.extend([f'    #backend: spilling {var["name"]}'])
            asm.extend(self.risc_v_assembly_yapici.asm_reg_to_var_in_mem('t0', var, reg_pair.type, reg_pair.val))
            self.var_name_id_to_reg.pop((var['name'], var['id']))
        reg_pair.vars.clear()
        asm_to_extend.extend(asm)

    def asm_spill_non_tmps_at_basic_block_end_without_removing_from_regs(self, asm_to_extend):
        asm = []
        for reg_pair in self.reg_pairs:
            for var in reg_pair.vars:
                if not var['name'].startswith('.tmp'):
                    asm.extend([f'    #backend: spilling {var["name"]} at basic block end'])
                    asm.extend(
                        self.risc_v_assembly_yapici.asm_reg_to_var_in_mem('t0', var, reg_pair.type, reg_pair.val))
        asm_to_extend.extend(asm)

    def clear_regs(self):
        self.reset_reg_pairs()
        self.var_name_id_to_reg = {}

    def asm_mark_as_recently_used(self, reg_pair: RiscVRegPair):
        if reg_pair.type in self.callee_saved_regs:
            self.add_to_used_callee_saveds(reg_pair)
        self.reg_pairs.remove(reg_pair)
        self.reg_pairs.append(reg_pair)

    def mark_as_free(self, reg_pair: RiscVRegPair):
        self.reg_pairs.remove(reg_pair)
        self.reg_pairs.insert(0, reg_pair)

    def remove_var_from_regs(self, var: NameIdPair):
        var_tpl = to_tpl(var)
        if var_tpl in self.var_name_id_to_reg:
            reg_pair = self.var_name_id_to_reg[var_tpl]
            reg_pair.vars.remove(var)
            if not reg_pair.vars:
                self.mark_as_free(reg_pair)

    def asm_spill_all_globals(self, asm_to_extend):
        asm = []
        for reg_pair in self.reg_pairs:
            global_vars = []
            for var in reg_pair.vars:
                if var['id'] == -1:
                    global_vars.append(var)
            for var in global_vars:
                asm.append(f'  la t0, {get_global_type_name(var["name"])}  #backend: global spill')
                asm.append(f'  sd {reg_pair.type}, (t0)')
                asm.append(f'  sd {reg_pair.val}, 8(t0)')
                reg_pair.vars.remove(var)
                self.var_name_id_to_reg.pop(to_tpl(var))

            if not reg_pair.vars:
                self.mark_as_free(reg_pair)

        asm_to_extend.extend(asm)

    def add_to_used_callee_saveds(self, reg_pair):
        for reg in [reg_pair.type, reg_pair.val]:
            if reg not in self.callee_saved_regs_used:
                self.callee_saved_regs_used[reg] = True


class RiscVAssemblyYapici(AssemblyYapici):
    def __init__(self,
                 global_vars: Dict[str, VarDecl],
                 func_activation_records: Dict[str, ActivationRecord],
                 global_string_to_label: Dict[str, str],
                 ara_dil_satirlari: List[List[Any]]):
        super().__init__(global_vars, func_activation_records, global_string_to_label, ara_dil_satirlari)
        self.fun_infos: Dict[str, RiscVFunctionInfo] = {fun_name: RiscVFunctionInfo(self.fun_records[fun_name], self)
                                                        for fun_name in self.fun_records}
        self.current_fun_label = ''
        self.current_fun_komut_index = -1
        self.current_arg_index = -1
        self.current_param_index = -1
        self.current_dag_block: Optional["DAGBlock"] = None
        self.calculated_used_callee_saveds: List[str] = []
        self.aradil_sozlugu = {
            'fun': self.cevir_fun,
            'return': self.cevir_return,
            'call': self.cevir_call,
            'copy': self.cevir_copy,
            'arg': self.cevir_arg,
            'vector': self.cevir_vector,
            'vector_set': self.cevir_vector_set,
            'vector_get': self.cevir_vector_get,
            'global': self.cevir_global,
            'branch': self.cevir_branch,
            'branch_if_true': self.cevir_branch_if_true,
            'branch_if_false': self.cevir_branch_if_false,
            'label': self.cevir_label,
            'param': self.cevir_param,
            'and': self.ceviriler_mantiksal,
            'or': self.ceviriler_mantiksal,
            'add': self.ceviriler_aritmetik,
            'sub': self.ceviriler_aritmetik,
            'mul': self.ceviriler_aritmetik,
            'div': self.ceviriler_aritmetik,
            '!': self.ceviriler_mantiksal,
            '<': self.ceviriler_karsilastirma,
            '>': self.ceviriler_karsilastirma,
            '<=': self.ceviriler_karsilastirma,
            '>=': self.ceviriler_karsilastirma,
            '==': self.ceviriler_karsilastirma,
            '!=': self.ceviriler_karsilastirma,
        }
        self.tip_rakamlari: Dict[str, int] = {
            'int': 0,
            'vector': 1,
            'bool': 2,
            'string': 3,
        }

    def yap_dag_den(self, fun_dags: Dict[str, List["DAGBlock"]]) -> List[str]:
        asm = []
        asm.extend(self.get_on_soz())
        for fun_name, dags in fun_dags.items():
            fun_asm = []
            self.calculated_used_callee_saveds = self.calculate_used_callee_saved_registers_and_if_calls_another_fun(
                fun_name, dags)

            for dag_block in dags:
                self.current_dag_block = dag_block
                for i, komut in enumerate(dag_block.selef_komutlar):
                    fun_asm.extend(self.aradilden_asm(komut, i))
                for i, komut in enumerate(dag_block.dag_komutlari):
                    fun_asm.extend(self.aradilden_asm(komut, i))

                if not (len(dag_block.halef_komutlar) == 1 and dag_block.halef_komutlar[0][0] == 'return'):
                    # no need to save local variables when returning
                    # cevir_return spills globals, so we don't need to spill them here anyway
                    self.get_current_fun_reg_controller().asm_spill_non_tmps_at_basic_block_end_without_removing_from_regs(
                        fun_asm)
                for i, komut in enumerate(dag_block.halef_komutlar):
                    fun_asm.extend(self.aradilden_asm(komut, i))
                self.get_current_fun_reg_controller().clear_regs()

            asm.extend(fun_asm)
        self.init_global_labels(asm)
        return asm

    def calculate_used_callee_saved_registers_and_if_calls_another_fun(self, fun_name: str, dags: List["DAGBlock"]):
        # to find out which registers are used, we need to actually compile first and thrash it
        for dag_block in dags:
            self.current_dag_block = dag_block
            for i, komut in enumerate(dag_block.selef_komutlar):
                self.aradilden_asm(komut, i)
            for i, komut in enumerate(dag_block.dag_komutlari):
                self.aradilden_asm(komut, i)
            for i, komut in enumerate(dag_block.halef_komutlar):
                self.aradilden_asm(komut, i)
        regs = self.get_current_fun_reg_controller().callee_saved_regs_used.keys()
        calls_another_fun = self.fun_infos[self.current_fun_label].calls_another_fun
        self.fun_infos[fun_name] = RiscVFunctionInfo(self.fun_records[fun_name], self)
        self.fun_infos[fun_name].calls_another_fun = calls_another_fun
        return regs

    def get_current_fun_reg_controller(self):
        return self.fun_infos[self.current_fun_label].reg_controller

    def yap(self):
        assembly_lines = []
        assembly_lines.extend(self.get_on_soz())

        for i, komut in enumerate(self.ara_dil_satirlari):
            assembly_lines.extend(self.aradilden_asm(komut, i))

        self.init_global_labels(assembly_lines)

        return assembly_lines

    def init_global_labels(self, asm_to_extend):
        if len(self.global_vars) > 0 or len(self.global_string_to_label):
            asm_to_extend.extend(['',
                                  '  .data'])
        for name, vardecl in self.global_vars.items():
            if vardecl.initializer is not None:
                if type(vardecl.initializer) == list:
                    global_vector_name = get_global_vector_name(name)
                    asm_to_extend.extend([f'{get_global_type_name(name)}:    .quad {self.tip_rakamlari["vector"]}',
                                          f'{get_global_value_name(name)}:   .quad {global_vector_name}',
                                          f'{get_global_length_name(name)}:  .quad {len(vardecl.initializer)}',
                                          f'{global_vector_name}:'])
                    for i in range(len(vardecl.initializer)):
                        asm_to_extend.append('  .quad 0, 0')
                    asm_to_extend.append('')
                elif isinstance(vardecl.initializer, ast_tools.ALiteral):
                    asm_to_extend.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
                                          f'{get_global_value_name(name)}:  .quad {int(vardecl.initializer.value)}',
                                          f''])
                elif isinstance(vardecl.initializer, ast_tools.SLiteral):
                    asm_to_extend.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["string"]}',
                                          f'{get_global_value_name(name)}:  .quad {self.global_string_to_label[vardecl.initializer.value]}',
                                          f''])
                elif isinstance(vardecl.initializer, ast_tools.LLiteral):
                    asm_to_extend.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["bool"]}',
                                          f'{get_global_value_name(name)}:  .quad {int(vardecl.initializer.value)}',
                                          f''])
                else:
                    asm_to_extend.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
                                          f'{get_global_value_name(name)}:  .quad 0',
                                          f''])
            else:
                asm_to_extend.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
                                      f'{get_global_value_name(name)}:  .quad 0',
                                      f''])

        for string_value, string_label in self.global_string_to_label.items():
            # .ascii does not add a null terminator, thus use .string
            asm_to_extend.append(f'{string_label}:  .string "{string_value}"')

    def get_on_soz(self):
        on_soz = [f'#include "vox_lib.h"',
                  f'  ',
                  f'  .global main',
                  f'  .text',
                  f'  .align 2']
        return on_soz

    def get_reg(self, var_name_id: Union[NameIdPair, int, bool, str], asm_to_extend, load_if_on_memory=True):
        asm = []
        if type(var_name_id) in [int, bool, str]:
            # todo: add support for literal value registers and check if same literal exists here
            reg_pair = self.get_current_fun_reg_controller().asm_get_free_reg_pair(asm)
            asm.extend(self.asm_var_in_mem_or_const_to_reg(var_name_id, reg_pair.type, reg_pair.val))
        elif type(var_name_id) == dict:
            reg_pair = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(var_name_id)
            if not reg_pair:
                reg_pair = self.get_current_fun_reg_controller().asm_get_free_reg_pair(asm)

                if var_name_id not in reg_pair.vars:
                    reg_pair.vars.append(var_name_id)
                self.get_current_fun_reg_controller().var_name_id_to_reg[to_tpl(var_name_id)] = reg_pair

                if load_if_on_memory:
                    asm.extend(self.asm_var_in_mem_or_const_to_reg(var_name_id, reg_pair.type, reg_pair.val))

        asm_to_extend.extend(asm)
        return reg_pair

    def asm_var_or_const_to_reg(self, var_name_id: Union[NameIdPair, int, bool, str], reg_pair: RiscVRegPair):
        """
            get_reg ile çok benziyor
            if var in memory: load directly into reg
            if var in reg: just mv reg_pair, var_reg
        """
        asm = []
        if type(var_name_id) in [int, bool, str]:
            asm.extend(self.asm_var_in_mem_or_const_to_reg(var_name_id, reg_pair.type, reg_pair.val))
        elif type(var_name_id) == dict:
            var_reg_pair = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(var_name_id)
            if var_reg_pair:
                self.asm_reg_to_reg(reg_pair, var_reg_pair, asm)
            else:
                # todo: maybe add to register first
                asm.extend(self.asm_var_in_mem_or_const_to_reg(var_name_id, reg_pair.type, reg_pair.val))

        return asm

    def asm_reg_to_var(self, var_name_id: NameIdPair, reg_pair: RiscVRegPair):
        asm = []
        var_reg_pair = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(var_name_id)
        if var_reg_pair:
            self.asm_reg_to_reg(var_reg_pair, reg_pair, asm)
        else:
            asm.extend(self.asm_reg_to_var_in_mem('t0', var_name_id, reg_pair.type, reg_pair.val))

        return asm

    @staticmethod
    def asm_reg_to_reg(lvalue: RiscVRegPair, rvalue: RiscVRegPair, asm_to_extend):
        if lvalue.type is not None and rvalue.type is not None and lvalue.type != rvalue.type:
            asm_to_extend.append(f'  mv {lvalue.type}, {rvalue.type}')
        if lvalue.val is not None and rvalue.val is not None and lvalue.val != rvalue.val:
            asm_to_extend.append(f'  mv {lvalue.val}, {rvalue.val}')

    def asm_var_in_mem_or_const_to_reg(self, var_name_id, type_reg=None, value_reg=None):
        # asm = [f'      # asm_var_to_reg(var:{var_name}, type_reg:{type_reg}, value_reg:{value_reg})']
        asm = []
        if type(var_name_id) == int:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["int"]}')
            if value_reg is not None:
                asm.append(f'  li {value_reg}, {var_name_id}')
        elif type(var_name_id) == bool:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["bool"]}')
            if value_reg is not None:
                asm.append(f'  li {value_reg}, {int(var_name_id)}')
        elif type(var_name_id) == str:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["string"]}')
            if value_reg is not None:
                asm.append(f'  la {value_reg}, {self.global_string_to_label[var_name_id]}')
        else:
            type_addr = self._type_addr(var_name_id)
            value_addr = self._value_addr(var_name_id)
            if type_addr is not None:  # local
                if type_reg is not None:
                    asm.append(f'  ld {type_reg}, {type_addr}')
                if value_reg is not None:
                    asm.append(f'  ld {value_reg}, {value_addr}')
            elif var_name_id["name"] in self.global_vars:
                if type_reg is not None:
                    asm.append(f'  ld {type_reg}, {get_global_type_name(var_name_id["name"])}')
                if value_reg is not None:
                    asm.append(f'  ld {value_reg}, {get_global_value_name(var_name_id["name"])}')
            else:
                cu.compilation_error(f'Unknown variable {var_name_id["name"]}')
        return asm

    def asm_reg_to_var_in_mem(self, temp_reg, var_name_id, type_reg=None, value_reg=None):
        """
        :param temp_reg: only used for storing to global variables
        """
        # asm = [f'      # asm_reg_to_var(tmp:{temp_reg}, var:{var_name}, type_reg:{type_reg}, value_reg:{value_reg})']
        asm = []
        type_addr = self._type_addr(var_name_id)
        value_addr = self._value_addr(var_name_id)
        if type_addr is not None:  # local
            if type_reg is not None:
                asm.append(f'  sd {type_reg}, {type_addr}')
            if value_reg is not None:
                asm.append(f'  sd {value_reg}, {value_addr}')
        elif var_name_id["name"] in self.global_vars:
            asm.append(f'  la {temp_reg}, {get_global_type_name(var_name_id["name"])}')
            if type_reg is not None:
                asm.append(f'  sd {type_reg}, ({temp_reg})')
            if value_reg is not None:
                asm.append(f'  sd {value_reg}, 8({temp_reg})')
        else:
            cu.compilation_error(f'Unknown variable {var_name_id["name"]}')
        return asm

    def asm_get_vector_elm_addr(self, tmp_reg, addr_reg, vector_name_id, index):
        """

        :param tmp_reg: can't be same as addr_reg
        :param addr_reg:
        :param vector_name_id:
        :param index:
        :return:
        """
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(vector_name_id, RiscVRegPair(None, addr_reg)))
        if type(index) == int:
            if index > 0:
                asm.extend([f'  addi {addr_reg}, {addr_reg}, {index * 16}'])
        else:
            asm.extend(self.asm_var_in_mem_or_const_to_reg(index, None, tmp_reg))
            asm.extend([f'  slli {tmp_reg}, {tmp_reg}, 4',
                        f'  add {addr_reg}, {addr_reg}, {tmp_reg}'])
        return asm

    def cevir_arg(self, komut, komut_indeksi=None):
        arg_name_id = komut[1]
        asm = []
        old_arg_reg = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(arg_name_id)
        arg_was_on_a0_and_is_first_arg = False
        if old_arg_reg and old_arg_reg.type == 'a0' and self.current_arg_index == -1:
            arg_was_on_a0_and_is_first_arg = True

        if self.current_arg_index == -1:  # first arg
            arg_count = 1
            if self.current_dag_block is not None:
                while self.current_dag_block.dag_komutlari[komut_indeksi + arg_count][0] != 'call':
                    arg_count += 1
            else:
                while self.ara_dil_satirlari[komut_indeksi + arg_count][0] != 'call':
                    arg_count += 1
            self.get_current_fun_reg_controller().asm_clear_nth_arg(0, asm)

            non_reg_arg_cnt = max(arg_count - 4, 0)
            if non_reg_arg_cnt > 0:
                self.fun_infos[self.current_fun_label].sp_extra_offset += 16 * non_reg_arg_cnt
                asm.append(f'  addi sp, sp, -{16 * non_reg_arg_cnt}')

        self.current_arg_index += 1
        if self.current_arg_index == 0:
            if arg_was_on_a0_and_is_first_arg:
                pass
            else:
                # already saved because a0 is return register
                asm.extend(self.asm_var_or_const_to_reg(arg_name_id, RiscVRegPair(
                    f'a{2 * self.current_arg_index}', f'a{2 * self.current_arg_index + 1}')))
        elif self.current_arg_index <= 3:
            arg_reg = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(arg_name_id)
            if arg_reg and arg_reg.type == f'a{self.current_arg_index * 2}':
                # arg already in correct arg reg. even if it is a0, a0 is moved to another reg but a0 value is also in a0
                pass
            else:
                self.get_current_fun_reg_controller().asm_clear_nth_arg(self.current_arg_index, asm)
                asm.extend(self.asm_var_or_const_to_reg(arg_name_id, RiscVRegPair(
                    f'a{2 * self.current_arg_index}', f'a{2 * self.current_arg_index + 1}')))
        else:
            non_reg_index = self.current_arg_index - 4
            arg_reg = self.get_reg(arg_name_id, asm)
            asm.extend([f'  sd {arg_reg.type}, {16 * non_reg_index}(sp)',
                        f'  sd {arg_reg.val}, {16 * non_reg_index + 8}(sp)'])
        return asm

    def cevir_call(self, komut, komut_indeksi=None):
        asm = []

        self.get_current_fun_reg_controller().asm_spill_all_globals(asm)
        non_free_reg_pairs = filter(lambda pair: len(pair.vars) > 0, self.get_current_fun_reg_controller().reg_pairs)
        caller_saved_non_free_var_regs = []
        for reg_pair in non_free_reg_pairs:
            if reg_pair.type in self.get_current_fun_reg_controller().caller_saved_regs:
                caller_saved_non_free_var_regs.append(reg_pair.type)
                caller_saved_non_free_var_regs.append(reg_pair.val)

        caller_saved_size = len(caller_saved_non_free_var_regs) * 8
        if caller_saved_size > 0:
            self.fun_infos[self.current_fun_label].sp_extra_offset += caller_saved_size
            asm.append(f'    #backend: saving caller saved regs')
            asm.append(f'  addi sp, sp, -{caller_saved_size}')
            for i, reg in enumerate(caller_saved_non_free_var_regs):
                asm.append(f'  sd {reg}, {8 * i}(sp)')

        ret_val_name_id = komut[1]
        func_name = komut[2]
        arg_count = self.current_arg_index + 1
        non_reg_arg_count = max(arg_count - 4, 0)
        self.current_arg_index = -1
        asm.extend([f'  call {func_name}'])
        self.fun_infos[self.current_fun_label].calls_another_fun = True

        if non_reg_arg_count > 0 or caller_saved_size > 0:
            for i, reg in enumerate(caller_saved_non_free_var_regs):
                asm.append(f'  ld {reg}, {8 * i}(sp)')
            asm.append(f'  addi sp, sp, {16 * non_reg_arg_count + caller_saved_size}')
            self.fun_infos[self.current_fun_label].sp_extra_offset -= 16 * non_reg_arg_count + caller_saved_size

        if ret_val_name_id is not None:
            return_reg = self.get_current_fun_reg_controller().get_reg_with_type('a0')
            return_reg.vars.append(ret_val_name_id)
            self.get_current_fun_reg_controller().var_name_id_to_reg[to_tpl(ret_val_name_id)] = return_reg

        self.get_current_fun_reg_controller().mark_first_n_args_as_spillable(arg_count)
        return asm

    def cevir_copy(self, komut, komut_indeksi=None):
        """
        komut[1] = komut[2]
        """
        asm = []

        komut1_reg = self.get_reg(komut[1], asm, False)
        if type(komut[2]) in [int, bool, str, float]:
            asm.extend(self.asm_var_in_mem_or_const_to_reg(komut[2], komut1_reg.type, komut1_reg.val))
        else:
            komut2_reg = self.get_reg(komut[2], asm)
            self.asm_reg_to_reg(komut1_reg, komut2_reg, asm)

        return asm

    def cevir_vector(self, komut, komut_indeksi=None):
        name_id = komut[1]
        length = komut[2]
        type_addr = self._type_addr(name_id)
        asm = []
        if type_addr is not None:  # local
            length_addr = self._length_addr(name_id)
            i_first_elm = self._vector_first_elm_sp_index(name_id)
            reg = self.get_reg(name_id, asm)
            asm.extend([f'  li {reg.type}, {self.tip_rakamlari["vector"]}',
                        f'  add {reg.val}, sp, {i_first_elm}'])
            asm.extend([f'  li t0, {length}',
                        f'  sd t0, {length_addr}'])
        elif name_id["name"] in self.global_vars:
            pass
        else:
            # impossible if undeclared variable check is done before
            cu.compilation_error(f'Unknown variable {name_id["name"]}')

        return asm

    def cevir_vector_set(self, komut, komut_indeksi=None):
        vector_name_id = komut[1]
        index = komut[2]
        expr_name_id = komut[3]
        asm = []
        asm.extend(self.asm_get_vector_elm_addr('t0', 't1', vector_name_id, index))
        expr_reg = self.get_reg(expr_name_id, asm)
        asm.extend([f'  sd {expr_reg.type}, 0(t1)',
                    f'  sd {expr_reg.val}, 8(t1)'])
        return asm

    def cevir_vector_get(self, komut, komut_indeksi=None):
        result_name_id = komut[1]
        vector_name_id = komut[2]
        index = komut[3]
        asm = []
        asm.extend(self.asm_get_vector_elm_addr('t0', 't1', vector_name_id, index))
        result_reg = self.get_reg(result_name_id, asm)
        asm.extend([f'  ld {result_reg.type}, 0(t1)',
                    f'  ld {result_reg.val}, 8(t1)'])
        return asm

    def cevir_global(self, komut, komut_indeksi=None):
        # Compiler sınıfı oluşturur globalleri
        return []

    def cevir_branch(self, komut, komut_indeksi=None):
        return [f'  j {komut[1]}']

    def cevir_label(self, komut, komut_indeksi=None):
        return [f'{komut[1]}:']

    def cevir_fun(self, komut, komut_indeksi=None):
        label = komut[1]
        signature = komut[2]
        param_count = komut[3]

        self.current_fun_label = label
        if self.fun_infos[self.current_fun_label].calls_another_fun:
            self.fun_infos[self.current_fun_label].add_to_callee_saved_regs(['ra'])
            self.fun_infos[self.current_fun_label].add_to_callee_saved_regs(self.calculated_used_callee_saveds)

        total_stack_size = self.get_ttl_stack_size()
        asm = [f'',
               f'# fun {signature};',
               f'{label}:']
        if total_stack_size > 0:
            asm.append(f'  addi sp, sp, -{total_stack_size}')

        for i, reg_to_save in enumerate(self.fun_infos[self.current_fun_label].callee_saved_regs):
            asm.append(f'  sd {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')

        return asm

    def cevir_param(self, komut, komut_indeksi=None):
        param_name_id = komut[1]
        self.current_param_index += 1
        asm = []
        if self.current_param_index <= 3:
            type_reg = f'a{2 * self.current_param_index}'
            param_reg = self.get_current_fun_reg_controller().get_reg_with_type(type_reg)
            param_reg.vars.append(param_name_id)
            param_reg.is_spillable = False
            self.get_current_fun_reg_controller().var_name_id_to_reg[to_tpl(param_name_id)] = param_reg

        else:
            param_reg = self.get_reg(param_name_id, asm, False)
            total_stack_size = self.get_ttl_stack_size()
            non_reg_index = self.current_param_index - 4
            self.get_current_fun_reg_controller().asm_mark_as_recently_used(param_reg)
            asm.extend([f'  ld {param_reg.type}, {16 * non_reg_index + total_stack_size}(sp)',
                        f'  ld {param_reg.val}, {16 * non_reg_index + 8 + total_stack_size}(sp)'])
        if self.current_param_index == self.fun_infos[self.current_fun_label].activation_record.arg_count - 1:
            self.current_param_index = -1
        return asm

    def cevir_return(self, komut, komut_indeksi=None):
        asm = []

        if len(komut) >= 2:
            asm.extend(self.asm_var_or_const_to_reg(komut[1], RiscVRegPair('a0', 'a1')))

        self.get_current_fun_reg_controller().asm_spill_all_globals(asm)

        total_stack_size = self.get_ttl_stack_size()

        for i, reg_to_save in enumerate(self.fun_infos[self.current_fun_label].callee_saved_regs):
            asm.append(f'  ld {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')
        if total_stack_size > 0:
            asm.extend([f'  addi sp, sp, {total_stack_size}'])
        if self.current_fun_label == 'main':
            asm.append('  li a0, 0')
        asm.append(f'  ret')
        return asm

    def cevir_branch_if_true(self, komut, komut_indeksi=None):
        asm = []
        reg_pair = self.get_reg(komut[1], asm)
        # todo: if komut[1] is immediate, add seperate instruction.
        asm.extend([f'  bne {reg_pair.val}, zero, {komut[2]}'])
        return asm

    def cevir_branch_if_false(self, komut, komut_indeksi=None):
        asm = []
        reg_pair = self.get_reg(komut[1], asm)
        # todo: if komut[1] is immediate, add seperate instruction.
        asm.extend([f'  beq {reg_pair.val}, zero, {komut[2]}'])
        return asm

    def ceviriler_mantiksal(self, komut, komut_indeksi=None):
        # assuming type is 3 (bool)
        asm = []
        result_name = komut[1]
        op0_name = komut[2]

        self.get_current_fun_reg_controller().remove_var_from_regs(result_name)
        op0_reg = self.get_reg(op0_name, asm)
        result_reg = self.get_reg(result_name, asm, False)

        asm.extend([f'  li {result_reg.type}, {self.tip_rakamlari["bool"]}'])

        if komut[0] in ['and', 'or']:
            op1_name = komut[3]
            op1_reg = self.get_reg(op1_name, asm)
            asm.extend([f'  {komut[0]} {result_reg.val}, {op0_reg.val}, {op1_reg.val}'])
        elif komut[0] == '!':
            asm.extend([f'  xori {result_reg.val}, {op0_reg.val}, 1'])

        return asm

    def ceviriler_aritmetik(self, komut, komut_indeksi=None):

        asm = []
        op0_name = komut[2]
        op1_name = komut[3]
        result_name = komut[1]

        self.get_current_fun_reg_controller().remove_var_from_regs(result_name)

        op0_reg = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(op0_name)
        op1_reg = self.get_current_fun_reg_controller().get_reg_from_var_if_exists(op1_name)

        if op1_reg and op1_reg.type == 'a2':
            # first arg is always cleared since it is the return reg
            self.get_current_fun_reg_controller().asm_clear_first_n_args(1, asm)
        else:
            self.get_current_fun_reg_controller().asm_clear_first_n_args(2, asm)

        if not (op0_reg and op0_reg.type == 'a0'):
            # op0 is saved to another reg from a0 but it is still also in a0
            asm.extend(self.asm_var_or_const_to_reg(op0_name, RiscVRegPair('a0', 'a1')))

        asm.extend(self.asm_var_or_const_to_reg(op1_name, RiscVRegPair('a2', 'a3')))
        asm.extend([f'  call __vox_{komut[0]}__'])
        self.fun_infos[self.current_fun_label].calls_another_fun = True
        result_reg = self.get_current_fun_reg_controller().get_reg_with_type('a0')
        result_reg.vars.append(result_name)
        self.get_current_fun_reg_controller().var_name_id_to_reg[to_tpl(result_name)] = result_reg
        self.get_current_fun_reg_controller().mark_first_n_args_as_spillable(2)
        return asm

    def ceviriler_karsilastirma(self, komut, komut_indeksi=None):
        if komut[0] == '>':
            return self.ceviriler_karsilastirma(['<', komut[1], komut[3], komut[2]])
        elif komut[0] == '>=':
            return self.ceviriler_karsilastirma(['<=', komut[1], komut[3], komut[2]])
        asm = []

        # assuming type is 0 (int)
        op0_name = komut[2]
        op1_name = komut[3]
        result_name = komut[1]

        self.get_current_fun_reg_controller().remove_var_from_regs(result_name)

        op0_reg = self.get_reg(op0_name, asm)
        op1_reg = self.get_reg(op1_name, asm)
        result_reg = self.get_reg(result_name, asm, False)

        asm.extend([f'  li {result_reg.type}, {self.tip_rakamlari["bool"]}'])

        if komut[0] == '<':
            asm.extend([f'  slt {result_reg.val}, {op0_reg.val}, {op1_reg.val}'])
        elif komut[0] == '<=':
            asm.extend([f'  slt {result_reg.val}, {op0_reg.val}, {op1_reg.val}',
                        f'  sub t0, {op0_reg.val}, {op1_reg.val}',
                        f'  seqz t0, t0',
                        f'  or {result_reg.val}, {result_reg.val}, t0'])
        elif komut[0] in ['==', '!=']:
            asm.extend([f'  sub t0, {op0_reg.val}, {op1_reg.val}',
                        f'  {"seqz" if komut[0] == "==" else "snez"} {result_reg.val}, t0'])

        return asm

    def _type_addr(self, place: NameIdPair):
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key]) + '(sp)'
        else:
            return None

    def _value_addr(self, place: NameIdPair):
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 8) + '(sp)'
        else:
            return None

    def _length_addr(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 16) + '(sp)'
        else:
            return None

    def _vector_first_elm_sp_index(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 24
        else:
            return None

    def get_ttl_stack_size(self):
        return self.fun_infos[self.current_fun_label].get_total_stack_size()


class BasicBlock:
    def __init__(self, global_vars: Dict[str, VarDecl]):
        self.komutlar: List[List[Any]] = []
        self.global_vars: Dict[str, VarDecl] = global_vars

    def add(self, komut):
        self.komutlar.append(komut)


class DAGNode:
    def __init__(self, label=None, identifiers=None, left: "DAGNode" = None, right: "DAGNode" = None,
                 third: "DAGNode" = None, killed=False):
        self.label = label
        self.killed = killed
        if identifiers is None:
            self.identifiers = []
        else:
            self.identifiers = identifiers
        self.left: Optional[DAGNode] = left
        self.right: Optional[DAGNode] = right
        self.third: Optional[DAGNode] = third


class DAGBlock:
    def __init__(self, block: BasicBlock):
        self.block: BasicBlock = block
        self.selef_komutlar = []
        self.dag_komutlari = []
        self.halef_komutlar = []

        self.binary_ops = ['add', 'sub', 'mul', 'div', 'and', 'or', '<', '>', '<=', '>=', '==', '!=', 'vector_get']
        self.unary_ops = ['!']

        self.nodes: List[DAGNode] = []
        self.var_to_node: Dict[Union[Tuple[str, int], str, int, bool, float], DAGNode] = {}  # call

        self.create_dag_graph()

    def kill_nodes_dependent_on(self, x):
        if x is not None:
            for node in self.nodes:
                if x in [node.left, node.right, node.third]:
                    node.killed = True

    def mark_globals_as_changed_and_kill_dependent(self):
        global_var_node_tpls = []
        for global_var in self.block.global_vars.values():
            tpl = (global_var.identifier.name, -1)
            if tpl in self.var_to_node:
                global_var_node_tpls.append(tpl)
        for tpl in global_var_node_tpls:
            node = self.var_to_node[tpl]
            self.kill_nodes_dependent_on(node)
            # node.identifiers.remove(tpl) # dont delete because other vars can be dependent on it
            self.var_to_node[tpl] = DAGNode(identifiers=[tpl])

    def create_dag_graph(self):
        # special case: call. globals should be saved before call and after call they can get modified.
        # the reason of not putting call in new block is for being able to remove temps after end of block
        # and not have to deal with inter block temps.
        for komut in self.block.komutlar:
            if komut[0] in ['fun', 'param', 'label']:
                self.selef_komutlar.append(komut)
            elif komut[0] in ['branch_if_true', 'branch_if_false', 'branch', 'return']:
                self.halef_komutlar.append(komut)
            if komut[0] in self.binary_ops + self.unary_ops + ['copy']:  # x = y op z
                x = to_tpl(komut[1])
                y = to_tpl(komut[2])
                n = None
                if y not in self.var_to_node:
                    self.var_to_node[y] = DAGNode(identifiers=[y])
                    self.nodes.append(self.var_to_node[y])

                if komut[0] in self.binary_ops:  # case 1
                    op = komut[0]
                    z = to_tpl(komut[3])
                    if z not in self.var_to_node:
                        self.var_to_node[z] = DAGNode(identifiers=[z])
                        self.nodes.append(self.var_to_node[z])
                    for node in self.nodes:
                        # todo: add left = right or right = left for + and *
                        if not node.killed and node.label == op and node.left is self.var_to_node[y] and node.right is \
                                self.var_to_node[z]:
                            n = node
                            break
                    if n is None:
                        n = DAGNode(label=op, left=self.var_to_node[y], right=self.var_to_node[z])
                        self.nodes.append(n)

                elif komut[0] in self.unary_ops:  # case 2
                    op = komut[0]

                    for node in self.nodes:
                        if not node.killed and node.label == op and node.right is None and node.left is \
                                self.var_to_node[y]:
                            n = node
                            break
                    if n is None:
                        n = DAGNode(label=op, left=self.var_to_node[y])
                        self.nodes.append(n)
                elif komut[0] == 'copy':  # case 3 x = y
                    n = self.var_to_node[y]

                if x in self.var_to_node:
                    if not (self.var_to_node[x].label is None and len(self.var_to_node[x].identifiers) == 1):
                        self.var_to_node[x].identifiers.remove(x)
                    self.var_to_node.pop(x)

                n.identifiers.append(x)
                self.var_to_node[x] = n
            elif komut[0] == 'arg':  # arg y
                y = to_tpl(komut[1])
                if y not in self.var_to_node:
                    self.var_to_node[y] = DAGNode(identifiers=[y])
                    self.nodes.append(self.var_to_node[y])
                n = DAGNode(label='arg', left=self.var_to_node[y], killed=True)
                self.nodes.append(n)
                self.kill_nodes_dependent_on(self.var_to_node[y])
                # because a vector may be passed and it is pass by reference
            elif komut[0] == 'vector':  # var x = [...]
                x = to_tpl(komut[1])
                length = komut[2]
                if x not in self.var_to_node:
                    self.var_to_node[x] = DAGNode(identifiers=[x])
                    self.nodes.append(self.var_to_node[x])
                n = DAGNode(label='vector', left=self.var_to_node[x], right=length)
                self.nodes.append(n)
            elif komut[0] == 'call':  # x = f(...)
                for var in self.var_to_node:
                    if type(var) == tuple and self.var_to_node[var].identifiers[0] != var and \
                            var[0] in self.block.global_vars:
                        self.nodes.append(DAGNode(label='copy', left=DAGNode(identifiers=[var]),
                                                  right=DAGNode(identifiers=[self.var_to_node[var].identifiers[0]])))

                # no var to node key for f since functions can have same names with variables
                if komut[1] is None:
                    x = None
                else:
                    x = to_tpl(komut[1])
                    if x in self.var_to_node:
                        if not (self.var_to_node[x].label is None and len(self.var_to_node[x].identifiers) == 1):
                            self.var_to_node[x].identifiers.remove(x)
                        self.var_to_node.pop(x)
                f = to_tpl(komut[2])

                n = DAGNode(label='call', left=DAGNode(identifiers=[f]), killed=True)
                n.identifiers.append(x)
                if x is not None:
                    self.var_to_node[x] = n
                self.nodes.append(n)
                self.kill_nodes_dependent_on(n.left)
                self.mark_globals_as_changed_and_kill_dependent()

            elif komut[0] == 'vector_set':  # case 3 gibi x[y] = z
                x = to_tpl(komut[1])
                y = to_tpl(komut[2])
                z = to_tpl(komut[3])
                op = komut[0]
                n = None
                if z not in self.var_to_node:
                    self.var_to_node[z] = DAGNode(identifiers=[z])
                    self.nodes.append(self.var_to_node[z])
                if x not in self.var_to_node:
                    self.var_to_node[x] = DAGNode(identifiers=[x])
                    self.nodes.append(self.var_to_node[x])
                if y not in self.var_to_node:
                    self.var_to_node[y] = DAGNode(identifiers=[y])
                    self.nodes.append(self.var_to_node[y])

                for node in self.nodes:
                    if not node.killed and node.label == op and node.left is self.var_to_node[x] and node.right is \
                            self.var_to_node[y] and node.third is self.var_to_node[z]:
                        n = node
                        break
                if n is None:
                    n = DAGNode(label=op, left=self.var_to_node[x], right=self.var_to_node[y],
                                third=self.var_to_node[z])
                    self.nodes.append(n)
                self.kill_nodes_dependent_on(self.var_to_node[x])

    def add_dag_komutu(self, komut):
        yeni_komut = []
        for sozcuk in komut:
            if type(sozcuk) is tuple:
                yeni_komut.append(to_name_id(sozcuk))
            else:
                yeni_komut.append(sozcuk)
        self.dag_komutlari.append(yeni_komut)

    def fold_constants_in_dag(self):
        for i, node in enumerate(self.nodes):
            if node.label is None:
                pass
            elif node.label in self.binary_ops:
                if isinstance(node.left.identifiers[0], (int, float)) and isinstance(node.right.identifiers[0],
                                                                                     (int, float, str, bool)):
                    if node.label in ['==', '!=']:
                        node.label = False
                        if node.label == '==':
                            node.identifiers.insert(0, node.left.identifiers[0] == node.right.identifiers[0])
                        else:
                            node.identifiers.insert(0, node.left.identifiers[0] != node.right.identifiers[0])

                if isinstance(node.left.identifiers[0], (int, float)) and isinstance(node.right.identifiers[0],
                                                                                     (int, float)):
                    if node.label in ['add', 'sub', 'mul', 'div', '<', '>', '<=', '>=']:

                        if node.label == 'add':
                            node.identifiers.insert(0, node.left.identifiers[0] + node.right.identifiers[0])
                        elif node.label == 'sub':
                            node.identifiers.insert(0, node.left.identifiers[0] - node.right.identifiers[0])
                        elif node.label == 'mul':
                            node.identifiers.insert(0, node.left.identifiers[0] * node.right.identifiers[0])
                        elif node.label == 'div':
                            node.identifiers.insert(0, node.left.identifiers[0] / node.right.identifiers[0])
                        elif node.label == '<':
                            node.identifiers.insert(0, node.left.identifiers[0] < node.right.identifiers[0])
                        elif node.label == '>':
                            node.identifiers.insert(0, node.left.identifiers[0] > node.right.identifiers[0])
                        elif node.label == '<=':
                            node.identifiers.insert(0, node.left.identifiers[0] <= node.right.identifiers[0])
                        elif node.label == '>=':
                            node.identifiers.insert(0, node.left.identifiers[0] >= node.right.identifiers[0])
                        node.label = None
                elif isinstance(node.left.identifiers[0], bool) and isinstance(node.right.identifiers[0], bool):
                    # the and and or instructions are not circuited so we dont use them anyways
                    if node.label == 'and':
                        node.label = None
                        node.identifiers.insert(0, node.left.identifiers[0] and node.right.identifiers[0])
                    elif node.label == 'or':
                        node.label = None
                        node.identifiers.insert(0, node.left.identifiers[0] or node.right.identifiers[0])

            elif node.label in self.unary_ops:
                if node.label == '!' and isinstance(node.left.identifiers[0], bool):
                    node.label = None
                    node.identifiers.insert(0, not node.left.identifiers[0])

    def reassemble_from_dag(self):
        for i, node in enumerate(self.nodes):
            if node.label is None:
                pass
            elif node.label in self.binary_ops:
                self.add_dag_komutu(
                    [node.label, node.identifiers[0], node.left.identifiers[0], node.right.identifiers[0]])
            elif node.label in self.unary_ops:
                self.add_dag_komutu([node.label, node.identifiers[0], node.left.identifiers[0]])
            elif node.label == 'vector_set':
                self.add_dag_komutu(
                    [node.label, node.left.identifiers[0], node.right.identifiers[0], node.third.identifiers[0]])
            elif node.label == 'arg':
                self.add_dag_komutu([node.label, node.left.identifiers[0]])
            elif node.label == 'call':
                # todo: test same name variable with function call
                self.add_dag_komutu([node.label, node.identifiers[0], node.left.identifiers[0]])
            elif node.label == 'vector':
                self.add_dag_komutu([node.label, node.left.identifiers[0], node.right])
            elif node.label == 'copy':
                # normally there is no copy node but before call, we copy globals to save them so that callee can use
                self.add_dag_komutu([node.label, node.left.identifiers[0], node.right.identifiers[0]])

        self.copy_live_variable_current_values()

    def copy_live_variable_current_values(self):
        for var in self.var_to_node:
            if type(var) == tuple and self.var_to_node[var].identifiers[0] != var and (
                    not var[0].startswith('.tmp') or var[0].startswith('.tmp_interblock') or (
                    self.block.komutlar and self.block.komutlar[-1][0].startswith(('branch_if', 'return')) and
                    len(self.block.komutlar[-1]) > 1 and self.block.komutlar[-1][1] == to_name_id(var))):
                self.add_dag_komutu(['copy', var, self.var_to_node[var].identifiers[0]])
        # for node in self.nodes:
        #    for i, identifier in enumerate(node.identifiers):
        #        if identifier != node.identifiers[0] and (
        #                not identifier[0].startswith('.tmp') or identifier[0].startswith('.tmp_interblock') or (
        #                self.block.komutlar and self.block.komutlar[-1][0].startswith(('branch_if', 'return')) and
        #                len(self.block.komutlar[-1]) > 1 and self.block.komutlar[-1][1] == to_name_id(identifier))):
        #            self.add_dag_komutu(['copy', identifier, node.identifiers[0]])

    def copy_global_current_values(self):
        for var in self.var_to_node:
            if type(var) == tuple and self.var_to_node[var].identifiers[0] != var and var[0] in self.block.global_vars:
                self.add_dag_komutu(['copy', var, self.var_to_node[var].identifiers[0]])

    def optimize(self):
        self.fold_constants_in_dag()

        pass


class DAG:
    def __init__(self, ara_dil_satirlari: List[List[Any]], global_vars: Dict[str, VarDecl]):
        self.ara_dil_satirlari: List[List[Any]] = ara_dil_satirlari
        self.fun_basic_blocks: Dict[str, List[BasicBlock]] = {}
        self.fun_dags: Dict[str, List[DAGBlock]] = {}
        self.global_vars: Dict[str, VarDecl] = global_vars

    def generate_basic_blocks(self):
        current_func = None
        for komut in self.ara_dil_satirlari:
            if komut[0] == 'fun':
                current_func = komut[1]
                self.fun_basic_blocks[current_func] = [BasicBlock(self.global_vars)]
            if komut[0] in ['label']:
                self.fun_basic_blocks[current_func].append(BasicBlock(self.global_vars))
                self.fun_basic_blocks[current_func][-1].add(komut)
            elif komut[0] in ['branch_if_true', 'branch_if_false', 'branch', 'return']:
                self.fun_basic_blocks[current_func][-1].add(komut)
                self.fun_basic_blocks[current_func].append(BasicBlock(self.global_vars))
            else:
                self.fun_basic_blocks[current_func][-1].add(komut)

    def generate_dag(self):
        for fun_name in self.fun_basic_blocks:
            self.fun_dags[fun_name] = []
            for block in self.fun_basic_blocks[fun_name]:
                if len(block.komutlar) > 0:
                    self.fun_dags[fun_name].append(DAGBlock(block))

    def generate_new_ara_dil(self):
        ara_dil = []
        for fun_name in self.fun_dags:
            for dag_block in self.fun_dags[fun_name]:
                ara_dil.extend(dag_block.selef_komutlar)
                ara_dil.extend(dag_block.dag_komutlari)
                ara_dil.extend(dag_block.halef_komutlar)
        return ara_dil

    def optimize(self):
        for fun_name in self.fun_dags:
            for dag_block in self.fun_dags[fun_name]:
                dag_block.optimize()

    def reassemble(self):
        for fun_name in self.fun_dags:
            for dag_block in self.fun_dags[fun_name]:
                dag_block.reassemble_from_dag()


class Compiler:
    def __init__(self, ast: ast_tools.Program, asm_yapici_cls: Type[AssemblyYapici]):
        self.ast: ast_tools.Program = ast
        self.ara_dil_yapici_visitor = AraDilYapiciVisitor()
        self.assembly_lines: List[str] = []
        self.ara_dil_satirlari: List[List[Any]] = []
        self.AssemblyYapici: Type[AssemblyYapici] = asm_yapici_cls
        self.asm_yapici: Optional[AssemblyYapici] = None
        self.USE_DAG_AND_REGISTER_ALLOC = True

    def ast_optimize_et(self):
        changes_made = True
        while changes_made:
            constant_folder = optimizer.ConstantFoldingVisitor()
            constant_folder.visit(self.ast)

            # todo: bu calismiyor.  reaching definition analysis lazım.
            # constant_propagator = optimizer.ConstantPropogationVisitor()
            # constant_propagator.visit(self.ast)

            olu_kod_oldurucu = optimizer.OluKodOldurucuVisitor()
            olu_kod_oldurucu.visit(self.ast)

            changes_made = olu_kod_oldurucu.changes_made or constant_folder.changes_made  # or constant_propagator.changes_made
            # print(ast_tools.PrintVisitor().visit(self.ast))

    def fonksiyon_basic_blocklari_olustur(self):
        dag = DAG(self.ara_dil_satirlari, self.ara_dil_yapici_visitor.global_vars)
        dag.generate_basic_blocks()
        dag.generate_dag()
        dag.optimize()
        dag.reassemble()
        return dag.fun_dags

    def assembly_optimize_et(self):
        pass

    def ara_dil_yap(self):
        self.ara_dil_yapici_visitor.visit(self.ast)
        self.ara_dil_satirlari = self.ara_dil_yapici_visitor.ara_dil_sozleri

    def assembly_yap(self):
        self.asm_yapici = self.AssemblyYapici(self.ara_dil_yapici_visitor.global_vars,
                                              self.ara_dil_yapici_visitor.func_activation_records,
                                              self.ara_dil_yapici_visitor.global_string_to_label,
                                              self.ara_dil_satirlari)
        self.assembly_lines = self.asm_yapici.yap()

    def dag_den_assembly_yap(self, fun_dags: Dict[str, List[DAGBlock]]):
        self.asm_yapici = self.AssemblyYapici(self.ara_dil_yapici_visitor.global_vars,
                                              self.ara_dil_yapici_visitor.func_activation_records,
                                              self.ara_dil_yapici_visitor.global_string_to_label,
                                              self.ara_dil_satirlari)
        self.assembly_lines = self.asm_yapici.yap_dag_den(fun_dags)

    def compile(self):
        self.ast_optimize_et()
        self.ara_dil_yap()
        self.ara_dildeki_floatlari_int_yap()

        if (self.USE_DAG_AND_REGISTER_ALLOC):
            fun_dags = self.fonksiyon_basic_blocklari_olustur()
            self.dag_den_assembly_yap(fun_dags)
        else:
            self.assembly_yap()

        self.assembly_optimize_et()

        return self

    def save_ass(self, filename: str):
        with open(filename, 'w') as asm_dosyasi:
            for satir in self.assembly_lines:
                asm_dosyasi.write(f'{satir}\n')

        return self

    def ara_dildeki_floatlari_int_yap(self):
        for komut in self.ara_dil_satirlari:
            for i, arg in enumerate(komut):
                if type(arg) == float:
                    komut[i] = int(arg)


if __name__ == '__main__':
    # bb = BasicBlock()
    # bb.add(['mul', 'a', 'b', 'c'])
    # bb.add(['copy', 'd', 'b'])
    # bb.add(['mul', 'e', 'd', 'c'])
    # bb.add(['copy', 'b', 'e'])
    # bb.add(['add', 'f', 'b', 'c'])
    # bb.add(['add', 'g', 'd', 'f'])
    # bb.add(['vector_get', 'x', 'a', 'i'])
    # bb.add(['vector_set', 'a', 'j', 'y'])
    # bb.add(['vector_get', 'z', 'a', 'i'])
    # block = DAGBlock(bb)
    # print(1)
    pass
