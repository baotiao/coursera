
bomb:     file format elf64-x86-64


Disassembly of section .init:

0000000000400a48 <_init>:
  400a48:	48 83 ec 08          	sub    $0x8,%rsp
  400a4c:	e8 1b 02 00 00       	callq  400c6c <call_gmon_start>
  400a51:	e8 aa 02 00 00       	callq  400d00 <frame_dummy>
  400a56:	e8 45 0e 00 00       	callq  4018a0 <__do_global_ctors_aux>
  400a5b:	48 83 c4 08          	add    $0x8,%rsp
  400a5f:	c3                   	retq   

Disassembly of section .plt:

0000000000400a60 <printf@plt-0x10>:
  400a60:	ff 35 22 1a 20 00    	pushq  0x201a22(%rip)        # 602488 <_GLOBAL_OFFSET_TABLE_+0x8>
  400a66:	ff 25 24 1a 20 00    	jmpq   *0x201a24(%rip)        # 602490 <_GLOBAL_OFFSET_TABLE_+0x10>
  400a6c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400a70 <printf@plt>:
  400a70:	ff 25 22 1a 20 00    	jmpq   *0x201a22(%rip)        # 602498 <_GLOBAL_OFFSET_TABLE_+0x18>
  400a76:	68 00 00 00 00       	pushq  $0x0
  400a7b:	e9 e0 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400a80 <close@plt>:
  400a80:	ff 25 1a 1a 20 00    	jmpq   *0x201a1a(%rip)        # 6024a0 <_GLOBAL_OFFSET_TABLE_+0x20>
  400a86:	68 01 00 00 00       	pushq  $0x1
  400a8b:	e9 d0 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400a90 <gethostbyname@plt>:
  400a90:	ff 25 12 1a 20 00    	jmpq   *0x201a12(%rip)        # 6024a8 <_GLOBAL_OFFSET_TABLE_+0x28>
  400a96:	68 02 00 00 00       	pushq  $0x2
  400a9b:	e9 c0 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400aa0 <puts@plt>:
  400aa0:	ff 25 0a 1a 20 00    	jmpq   *0x201a0a(%rip)        # 6024b0 <_GLOBAL_OFFSET_TABLE_+0x30>
  400aa6:	68 03 00 00 00       	pushq  $0x3
  400aab:	e9 b0 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400ab0 <__isoc99_sscanf@plt>:
  400ab0:	ff 25 02 1a 20 00    	jmpq   *0x201a02(%rip)        # 6024b8 <_GLOBAL_OFFSET_TABLE_+0x38>
  400ab6:	68 04 00 00 00       	pushq  $0x4
  400abb:	e9 a0 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400ac0 <exit@plt>:
  400ac0:	ff 25 fa 19 20 00    	jmpq   *0x2019fa(%rip)        # 6024c0 <_GLOBAL_OFFSET_TABLE_+0x40>
  400ac6:	68 05 00 00 00       	pushq  $0x5
  400acb:	e9 90 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400ad0 <fopen@plt>:
  400ad0:	ff 25 f2 19 20 00    	jmpq   *0x2019f2(%rip)        # 6024c8 <_GLOBAL_OFFSET_TABLE_+0x48>
  400ad6:	68 06 00 00 00       	pushq  $0x6
  400adb:	e9 80 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400ae0 <__libc_start_main@plt>:
  400ae0:	ff 25 ea 19 20 00    	jmpq   *0x2019ea(%rip)        # 6024d0 <_GLOBAL_OFFSET_TABLE_+0x50>
  400ae6:	68 07 00 00 00       	pushq  $0x7
  400aeb:	e9 70 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400af0 <dup@plt>:
  400af0:	ff 25 e2 19 20 00    	jmpq   *0x2019e2(%rip)        # 6024d8 <_GLOBAL_OFFSET_TABLE_+0x58>
  400af6:	68 08 00 00 00       	pushq  $0x8
  400afb:	e9 60 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b00 <system@plt>:
  400b00:	ff 25 da 19 20 00    	jmpq   *0x2019da(%rip)        # 6024e0 <_GLOBAL_OFFSET_TABLE_+0x60>
  400b06:	68 09 00 00 00       	pushq  $0x9
  400b0b:	e9 50 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b10 <fgets@plt>:
  400b10:	ff 25 d2 19 20 00    	jmpq   *0x2019d2(%rip)        # 6024e8 <_GLOBAL_OFFSET_TABLE_+0x68>
  400b16:	68 0a 00 00 00       	pushq  $0xa
  400b1b:	e9 40 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b20 <fputc@plt>:
  400b20:	ff 25 ca 19 20 00    	jmpq   *0x2019ca(%rip)        # 6024f0 <_GLOBAL_OFFSET_TABLE_+0x70>
  400b26:	68 0b 00 00 00       	pushq  $0xb
  400b2b:	e9 30 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b30 <bcopy@plt>:
  400b30:	ff 25 c2 19 20 00    	jmpq   *0x2019c2(%rip)        # 6024f8 <_GLOBAL_OFFSET_TABLE_+0x78>
  400b36:	68 0c 00 00 00       	pushq  $0xc
  400b3b:	e9 20 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b40 <__ctype_b_loc@plt>:
  400b40:	ff 25 ba 19 20 00    	jmpq   *0x2019ba(%rip)        # 602500 <_GLOBAL_OFFSET_TABLE_+0x80>
  400b46:	68 0d 00 00 00       	pushq  $0xd
  400b4b:	e9 10 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b50 <sprintf@plt>:
  400b50:	ff 25 b2 19 20 00    	jmpq   *0x2019b2(%rip)        # 602508 <_GLOBAL_OFFSET_TABLE_+0x88>
  400b56:	68 0e 00 00 00       	pushq  $0xe
  400b5b:	e9 00 ff ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b60 <sleep@plt>:
  400b60:	ff 25 aa 19 20 00    	jmpq   *0x2019aa(%rip)        # 602510 <_GLOBAL_OFFSET_TABLE_+0x90>
  400b66:	68 0f 00 00 00       	pushq  $0xf
  400b6b:	e9 f0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b70 <rewind@plt>:
  400b70:	ff 25 a2 19 20 00    	jmpq   *0x2019a2(%rip)        # 602518 <_GLOBAL_OFFSET_TABLE_+0x98>
  400b76:	68 10 00 00 00       	pushq  $0x10
  400b7b:	e9 e0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b80 <strtol@plt>:
  400b80:	ff 25 9a 19 20 00    	jmpq   *0x20199a(%rip)        # 602520 <_GLOBAL_OFFSET_TABLE_+0xa0>
  400b86:	68 11 00 00 00       	pushq  $0x11
  400b8b:	e9 d0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400b90 <connect@plt>:
  400b90:	ff 25 92 19 20 00    	jmpq   *0x201992(%rip)        # 602528 <_GLOBAL_OFFSET_TABLE_+0xa8>
  400b96:	68 12 00 00 00       	pushq  $0x12
  400b9b:	e9 c0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400ba0 <tmpfile@plt>:
  400ba0:	ff 25 8a 19 20 00    	jmpq   *0x20198a(%rip)        # 602530 <_GLOBAL_OFFSET_TABLE_+0xb0>
  400ba6:	68 13 00 00 00       	pushq  $0x13
  400bab:	e9 b0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400bb0 <signal@plt>:
  400bb0:	ff 25 82 19 20 00    	jmpq   *0x201982(%rip)        # 602538 <_GLOBAL_OFFSET_TABLE_+0xb8>
  400bb6:	68 14 00 00 00       	pushq  $0x14
  400bbb:	e9 a0 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400bc0 <socket@plt>:
  400bc0:	ff 25 7a 19 20 00    	jmpq   *0x20197a(%rip)        # 602540 <_GLOBAL_OFFSET_TABLE_+0xc0>
  400bc6:	68 15 00 00 00       	pushq  $0x15
  400bcb:	e9 90 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400bd0 <getenv@plt>:
  400bd0:	ff 25 72 19 20 00    	jmpq   *0x201972(%rip)        # 602548 <_GLOBAL_OFFSET_TABLE_+0xc8>
  400bd6:	68 16 00 00 00       	pushq  $0x16
  400bdb:	e9 80 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400be0 <cuserid@plt>:
  400be0:	ff 25 6a 19 20 00    	jmpq   *0x20196a(%rip)        # 602550 <_GLOBAL_OFFSET_TABLE_+0xd0>
  400be6:	68 17 00 00 00       	pushq  $0x17
  400beb:	e9 70 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400bf0 <strcpy@plt>:
  400bf0:	ff 25 62 19 20 00    	jmpq   *0x201962(%rip)        # 602558 <_GLOBAL_OFFSET_TABLE_+0xd8>
  400bf6:	68 18 00 00 00       	pushq  $0x18
  400bfb:	e9 60 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400c00 <fclose@plt>:
  400c00:	ff 25 5a 19 20 00    	jmpq   *0x20195a(%rip)        # 602560 <_GLOBAL_OFFSET_TABLE_+0xe0>
  400c06:	68 19 00 00 00       	pushq  $0x19
  400c0b:	e9 50 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400c10 <fwrite@plt>:
  400c10:	ff 25 52 19 20 00    	jmpq   *0x201952(%rip)        # 602568 <_GLOBAL_OFFSET_TABLE_+0xe8>
  400c16:	68 1a 00 00 00       	pushq  $0x1a
  400c1b:	e9 40 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400c20 <fprintf@plt>:
  400c20:	ff 25 4a 19 20 00    	jmpq   *0x20194a(%rip)        # 602570 <_GLOBAL_OFFSET_TABLE_+0xf0>
  400c26:	68 1b 00 00 00       	pushq  $0x1b
  400c2b:	e9 30 fe ff ff       	jmpq   400a60 <_init+0x18>

0000000000400c30 <fflush@plt>:
  400c30:	ff 25 42 19 20 00    	jmpq   *0x201942(%rip)        # 602578 <_GLOBAL_OFFSET_TABLE_+0xf8>
  400c36:	68 1c 00 00 00       	pushq  $0x1c
  400c3b:	e9 20 fe ff ff       	jmpq   400a60 <_init+0x18>

Disassembly of section .text:

0000000000400c40 <_start>:
  400c40:	31 ed                	xor    %ebp,%ebp
  400c42:	49 89 d1             	mov    %rdx,%r9
  400c45:	5e                   	pop    %rsi
  400c46:	48 89 e2             	mov    %rsp,%rdx
  400c49:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  400c4d:	50                   	push   %rax
  400c4e:	54                   	push   %rsp
  400c4f:	49 c7 c0 90 18 40 00 	mov    $0x401890,%r8
  400c56:	48 c7 c1 00 18 40 00 	mov    $0x401800,%rcx
  400c5d:	48 c7 c7 24 0d 40 00 	mov    $0x400d24,%rdi
  400c64:	e8 77 fe ff ff       	callq  400ae0 <__libc_start_main@plt>
  400c69:	f4                   	hlt    
  400c6a:	90                   	nop
  400c6b:	90                   	nop

0000000000400c6c <call_gmon_start>:
  400c6c:	48 83 ec 08          	sub    $0x8,%rsp
  400c70:	48 8b 05 01 18 20 00 	mov    0x201801(%rip),%rax        # 602478 <_DYNAMIC+0x190>
  400c77:	48 85 c0             	test   %rax,%rax
  400c7a:	74 02                	je     400c7e <call_gmon_start+0x12>
  400c7c:	ff d0                	callq  *%rax
  400c7e:	48 83 c4 08          	add    $0x8,%rsp
  400c82:	c3                   	retq   
  400c83:	90                   	nop
  400c84:	90                   	nop
  400c85:	90                   	nop
  400c86:	90                   	nop
  400c87:	90                   	nop
  400c88:	90                   	nop
  400c89:	90                   	nop
  400c8a:	90                   	nop
  400c8b:	90                   	nop
  400c8c:	90                   	nop
  400c8d:	90                   	nop
  400c8e:	90                   	nop
  400c8f:	90                   	nop

0000000000400c90 <__do_global_dtors_aux>:
  400c90:	55                   	push   %rbp
  400c91:	48 89 e5             	mov    %rsp,%rbp
  400c94:	53                   	push   %rbx
  400c95:	48 83 ec 08          	sub    $0x8,%rsp
  400c99:	80 3d b8 1f 20 00 00 	cmpb   $0x0,0x201fb8(%rip)        # 602c58 <completed.5895>
  400ca0:	75 4b                	jne    400ced <__do_global_dtors_aux+0x5d>
  400ca2:	bb d8 22 60 00       	mov    $0x6022d8,%ebx
  400ca7:	48 8b 05 b2 1f 20 00 	mov    0x201fb2(%rip),%rax        # 602c60 <dtor_idx.5897>
  400cae:	48 81 eb d0 22 60 00 	sub    $0x6022d0,%rbx
  400cb5:	48 c1 fb 03          	sar    $0x3,%rbx
  400cb9:	48 83 eb 01          	sub    $0x1,%rbx
  400cbd:	48 39 d8             	cmp    %rbx,%rax
  400cc0:	73 24                	jae    400ce6 <__do_global_dtors_aux+0x56>
  400cc2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  400cc8:	48 83 c0 01          	add    $0x1,%rax
  400ccc:	48 89 05 8d 1f 20 00 	mov    %rax,0x201f8d(%rip)        # 602c60 <dtor_idx.5897>
  400cd3:	ff 14 c5 d0 22 60 00 	callq  *0x6022d0(,%rax,8)
  400cda:	48 8b 05 7f 1f 20 00 	mov    0x201f7f(%rip),%rax        # 602c60 <dtor_idx.5897>
  400ce1:	48 39 d8             	cmp    %rbx,%rax
  400ce4:	72 e2                	jb     400cc8 <__do_global_dtors_aux+0x38>
  400ce6:	c6 05 6b 1f 20 00 01 	movb   $0x1,0x201f6b(%rip)        # 602c58 <completed.5895>
  400ced:	48 83 c4 08          	add    $0x8,%rsp
  400cf1:	5b                   	pop    %rbx
  400cf2:	5d                   	pop    %rbp
  400cf3:	c3                   	retq   
  400cf4:	66 66 66 2e 0f 1f 84 	data32 data32 nopw %cs:0x0(%rax,%rax,1)
  400cfb:	00 00 00 00 00 

0000000000400d00 <frame_dummy>:
  400d00:	48 83 3d d8 15 20 00 	cmpq   $0x0,0x2015d8(%rip)        # 6022e0 <__JCR_END__>
  400d07:	00 
  400d08:	55                   	push   %rbp
  400d09:	48 89 e5             	mov    %rsp,%rbp
  400d0c:	74 12                	je     400d20 <frame_dummy+0x20>
  400d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  400d13:	48 85 c0             	test   %rax,%rax
  400d16:	74 08                	je     400d20 <frame_dummy+0x20>
  400d18:	5d                   	pop    %rbp
  400d19:	bf e0 22 60 00       	mov    $0x6022e0,%edi
  400d1e:	ff e0                	jmpq   *%rax
  400d20:	5d                   	pop    %rbp
  400d21:	c3                   	retq   
  400d22:	90                   	nop
  400d23:	90                   	nop

0000000000400d24 <main>:
  400d24:	53                   	push   %rbx
  400d25:	48 89 f3             	mov    %rsi,%rbx
  400d28:	83 ff 01             	cmp    $0x1,%edi
  400d2b:	75 10                	jne    400d3d <main+0x19>
  400d2d:	48 8b 05 0c 1f 20 00 	mov    0x201f0c(%rip),%rax        # 602c40 <stdin@@GLIBC_2.2.5>
  400d34:	48 89 05 e5 21 20 00 	mov    %rax,0x2021e5(%rip)        # 602f20 <infile>
  400d3b:	eb 56                	jmp    400d93 <main+0x6f>
  400d3d:	83 ff 02             	cmp    $0x2,%edi
  400d40:	75 35                	jne    400d77 <main+0x53>
  400d42:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  400d46:	be 46 1d 40 00       	mov    $0x401d46,%esi
  400d4b:	e8 80 fd ff ff       	callq  400ad0 <fopen@plt>
  400d50:	48 89 05 c9 21 20 00 	mov    %rax,0x2021c9(%rip)        # 602f20 <infile>
  400d57:	48 85 c0             	test   %rax,%rax
  400d5a:	75 37                	jne    400d93 <main+0x6f>
  400d5c:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  400d60:	48 8b 33             	mov    (%rbx),%rsi
  400d63:	bf 10 19 40 00       	mov    $0x401910,%edi
  400d68:	e8 03 fd ff ff       	callq  400a70 <printf@plt>
  400d6d:	bf 08 00 00 00       	mov    $0x8,%edi
  400d72:	e8 49 fd ff ff       	callq  400ac0 <exit@plt>
  400d77:	48 8b 36             	mov    (%rsi),%rsi
  400d7a:	bf 2d 19 40 00       	mov    $0x40192d,%edi
  400d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  400d84:	e8 e7 fc ff ff       	callq  400a70 <printf@plt>
  400d89:	bf 08 00 00 00       	mov    $0x8,%edi
  400d8e:	e8 2d fd ff ff       	callq  400ac0 <exit@plt>
  400d93:	e8 ff 05 00 00       	callq  401397 <initialize_bomb>
  400d98:	bf 78 19 40 00       	mov    $0x401978,%edi
  400d9d:	e8 fe fc ff ff       	callq  400aa0 <puts@plt>
  400da2:	bf b8 19 40 00       	mov    $0x4019b8,%edi
  400da7:	e8 f4 fc ff ff       	callq  400aa0 <puts@plt>
  400dac:	e8 ae 08 00 00       	callq  40165f <read_line>
  400db1:	48 89 c7             	mov    %rax,%rdi
  400db4:	e8 b7 00 00 00       	callq  400e70 <phase_1>
  400db9:	e8 c7 09 00 00       	callq  401785 <phase_defused>
  400dbe:	bf e8 19 40 00       	mov    $0x4019e8,%edi
  400dc3:	e8 d8 fc ff ff       	callq  400aa0 <puts@plt>
  400dc8:	e8 92 08 00 00       	callq  40165f <read_line>
  400dcd:	48 89 c7             	mov    %rax,%rdi
  400dd0:	e8 b7 00 00 00       	callq  400e8c <phase_2>
  400dd5:	e8 ab 09 00 00       	callq  401785 <phase_defused>
  400dda:	bf 47 19 40 00       	mov    $0x401947,%edi
  400ddf:	e8 bc fc ff ff       	callq  400aa0 <puts@plt>
  400de4:	e8 76 08 00 00       	callq  40165f <read_line>
  400de9:	48 89 c7             	mov    %rax,%rdi
  400dec:	e8 08 01 00 00       	callq  400ef9 <phase_3>
  400df1:	e8 8f 09 00 00       	callq  401785 <phase_defused>
  400df6:	bf 65 19 40 00       	mov    $0x401965,%edi
  400dfb:	e8 a0 fc ff ff       	callq  400aa0 <puts@plt>
  400e00:	e8 5a 08 00 00       	callq  40165f <read_line>
  400e05:	48 89 c7             	mov    %rax,%rdi
  400e08:	e8 b4 01 00 00       	callq  400fc1 <phase_4>
  400e0d:	e8 73 09 00 00       	callq  401785 <phase_defused>
  400e12:	bf 18 1a 40 00       	mov    $0x401a18,%edi
  400e17:	e8 84 fc ff ff       	callq  400aa0 <puts@plt>
  400e1c:	e8 3e 08 00 00       	callq  40165f <read_line>
  400e21:	48 89 c7             	mov    %rax,%rdi
  400e24:	e8 d9 01 00 00       	callq  401002 <phase_5>
  400e29:	e8 57 09 00 00       	callq  401785 <phase_defused>
  400e2e:	bf 40 1a 40 00       	mov    $0x401a40,%edi
  400e33:	e8 68 fc ff ff       	callq  400aa0 <puts@plt>
  400e38:	bf 78 1a 40 00       	mov    $0x401a78,%edi
  400e3d:	e8 5e fc ff ff       	callq  400aa0 <puts@plt>
  400e42:	bf b8 1a 40 00       	mov    $0x401ab8,%edi
  400e47:	e8 54 fc ff ff       	callq  400aa0 <puts@plt>
  400e4c:	e8 0e 08 00 00       	callq  40165f <read_line>
  400e51:	48 89 c7             	mov    %rax,%rdi
  400e54:	e8 80 02 00 00       	callq  4010d9 <phase_6>
  400e59:	e8 27 09 00 00       	callq  401785 <phase_defused>
  400e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  400e63:	5b                   	pop    %rbx
  400e64:	c3                   	retq   
  400e65:	90                   	nop
  400e66:	90                   	nop
  400e67:	90                   	nop
  400e68:	90                   	nop
  400e69:	90                   	nop
  400e6a:	90                   	nop
  400e6b:	90                   	nop
  400e6c:	90                   	nop
  400e6d:	90                   	nop
  400e6e:	90                   	nop
  400e6f:	90                   	nop

0000000000400e70 <phase_1>:
  400e70:	48 83 ec 08          	sub    $0x8,%rsp
  400e74:	be f8 1a 40 00       	mov    $0x401af8,%esi
  400e79:	e8 bf 03 00 00       	callq  40123d <strings_not_equal>
  400e7e:	85 c0                	test   %eax,%eax
  400e80:	74 05                	je     400e87 <phase_1+0x17>
  400e82:	e8 b6 07 00 00       	callq  40163d <explode_bomb>
  400e87:	48 83 c4 08          	add    $0x8,%rsp
  400e8b:	c3                   	retq   

0000000000400e8c <phase_2>:
  400e8c:	48 89 5c 24 e0       	mov    %rbx,-0x20(%rsp)
  400e91:	48 89 6c 24 e8       	mov    %rbp,-0x18(%rsp)
  400e96:	4c 89 64 24 f0       	mov    %r12,-0x10(%rsp)
  400e9b:	4c 89 6c 24 f8       	mov    %r13,-0x8(%rsp)
  400ea0:	48 83 ec 48          	sub    $0x48,%rsp
  400ea4:	48 89 e6             	mov    %rsp,%rsi
  400ea7:	e8 97 08 00 00       	callq  401743 <read_six_numbers>
  400eac:	48 89 e5             	mov    %rsp,%rbp
  400eaf:	4c 8d 6c 24 0c       	lea    0xc(%rsp),%r13
  400eb4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  400eba:	48 89 eb             	mov    %rbp,%rbx
  400ebd:	8b 45 0c             	mov    0xc(%rbp),%eax
  400ec0:	39 45 00             	cmp    %eax,0x0(%rbp)
  400ec3:	74 05                	je     400eca <phase_2+0x3e>
  400ec5:	e8 73 07 00 00       	callq  40163d <explode_bomb>
  400eca:	44 03 23             	add    (%rbx),%r12d
  400ecd:	48 83 c5 04          	add    $0x4,%rbp
  400ed1:	4c 39 ed             	cmp    %r13,%rbp
  400ed4:	75 e4                	jne    400eba <phase_2+0x2e>
  400ed6:	45 85 e4             	test   %r12d,%r12d
  400ed9:	75 05                	jne    400ee0 <phase_2+0x54>
  400edb:	e8 5d 07 00 00       	callq  40163d <explode_bomb>
  400ee0:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  400ee5:	48 8b 6c 24 30       	mov    0x30(%rsp),%rbp
  400eea:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
  400eef:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  400ef4:	48 83 c4 48          	add    $0x48,%rsp
  400ef8:	c3                   	retq   

0000000000400ef9 <phase_3>:
  400ef9:	48 83 ec 18          	sub    $0x18,%rsp
  400efd:	48 8d 4c 24 08       	lea    0x8(%rsp),%rcx
  400f02:	48 8d 54 24 0c       	lea    0xc(%rsp),%rdx
  400f07:	be be 1e 40 00       	mov    $0x401ebe,%esi
  400f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  400f11:	e8 9a fb ff ff       	callq  400ab0 <__isoc99_sscanf@plt>
  400f16:	83 f8 01             	cmp    $0x1,%eax
  400f19:	7f 05                	jg     400f20 <phase_3+0x27>
  400f1b:	e8 1d 07 00 00       	callq  40163d <explode_bomb>
  400f20:	83 7c 24 0c 07       	cmpl   $0x7,0xc(%rsp)
  400f25:	77 3c                	ja     400f63 <phase_3+0x6a>
  400f27:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  400f2b:	ff 24 c5 60 1b 40 00 	jmpq   *0x401b60(,%rax,8)
  400f32:	b8 17 02 00 00       	mov    $0x217,%eax
  400f37:	eb 3b                	jmp    400f74 <phase_3+0x7b>
  400f39:	b8 d6 00 00 00       	mov    $0xd6,%eax
  400f3e:	eb 34                	jmp    400f74 <phase_3+0x7b>
  400f40:	b8 53 01 00 00       	mov    $0x153,%eax
  400f45:	eb 2d                	jmp    400f74 <phase_3+0x7b>
  400f47:	b8 77 00 00 00       	mov    $0x77,%eax
  400f4c:	eb 26                	jmp    400f74 <phase_3+0x7b>
  400f4e:	b8 60 01 00 00       	mov    $0x160,%eax
  400f53:	eb 1f                	jmp    400f74 <phase_3+0x7b>
  400f55:	b8 97 03 00 00       	mov    $0x397,%eax
  400f5a:	eb 18                	jmp    400f74 <phase_3+0x7b>
  400f5c:	b8 9c 01 00 00       	mov    $0x19c,%eax
  400f61:	eb 11                	jmp    400f74 <phase_3+0x7b>
  400f63:	e8 d5 06 00 00       	callq  40163d <explode_bomb>
  400f68:	b8 00 00 00 00       	mov    $0x0,%eax
  400f6d:	eb 05                	jmp    400f74 <phase_3+0x7b>
  400f6f:	b8 9e 03 00 00       	mov    $0x39e,%eax
  400f74:	3b 44 24 08          	cmp    0x8(%rsp),%eax
  400f78:	74 05                	je     400f7f <phase_3+0x86>
  400f7a:	e8 be 06 00 00       	callq  40163d <explode_bomb>
  400f7f:	48 83 c4 18          	add    $0x18,%rsp
  400f83:	c3                   	retq   

0000000000400f84 <func4>:
  400f84:	48 89 5c 24 f0       	mov    %rbx,-0x10(%rsp)
  400f89:	48 89 6c 24 f8       	mov    %rbp,-0x8(%rsp)
  400f8e:	48 83 ec 18          	sub    $0x18,%rsp
  400f92:	89 fb                	mov    %edi,%ebx
  400f94:	b8 01 00 00 00       	mov    $0x1,%eax
  400f99:	83 ff 01             	cmp    $0x1,%edi
  400f9c:	7e 14                	jle    400fb2 <func4+0x2e>
  400f9e:	8d 7b ff             	lea    -0x1(%rbx),%edi
  400fa1:	e8 de ff ff ff       	callq  400f84 <func4>
  400fa6:	89 c5                	mov    %eax,%ebp
  400fa8:	8d 7b fe             	lea    -0x2(%rbx),%edi
  400fab:	e8 d4 ff ff ff       	callq  400f84 <func4>
  400fb0:	01 e8                	add    %ebp,%eax
  400fb2:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  400fb7:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  400fbc:	48 83 c4 18          	add    $0x18,%rsp
  400fc0:	c3                   	retq   

0000000000400fc1 <phase_4>:
  400fc1:	48 83 ec 18          	sub    $0x18,%rsp
  400fc5:	48 8d 54 24 0c       	lea    0xc(%rsp),%rdx
  400fca:	be c1 1e 40 00       	mov    $0x401ec1,%esi
  400fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  400fd4:	e8 d7 fa ff ff       	callq  400ab0 <__isoc99_sscanf@plt>
  400fd9:	83 f8 01             	cmp    $0x1,%eax
  400fdc:	75 07                	jne    400fe5 <phase_4+0x24>
  400fde:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%rsp)
  400fe3:	7f 05                	jg     400fea <phase_4+0x29>
  400fe5:	e8 53 06 00 00       	callq  40163d <explode_bomb>
  400fea:	8b 7c 24 0c          	mov    0xc(%rsp),%edi
  400fee:	e8 91 ff ff ff       	callq  400f84 <func4>
  400ff3:	83 f8 37             	cmp    $0x37,%eax
  400ff6:	74 05                	je     400ffd <phase_4+0x3c>
  400ff8:	e8 40 06 00 00       	callq  40163d <explode_bomb>
  400ffd:	48 83 c4 18          	add    $0x18,%rsp
  401001:	c3                   	retq   

0000000000401002 <phase_5>:
  401002:	48 83 ec 18          	sub    $0x18,%rsp
  401006:	48 8d 4c 24 08       	lea    0x8(%rsp),%rcx
  40100b:	48 8d 54 24 0c       	lea    0xc(%rsp),%rdx
  401010:	be be 1e 40 00       	mov    $0x401ebe,%esi
  401015:	b8 00 00 00 00       	mov    $0x0,%eax
  40101a:	e8 91 fa ff ff       	callq  400ab0 <__isoc99_sscanf@plt>
  40101f:	83 f8 01             	cmp    $0x1,%eax
  401022:	7f 05                	jg     401029 <phase_5+0x27>
  401024:	e8 14 06 00 00       	callq  40163d <explode_bomb>
  401029:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  40102d:	83 e0 0f             	and    $0xf,%eax
  401030:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  401034:	83 f8 0f             	cmp    $0xf,%eax
  401037:	74 2c                	je     401065 <phase_5+0x63>
  401039:	b9 00 00 00 00       	mov    $0x0,%ecx
  40103e:	ba 00 00 00 00       	mov    $0x0,%edx
  401043:	83 c2 01             	add    $0x1,%edx
  401046:	48 98                	cltq   
  401048:	8b 04 85 a0 1b 40 00 	mov    0x401ba0(,%rax,4),%eax
  40104f:	01 c1                	add    %eax,%ecx
  401051:	83 f8 0f             	cmp    $0xf,%eax
  401054:	75 ed                	jne    401043 <phase_5+0x41>
  401056:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  40105a:	83 fa 0c             	cmp    $0xc,%edx
  40105d:	75 06                	jne    401065 <phase_5+0x63>
  40105f:	3b 4c 24 08          	cmp    0x8(%rsp),%ecx
  401063:	74 05                	je     40106a <phase_5+0x68>
  401065:	e8 d3 05 00 00       	callq  40163d <explode_bomb>
  40106a:	48 83 c4 18          	add    $0x18,%rsp
  40106e:	c3                   	retq   

000000000040106f <fun6>:
  40106f:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  401073:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  40107a:	00 
  40107b:	48 89 f8             	mov    %rdi,%rax
  40107e:	48 89 f9             	mov    %rdi,%rcx
  401081:	4d 85 c0             	test   %r8,%r8
  401084:	75 40                	jne    4010c6 <fun6+0x57>
  401086:	48 89 f8             	mov    %rdi,%rax
  401089:	c3                   	retq   
  40108a:	48 89 d1             	mov    %rdx,%rcx
  40108d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  401091:	48 85 d2             	test   %rdx,%rdx
  401094:	74 09                	je     40109f <fun6+0x30>
  401096:	39 32                	cmp    %esi,(%rdx)
  401098:	7f f0                	jg     40108a <fun6+0x1b>
  40109a:	48 89 cf             	mov    %rcx,%rdi
  40109d:	eb 03                	jmp    4010a2 <fun6+0x33>
  40109f:	48 89 cf             	mov    %rcx,%rdi
  4010a2:	48 39 d7             	cmp    %rdx,%rdi
  4010a5:	74 06                	je     4010ad <fun6+0x3e>
  4010a7:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  4010ab:	eb 03                	jmp    4010b0 <fun6+0x41>
  4010ad:	4c 89 c0             	mov    %r8,%rax
  4010b0:	49 8b 48 08          	mov    0x8(%r8),%rcx
  4010b4:	49 89 50 08          	mov    %rdx,0x8(%r8)
  4010b8:	48 85 c9             	test   %rcx,%rcx
  4010bb:	74 1a                	je     4010d7 <fun6+0x68>
  4010bd:	49 89 c8             	mov    %rcx,%r8
  4010c0:	48 89 c1             	mov    %rax,%rcx
  4010c3:	48 89 c7             	mov    %rax,%rdi
  4010c6:	48 89 ca             	mov    %rcx,%rdx
  4010c9:	48 85 c9             	test   %rcx,%rcx
  4010cc:	74 d4                	je     4010a2 <fun6+0x33>
  4010ce:	41 8b 30             	mov    (%r8),%esi
  4010d1:	39 31                	cmp    %esi,(%rcx)
  4010d3:	7f b8                	jg     40108d <fun6+0x1e>
  4010d5:	eb cb                	jmp    4010a2 <fun6+0x33>
  4010d7:	f3 c3                	repz retq 

00000000004010d9 <phase_6>:
  4010d9:	48 83 ec 08          	sub    $0x8,%rsp
  4010dd:	ba 0a 00 00 00       	mov    $0xa,%edx
  4010e2:	be 00 00 00 00       	mov    $0x0,%esi
  4010e7:	e8 94 fa ff ff       	callq  400b80 <strtol@plt>
  4010ec:	89 05 8e 16 20 00    	mov    %eax,0x20168e(%rip)        # 602780 <node0>
  4010f2:	bf 80 27 60 00       	mov    $0x602780,%edi
  4010f7:	e8 73 ff ff ff       	callq  40106f <fun6>
  4010fc:	48 8b 40 08          	mov    0x8(%rax),%rax
  401100:	48 8b 40 08          	mov    0x8(%rax),%rax
  401104:	48 8b 40 08          	mov    0x8(%rax),%rax
  401108:	8b 15 72 16 20 00    	mov    0x201672(%rip),%edx        # 602780 <node0>
  40110e:	39 10                	cmp    %edx,(%rax)
  401110:	74 05                	je     401117 <phase_6+0x3e>
  401112:	e8 26 05 00 00       	callq  40163d <explode_bomb>
  401117:	48 83 c4 08          	add    $0x8,%rsp
  40111b:	c3                   	retq   

000000000040111c <fun7>:
  40111c:	48 83 ec 08          	sub    $0x8,%rsp
  401120:	48 85 ff             	test   %rdi,%rdi
  401123:	74 2b                	je     401150 <fun7+0x34>
  401125:	8b 17                	mov    (%rdi),%edx
  401127:	39 f2                	cmp    %esi,%edx
  401129:	7e 0d                	jle    401138 <fun7+0x1c>
  40112b:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  40112f:	e8 e8 ff ff ff       	callq  40111c <fun7>
  401134:	01 c0                	add    %eax,%eax
  401136:	eb 1d                	jmp    401155 <fun7+0x39>
  401138:	b8 00 00 00 00       	mov    $0x0,%eax
  40113d:	39 f2                	cmp    %esi,%edx
  40113f:	74 14                	je     401155 <fun7+0x39>
  401141:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  401145:	e8 d2 ff ff ff       	callq  40111c <fun7>
  40114a:	8d 44 00 01          	lea    0x1(%rax,%rax,1),%eax
  40114e:	eb 05                	jmp    401155 <fun7+0x39>
  401150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  401155:	48 83 c4 08          	add    $0x8,%rsp
  401159:	c3                   	retq   

000000000040115a <secret_phase>:
  40115a:	53                   	push   %rbx
  40115b:	e8 ff 04 00 00       	callq  40165f <read_line>
  401160:	ba 0a 00 00 00       	mov    $0xa,%edx
  401165:	be 00 00 00 00       	mov    $0x0,%esi
  40116a:	48 89 c7             	mov    %rax,%rdi
  40116d:	e8 0e fa ff ff       	callq  400b80 <strtol@plt>
  401172:	89 c3                	mov    %eax,%ebx
  401174:	8d 43 ff             	lea    -0x1(%rbx),%eax
  401177:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  40117c:	76 05                	jbe    401183 <secret_phase+0x29>
  40117e:	e8 ba 04 00 00       	callq  40163d <explode_bomb>
  401183:	89 de                	mov    %ebx,%esi
  401185:	bf a0 25 60 00       	mov    $0x6025a0,%edi
  40118a:	e8 8d ff ff ff       	callq  40111c <fun7>
  40118f:	83 f8 03             	cmp    $0x3,%eax
  401192:	74 05                	je     401199 <secret_phase+0x3f>
  401194:	e8 a4 04 00 00       	callq  40163d <explode_bomb>
  401199:	bf 28 1b 40 00       	mov    $0x401b28,%edi
  40119e:	e8 fd f8 ff ff       	callq  400aa0 <puts@plt>
  4011a3:	e8 dd 05 00 00       	callq  401785 <phase_defused>
  4011a8:	5b                   	pop    %rbx
  4011a9:	c3                   	retq   
  4011aa:	90                   	nop
  4011ab:	90                   	nop
  4011ac:	90                   	nop
  4011ad:	90                   	nop
  4011ae:	90                   	nop
  4011af:	90                   	nop

00000000004011b0 <sig_handler>:
  4011b0:	48 83 ec 08          	sub    $0x8,%rsp
  4011b4:	bf e0 1b 40 00       	mov    $0x401be0,%edi
  4011b9:	e8 e2 f8 ff ff       	callq  400aa0 <puts@plt>
  4011be:	bf 03 00 00 00       	mov    $0x3,%edi
  4011c3:	e8 98 f9 ff ff       	callq  400b60 <sleep@plt>
  4011c8:	bf d8 1c 40 00       	mov    $0x401cd8,%edi
  4011cd:	b8 00 00 00 00       	mov    $0x0,%eax
  4011d2:	e8 99 f8 ff ff       	callq  400a70 <printf@plt>
  4011d7:	48 8b 3d 72 1a 20 00 	mov    0x201a72(%rip),%rdi        # 602c50 <stdout@@GLIBC_2.2.5>
  4011de:	e8 4d fa ff ff       	callq  400c30 <fflush@plt>
  4011e3:	bf 01 00 00 00       	mov    $0x1,%edi
  4011e8:	e8 73 f9 ff ff       	callq  400b60 <sleep@plt>
  4011ed:	bf e0 1c 40 00       	mov    $0x401ce0,%edi
  4011f2:	e8 a9 f8 ff ff       	callq  400aa0 <puts@plt>
  4011f7:	bf 10 00 00 00       	mov    $0x10,%edi
  4011fc:	e8 bf f8 ff ff       	callq  400ac0 <exit@plt>

0000000000401201 <invalid_phase>:
  401201:	48 83 ec 08          	sub    $0x8,%rsp
  401205:	48 89 fe             	mov    %rdi,%rsi
  401208:	bf e8 1c 40 00       	mov    $0x401ce8,%edi
  40120d:	b8 00 00 00 00       	mov    $0x0,%eax
  401212:	e8 59 f8 ff ff       	callq  400a70 <printf@plt>
  401217:	bf 08 00 00 00       	mov    $0x8,%edi
  40121c:	e8 9f f8 ff ff       	callq  400ac0 <exit@plt>

0000000000401221 <string_length>:
  401221:	b8 00 00 00 00       	mov    $0x0,%eax
  401226:	80 3f 00             	cmpb   $0x0,(%rdi)
  401229:	74 10                	je     40123b <string_length+0x1a>
  40122b:	48 89 fa             	mov    %rdi,%rdx
  40122e:	48 83 c2 01          	add    $0x1,%rdx
  401232:	89 d0                	mov    %edx,%eax
  401234:	29 f8                	sub    %edi,%eax
  401236:	80 3a 00             	cmpb   $0x0,(%rdx)
  401239:	75 f3                	jne    40122e <string_length+0xd>
  40123b:	f3 c3                	repz retq 

000000000040123d <strings_not_equal>:
  40123d:	48 89 5c 24 e8       	mov    %rbx,-0x18(%rsp)
  401242:	48 89 6c 24 f0       	mov    %rbp,-0x10(%rsp)
  401247:	4c 89 64 24 f8       	mov    %r12,-0x8(%rsp)
  40124c:	48 83 ec 18          	sub    $0x18,%rsp
  401250:	48 89 fb             	mov    %rdi,%rbx
  401253:	48 89 f5             	mov    %rsi,%rbp
  401256:	e8 c6 ff ff ff       	callq  401221 <string_length>
  40125b:	41 89 c4             	mov    %eax,%r12d
  40125e:	48 89 ef             	mov    %rbp,%rdi
  401261:	e8 bb ff ff ff       	callq  401221 <string_length>
  401266:	ba 01 00 00 00       	mov    $0x1,%edx
  40126b:	41 39 c4             	cmp    %eax,%r12d
  40126e:	75 36                	jne    4012a6 <strings_not_equal+0x69>
  401270:	0f b6 03             	movzbl (%rbx),%eax
  401273:	b2 00                	mov    $0x0,%dl
  401275:	84 c0                	test   %al,%al
  401277:	74 2d                	je     4012a6 <strings_not_equal+0x69>
  401279:	b2 01                	mov    $0x1,%dl
  40127b:	3a 45 00             	cmp    0x0(%rbp),%al
  40127e:	75 26                	jne    4012a6 <strings_not_equal+0x69>
  401280:	b8 00 00 00 00       	mov    $0x0,%eax
  401285:	eb 0a                	jmp    401291 <strings_not_equal+0x54>
  401287:	48 83 c0 01          	add    $0x1,%rax
  40128b:	3a 54 05 00          	cmp    0x0(%rbp,%rax,1),%dl
  40128f:	75 10                	jne    4012a1 <strings_not_equal+0x64>
  401291:	0f b6 54 03 01       	movzbl 0x1(%rbx,%rax,1),%edx
  401296:	84 d2                	test   %dl,%dl
  401298:	75 ed                	jne    401287 <strings_not_equal+0x4a>
  40129a:	ba 00 00 00 00       	mov    $0x0,%edx
  40129f:	eb 05                	jmp    4012a6 <strings_not_equal+0x69>
  4012a1:	ba 01 00 00 00       	mov    $0x1,%edx
  4012a6:	89 d0                	mov    %edx,%eax
  4012a8:	48 8b 1c 24          	mov    (%rsp),%rbx
  4012ac:	48 8b 6c 24 08       	mov    0x8(%rsp),%rbp
  4012b1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  4012b6:	48 83 c4 18          	add    $0x18,%rsp
  4012ba:	c3                   	retq   

00000000004012bb <open_clientfd>:
  4012bb:	48 89 5c 24 e8       	mov    %rbx,-0x18(%rsp)
  4012c0:	48 89 6c 24 f0       	mov    %rbp,-0x10(%rsp)
  4012c5:	4c 89 64 24 f8       	mov    %r12,-0x8(%rsp)
  4012ca:	48 83 ec 28          	sub    $0x28,%rsp
  4012ce:	48 89 fd             	mov    %rdi,%rbp
  4012d1:	41 89 f4             	mov    %esi,%r12d
  4012d4:	ba 00 00 00 00       	mov    $0x0,%edx
  4012d9:	be 01 00 00 00       	mov    $0x1,%esi
  4012de:	bf 02 00 00 00       	mov    $0x2,%edi
  4012e3:	e8 d8 f8 ff ff       	callq  400bc0 <socket@plt>
  4012e8:	89 c3                	mov    %eax,%ebx
  4012ea:	85 c0                	test   %eax,%eax
  4012ec:	79 14                	jns    401302 <open_clientfd+0x47>
  4012ee:	bf f9 1c 40 00       	mov    $0x401cf9,%edi
  4012f3:	e8 a8 f7 ff ff       	callq  400aa0 <puts@plt>
  4012f8:	bf 08 00 00 00       	mov    $0x8,%edi
  4012fd:	e8 be f7 ff ff       	callq  400ac0 <exit@plt>
  401302:	48 89 ef             	mov    %rbp,%rdi
  401305:	e8 86 f7 ff ff       	callq  400a90 <gethostbyname@plt>
  40130a:	48 85 c0             	test   %rax,%rax
  40130d:	75 14                	jne    401323 <open_clientfd+0x68>
  40130f:	bf 07 1d 40 00       	mov    $0x401d07,%edi
  401314:	e8 87 f7 ff ff       	callq  400aa0 <puts@plt>
  401319:	bf 08 00 00 00       	mov    $0x8,%edi
  40131e:	e8 9d f7 ff ff       	callq  400ac0 <exit@plt>
  401323:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  40132a:	00 
  40132b:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  401332:	00 00 
  401334:	66 c7 04 24 02 00    	movw   $0x2,(%rsp)
  40133a:	48 63 50 14          	movslq 0x14(%rax),%rdx
  40133e:	48 8d 74 24 04       	lea    0x4(%rsp),%rsi
  401343:	48 8b 40 18          	mov    0x18(%rax),%rax
  401347:	48 8b 38             	mov    (%rax),%rdi
  40134a:	e8 e1 f7 ff ff       	callq  400b30 <bcopy@plt>
  40134f:	66 41 c1 cc 08       	ror    $0x8,%r12w
  401354:	66 44 89 64 24 02    	mov    %r12w,0x2(%rsp)
  40135a:	ba 10 00 00 00       	mov    $0x10,%edx
  40135f:	48 89 e6             	mov    %rsp,%rsi
  401362:	89 df                	mov    %ebx,%edi
  401364:	e8 27 f8 ff ff       	callq  400b90 <connect@plt>
  401369:	85 c0                	test   %eax,%eax
  40136b:	79 14                	jns    401381 <open_clientfd+0xc6>
  40136d:	bf 15 1d 40 00       	mov    $0x401d15,%edi
  401372:	e8 29 f7 ff ff       	callq  400aa0 <puts@plt>
  401377:	bf 08 00 00 00       	mov    $0x8,%edi
  40137c:	e8 3f f7 ff ff       	callq  400ac0 <exit@plt>
  401381:	89 d8                	mov    %ebx,%eax
  401383:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  401388:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  40138d:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  401392:	48 83 c4 28          	add    $0x28,%rsp
  401396:	c3                   	retq   

0000000000401397 <initialize_bomb>:
  401397:	48 83 ec 08          	sub    $0x8,%rsp
  40139b:	be b0 11 40 00       	mov    $0x4011b0,%esi
  4013a0:	bf 02 00 00 00       	mov    $0x2,%edi
  4013a5:	e8 06 f8 ff ff       	callq  400bb0 <signal@plt>
  4013aa:	48 83 c4 08          	add    $0x8,%rsp
  4013ae:	c3                   	retq   

00000000004013af <blank_line>:
  4013af:	55                   	push   %rbp
  4013b0:	53                   	push   %rbx
  4013b1:	48 83 ec 08          	sub    $0x8,%rsp
  4013b5:	48 89 fd             	mov    %rdi,%rbp
  4013b8:	eb 17                	jmp    4013d1 <blank_line+0x22>
  4013ba:	e8 81 f7 ff ff       	callq  400b40 <__ctype_b_loc@plt>
  4013bf:	48 83 c5 01          	add    $0x1,%rbp
  4013c3:	48 0f be db          	movsbq %bl,%rbx
  4013c7:	48 8b 00             	mov    (%rax),%rax
  4013ca:	f6 44 58 01 20       	testb  $0x20,0x1(%rax,%rbx,2)
  4013cf:	74 0f                	je     4013e0 <blank_line+0x31>
  4013d1:	0f b6 5d 00          	movzbl 0x0(%rbp),%ebx
  4013d5:	84 db                	test   %bl,%bl
  4013d7:	75 e1                	jne    4013ba <blank_line+0xb>
  4013d9:	b8 01 00 00 00       	mov    $0x1,%eax
  4013de:	eb 05                	jmp    4013e5 <blank_line+0x36>
  4013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  4013e5:	48 83 c4 08          	add    $0x8,%rsp
  4013e9:	5b                   	pop    %rbx
  4013ea:	5d                   	pop    %rbp
  4013eb:	c3                   	retq   

00000000004013ec <skip>:
  4013ec:	53                   	push   %rbx
  4013ed:	48 63 05 8c 18 20 00 	movslq 0x20188c(%rip),%rax        # 602c80 <num_input_strings>
  4013f4:	48 8d 3c 80          	lea    (%rax,%rax,4),%rdi
  4013f8:	48 c1 e7 04          	shl    $0x4,%rdi
  4013fc:	48 81 c7 40 2f 60 00 	add    $0x602f40,%rdi
  401403:	48 8b 15 16 1b 20 00 	mov    0x201b16(%rip),%rdx        # 602f20 <infile>
  40140a:	be 50 00 00 00       	mov    $0x50,%esi
  40140f:	e8 fc f6 ff ff       	callq  400b10 <fgets@plt>
  401414:	48 89 c3             	mov    %rax,%rbx
  401417:	48 85 c0             	test   %rax,%rax
  40141a:	74 0c                	je     401428 <skip+0x3c>
  40141c:	48 89 c7             	mov    %rax,%rdi
  40141f:	e8 8b ff ff ff       	callq  4013af <blank_line>
  401424:	85 c0                	test   %eax,%eax
  401426:	75 c5                	jne    4013ed <skip+0x1>
  401428:	48 89 d8             	mov    %rbx,%rax
  40142b:	5b                   	pop    %rbx
  40142c:	c3                   	retq   

000000000040142d <send_msg>:
  40142d:	41 54                	push   %r12
  40142f:	55                   	push   %rbp
  401430:	53                   	push   %rbx
  401431:	48 83 ec 60          	sub    $0x60,%rsp
  401435:	89 fb                	mov    %edi,%ebx
  401437:	bf 00 00 00 00       	mov    $0x0,%edi
  40143c:	e8 af f6 ff ff       	callq  400af0 <dup@plt>
  401441:	41 89 c4             	mov    %eax,%r12d
  401444:	83 f8 ff             	cmp    $0xffffffffffffffff,%eax
  401447:	75 14                	jne    40145d <send_msg+0x30>
  401449:	bf 34 1d 40 00       	mov    $0x401d34,%edi
  40144e:	e8 4d f6 ff ff       	callq  400aa0 <puts@plt>
  401453:	bf 08 00 00 00       	mov    $0x8,%edi
  401458:	e8 63 f6 ff ff       	callq  400ac0 <exit@plt>
  40145d:	bf 00 00 00 00       	mov    $0x0,%edi
  401462:	e8 19 f6 ff ff       	callq  400a80 <close@plt>
  401467:	83 f8 ff             	cmp    $0xffffffffffffffff,%eax
  40146a:	75 14                	jne    401480 <send_msg+0x53>
  40146c:	bf 48 1d 40 00       	mov    $0x401d48,%edi
  401471:	e8 2a f6 ff ff       	callq  400aa0 <puts@plt>
  401476:	bf 08 00 00 00       	mov    $0x8,%edi
  40147b:	e8 40 f6 ff ff       	callq  400ac0 <exit@plt>
  401480:	e8 1b f7 ff ff       	callq  400ba0 <tmpfile@plt>
  401485:	48 89 c5             	mov    %rax,%rbp
  401488:	48 85 c0             	test   %rax,%rax
  40148b:	75 14                	jne    4014a1 <send_msg+0x74>
  40148d:	bf 5b 1d 40 00       	mov    $0x401d5b,%edi
  401492:	e8 09 f6 ff ff       	callq  400aa0 <puts@plt>
  401497:	bf 08 00 00 00       	mov    $0x8,%edi
  40149c:	e8 1f f6 ff ff       	callq  400ac0 <exit@plt>
  4014a1:	48 89 c1             	mov    %rax,%rcx
  4014a4:	ba 1b 00 00 00       	mov    $0x1b,%edx
  4014a9:	be 01 00 00 00       	mov    $0x1,%esi
  4014ae:	bf 70 1d 40 00       	mov    $0x401d70,%edi
  4014b3:	e8 58 f7 ff ff       	callq  400c10 <fwrite@plt>
  4014b8:	48 89 ee             	mov    %rbp,%rsi
  4014bb:	bf 0a 00 00 00       	mov    $0xa,%edi
  4014c0:	e8 5b f6 ff ff       	callq  400b20 <fputc@plt>
  4014c5:	bf 00 00 00 00       	mov    $0x0,%edi
  4014ca:	e8 11 f7 ff ff       	callq  400be0 <cuserid@plt>
  4014cf:	48 85 c0             	test   %rax,%rax
  4014d2:	75 16                	jne    4014ea <send_msg+0xbd>
  4014d4:	c7 44 24 10 6e 6f 62 	movl   $0x6f626f6e,0x10(%rsp)
  4014db:	6f 
  4014dc:	66 c7 44 24 14 64 79 	movw   $0x7964,0x14(%rsp)
  4014e3:	c6 44 24 16 00       	movb   $0x0,0x16(%rsp)
  4014e8:	eb 0d                	jmp    4014f7 <send_msg+0xca>
  4014ea:	48 89 c6             	mov    %rax,%rsi
  4014ed:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  4014f2:	e8 f9 f6 ff ff       	callq  400bf0 <strcpy@plt>
  4014f7:	85 db                	test   %ebx,%ebx
  4014f9:	b8 23 1d 40 00       	mov    $0x401d23,%eax
  4014fe:	41 b9 2b 1d 40 00    	mov    $0x401d2b,%r9d
  401504:	4c 0f 45 c8          	cmovne %rax,%r9
  401508:	8b 05 72 17 20 00    	mov    0x201772(%rip),%eax        # 602c80 <num_input_strings>
  40150e:	89 04 24             	mov    %eax,(%rsp)
  401511:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  401516:	8b 0d 04 17 20 00    	mov    0x201704(%rip),%ecx        # 602c20 <bomb_id>
  40151c:	ba 20 28 60 00       	mov    $0x602820,%edx
  401521:	be 8c 1d 40 00       	mov    $0x401d8c,%esi
  401526:	48 89 ef             	mov    %rbp,%rdi
  401529:	b8 00 00 00 00       	mov    $0x0,%eax
  40152e:	e8 ed f6 ff ff       	callq  400c20 <fprintf@plt>
  401533:	83 3d 46 17 20 00 00 	cmpl   $0x0,0x201746(%rip)        # 602c80 <num_input_strings>
  40153a:	7e 4a                	jle    401586 <send_msg+0x159>
  40153c:	bb 00 00 00 00       	mov    $0x0,%ebx
  401541:	48 63 c3             	movslq %ebx,%rax
  401544:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  401548:	48 c1 e0 04          	shl    $0x4,%rax
  40154c:	48 05 40 2f 60 00    	add    $0x602f40,%rax
  401552:	83 c3 01             	add    $0x1,%ebx
  401555:	48 89 04 24          	mov    %rax,(%rsp)
  401559:	41 89 d9             	mov    %ebx,%r9d
  40155c:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  401561:	8b 0d b9 16 20 00    	mov    0x2016b9(%rip),%ecx        # 602c20 <bomb_id>
  401567:	ba 20 28 60 00       	mov    $0x602820,%edx
  40156c:	be a8 1d 40 00       	mov    $0x401da8,%esi
  401571:	48 89 ef             	mov    %rbp,%rdi
  401574:	b8 00 00 00 00       	mov    $0x0,%eax
  401579:	e8 a2 f6 ff ff       	callq  400c20 <fprintf@plt>
  40157e:	39 1d fc 16 20 00    	cmp    %ebx,0x2016fc(%rip)        # 602c80 <num_input_strings>
  401584:	7f bb                	jg     401541 <send_msg+0x114>
  401586:	48 89 ef             	mov    %rbp,%rdi
  401589:	e8 e2 f5 ff ff       	callq  400b70 <rewind@plt>
  40158e:	41 b8 18 1c 40 00    	mov    $0x401c18,%r8d
  401594:	b9 c4 1d 40 00       	mov    $0x401dc4,%ecx
  401599:	ba c9 1d 40 00       	mov    $0x401dc9,%edx
  40159e:	be e0 1d 40 00       	mov    $0x401de0,%esi
  4015a3:	bf 80 35 60 00       	mov    $0x603580,%edi
  4015a8:	b8 00 00 00 00       	mov    $0x0,%eax
  4015ad:	e8 9e f5 ff ff       	callq  400b50 <sprintf@plt>
  4015b2:	bf 80 35 60 00       	mov    $0x603580,%edi
  4015b7:	e8 44 f5 ff ff       	callq  400b00 <system@plt>
  4015bc:	85 c0                	test   %eax,%eax
  4015be:	74 14                	je     4015d4 <send_msg+0x1a7>
  4015c0:	bf e9 1d 40 00       	mov    $0x401de9,%edi
  4015c5:	e8 d6 f4 ff ff       	callq  400aa0 <puts@plt>
  4015ca:	bf 08 00 00 00       	mov    $0x8,%edi
  4015cf:	e8 ec f4 ff ff       	callq  400ac0 <exit@plt>
  4015d4:	48 89 ef             	mov    %rbp,%rdi
  4015d7:	e8 24 f6 ff ff       	callq  400c00 <fclose@plt>
  4015dc:	85 c0                	test   %eax,%eax
  4015de:	74 14                	je     4015f4 <send_msg+0x1c7>
  4015e0:	bf 03 1e 40 00       	mov    $0x401e03,%edi
  4015e5:	e8 b6 f4 ff ff       	callq  400aa0 <puts@plt>
  4015ea:	bf 08 00 00 00       	mov    $0x8,%edi
  4015ef:	e8 cc f4 ff ff       	callq  400ac0 <exit@plt>
  4015f4:	44 89 e7             	mov    %r12d,%edi
  4015f7:	e8 f4 f4 ff ff       	callq  400af0 <dup@plt>
  4015fc:	85 c0                	test   %eax,%eax
  4015fe:	74 14                	je     401614 <send_msg+0x1e7>
  401600:	bf 1c 1e 40 00       	mov    $0x401e1c,%edi
  401605:	e8 96 f4 ff ff       	callq  400aa0 <puts@plt>
  40160a:	bf 08 00 00 00       	mov    $0x8,%edi
  40160f:	e8 ac f4 ff ff       	callq  400ac0 <exit@plt>
  401614:	44 89 e7             	mov    %r12d,%edi
  401617:	e8 64 f4 ff ff       	callq  400a80 <close@plt>
  40161c:	85 c0                	test   %eax,%eax
  40161e:	74 14                	je     401634 <send_msg+0x207>
  401620:	bf 37 1e 40 00       	mov    $0x401e37,%edi
  401625:	e8 76 f4 ff ff       	callq  400aa0 <puts@plt>
  40162a:	bf 08 00 00 00       	mov    $0x8,%edi
  40162f:	e8 8c f4 ff ff       	callq  400ac0 <exit@plt>
  401634:	48 83 c4 60          	add    $0x60,%rsp
  401638:	5b                   	pop    %rbx
  401639:	5d                   	pop    %rbp
  40163a:	41 5c                	pop    %r12
  40163c:	c3                   	retq   

000000000040163d <explode_bomb>:
  40163d:	48 83 ec 08          	sub    $0x8,%rsp
  401641:	bf 4e 1e 40 00       	mov    $0x401e4e,%edi
  401646:	e8 55 f4 ff ff       	callq  400aa0 <puts@plt>
  40164b:	bf 57 1e 40 00       	mov    $0x401e57,%edi
  401650:	e8 4b f4 ff ff       	callq  400aa0 <puts@plt>
  401655:	bf 08 00 00 00       	mov    $0x8,%edi
  40165a:	e8 61 f4 ff ff       	callq  400ac0 <exit@plt>

000000000040165f <read_line>:
  40165f:	48 83 ec 08          	sub    $0x8,%rsp
  401663:	b8 00 00 00 00       	mov    $0x0,%eax
  401668:	e8 7f fd ff ff       	callq  4013ec <skip>
  40166d:	48 85 c0             	test   %rax,%rax
  401670:	75 64                	jne    4016d6 <read_line+0x77>
  401672:	48 8b 05 c7 15 20 00 	mov    0x2015c7(%rip),%rax        # 602c40 <stdin@@GLIBC_2.2.5>
  401679:	48 39 05 a0 18 20 00 	cmp    %rax,0x2018a0(%rip)        # 602f20 <infile>
  401680:	75 0f                	jne    401691 <read_line+0x32>
  401682:	bf 6e 1e 40 00       	mov    $0x401e6e,%edi
  401687:	e8 14 f4 ff ff       	callq  400aa0 <puts@plt>
  40168c:	e8 ac ff ff ff       	callq  40163d <explode_bomb>
  401691:	bf 8c 1e 40 00       	mov    $0x401e8c,%edi
  401696:	e8 35 f5 ff ff       	callq  400bd0 <getenv@plt>
  40169b:	48 85 c0             	test   %rax,%rax
  40169e:	74 0a                	je     4016aa <read_line+0x4b>
  4016a0:	bf 00 00 00 00       	mov    $0x0,%edi
  4016a5:	e8 16 f4 ff ff       	callq  400ac0 <exit@plt>
  4016aa:	48 8b 05 8f 15 20 00 	mov    0x20158f(%rip),%rax        # 602c40 <stdin@@GLIBC_2.2.5>
  4016b1:	48 89 05 68 18 20 00 	mov    %rax,0x201868(%rip)        # 602f20 <infile>
  4016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  4016bd:	e8 2a fd ff ff       	callq  4013ec <skip>
  4016c2:	48 85 c0             	test   %rax,%rax
  4016c5:	75 0f                	jne    4016d6 <read_line+0x77>
  4016c7:	bf 6e 1e 40 00       	mov    $0x401e6e,%edi
  4016cc:	e8 cf f3 ff ff       	callq  400aa0 <puts@plt>
  4016d1:	e8 67 ff ff ff       	callq  40163d <explode_bomb>
  4016d6:	8b 15 a4 15 20 00    	mov    0x2015a4(%rip),%edx        # 602c80 <num_input_strings>
  4016dc:	48 63 c2             	movslq %edx,%rax
  4016df:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  4016e3:	48 c1 e6 04          	shl    $0x4,%rsi
  4016e7:	48 81 c6 40 2f 60 00 	add    $0x602f40,%rsi
  4016ee:	48 89 f7             	mov    %rsi,%rdi
  4016f1:	b8 00 00 00 00       	mov    $0x0,%eax
  4016f6:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  4016fd:	f2 ae                	repnz scas %es:(%rdi),%al
  4016ff:	48 f7 d1             	not    %rcx
  401702:	83 e9 01             	sub    $0x1,%ecx
  401705:	83 f9 4f             	cmp    $0x4f,%ecx
  401708:	75 0f                	jne    401719 <read_line+0xba>
  40170a:	bf 97 1e 40 00       	mov    $0x401e97,%edi
  40170f:	e8 8c f3 ff ff       	callq  400aa0 <puts@plt>
  401714:	e8 24 ff ff ff       	callq  40163d <explode_bomb>
  401719:	83 e9 01             	sub    $0x1,%ecx
  40171c:	48 63 c9             	movslq %ecx,%rcx
  40171f:	48 63 c2             	movslq %edx,%rax
  401722:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  401726:	48 c1 e0 04          	shl    $0x4,%rax
  40172a:	c6 84 01 40 2f 60 00 	movb   $0x0,0x602f40(%rcx,%rax,1)
  401731:	00 
  401732:	83 c2 01             	add    $0x1,%edx
  401735:	89 15 45 15 20 00    	mov    %edx,0x201545(%rip)        # 602c80 <num_input_strings>
  40173b:	48 89 f0             	mov    %rsi,%rax
  40173e:	48 83 c4 08          	add    $0x8,%rsp
  401742:	c3                   	retq   

0000000000401743 <read_six_numbers>:
  401743:	48 83 ec 18          	sub    $0x18,%rsp
  401747:	48 89 f2             	mov    %rsi,%rdx
  40174a:	48 8d 4e 04          	lea    0x4(%rsi),%rcx
  40174e:	48 8d 46 14          	lea    0x14(%rsi),%rax
  401752:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  401757:	48 8d 46 10          	lea    0x10(%rsi),%rax
  40175b:	48 89 04 24          	mov    %rax,(%rsp)
  40175f:	4c 8d 4e 0c          	lea    0xc(%rsi),%r9
  401763:	4c 8d 46 08          	lea    0x8(%rsi),%r8
  401767:	be b2 1e 40 00       	mov    $0x401eb2,%esi
  40176c:	b8 00 00 00 00       	mov    $0x0,%eax
  401771:	e8 3a f3 ff ff       	callq  400ab0 <__isoc99_sscanf@plt>
  401776:	83 f8 05             	cmp    $0x5,%eax
  401779:	7f 05                	jg     401780 <read_six_numbers+0x3d>
  40177b:	e8 bd fe ff ff       	callq  40163d <explode_bomb>
  401780:	48 83 c4 18          	add    $0x18,%rsp
  401784:	c3                   	retq   

0000000000401785 <phase_defused>:
  401785:	48 83 ec 68          	sub    $0x68,%rsp
  401789:	83 3d f0 14 20 00 06 	cmpl   $0x6,0x2014f0(%rip)        # 602c80 <num_input_strings>
  401790:	75 5e                	jne    4017f0 <phase_defused+0x6b>
  401792:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  401797:	48 8d 54 24 0c       	lea    0xc(%rsp),%rdx
  40179c:	be c4 1e 40 00       	mov    $0x401ec4,%esi
  4017a1:	bf 30 30 60 00       	mov    $0x603030,%edi
  4017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  4017ab:	e8 00 f3 ff ff       	callq  400ab0 <__isoc99_sscanf@plt>
  4017b0:	83 f8 02             	cmp    $0x2,%eax
  4017b3:	75 31                	jne    4017e6 <phase_defused+0x61>
  4017b5:	be ca 1e 40 00       	mov    $0x401eca,%esi
  4017ba:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  4017bf:	e8 79 fa ff ff       	callq  40123d <strings_not_equal>
  4017c4:	85 c0                	test   %eax,%eax
  4017c6:	75 1e                	jne    4017e6 <phase_defused+0x61>
  4017c8:	bf 40 1c 40 00       	mov    $0x401c40,%edi
  4017cd:	e8 ce f2 ff ff       	callq  400aa0 <puts@plt>
  4017d2:	bf 68 1c 40 00       	mov    $0x401c68,%edi
  4017d7:	e8 c4 f2 ff ff       	callq  400aa0 <puts@plt>
  4017dc:	b8 00 00 00 00       	mov    $0x0,%eax
  4017e1:	e8 74 f9 ff ff       	callq  40115a <secret_phase>
  4017e6:	bf a0 1c 40 00       	mov    $0x401ca0,%edi
  4017eb:	e8 b0 f2 ff ff       	callq  400aa0 <puts@plt>
  4017f0:	48 83 c4 68          	add    $0x68,%rsp
  4017f4:	c3                   	retq   
  4017f5:	90                   	nop
  4017f6:	90                   	nop
  4017f7:	90                   	nop
  4017f8:	90                   	nop
  4017f9:	90                   	nop
  4017fa:	90                   	nop
  4017fb:	90                   	nop
  4017fc:	90                   	nop
  4017fd:	90                   	nop
  4017fe:	90                   	nop
  4017ff:	90                   	nop

0000000000401800 <__libc_csu_init>:
  401800:	48 89 6c 24 d8       	mov    %rbp,-0x28(%rsp)
  401805:	4c 89 64 24 e0       	mov    %r12,-0x20(%rsp)
  40180a:	48 8d 2d ab 0a 20 00 	lea    0x200aab(%rip),%rbp        # 6022bc <__init_array_end>
  401811:	4c 8d 25 a4 0a 20 00 	lea    0x200aa4(%rip),%r12        # 6022bc <__init_array_end>
  401818:	4c 89 6c 24 e8       	mov    %r13,-0x18(%rsp)
  40181d:	4c 89 74 24 f0       	mov    %r14,-0x10(%rsp)
  401822:	4c 89 7c 24 f8       	mov    %r15,-0x8(%rsp)
  401827:	48 89 5c 24 d0       	mov    %rbx,-0x30(%rsp)
  40182c:	48 83 ec 38          	sub    $0x38,%rsp
  401830:	4c 29 e5             	sub    %r12,%rbp
  401833:	41 89 fd             	mov    %edi,%r13d
  401836:	49 89 f6             	mov    %rsi,%r14
  401839:	48 c1 fd 03          	sar    $0x3,%rbp
  40183d:	49 89 d7             	mov    %rdx,%r15
  401840:	e8 03 f2 ff ff       	callq  400a48 <_init>
  401845:	48 85 ed             	test   %rbp,%rbp
  401848:	74 1c                	je     401866 <__libc_csu_init+0x66>
  40184a:	31 db                	xor    %ebx,%ebx
  40184c:	0f 1f 40 00          	nopl   0x0(%rax)
  401850:	4c 89 fa             	mov    %r15,%rdx
  401853:	4c 89 f6             	mov    %r14,%rsi
  401856:	44 89 ef             	mov    %r13d,%edi
  401859:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  40185d:	48 83 c3 01          	add    $0x1,%rbx
  401861:	48 39 eb             	cmp    %rbp,%rbx
  401864:	75 ea                	jne    401850 <__libc_csu_init+0x50>
  401866:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  40186b:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  401870:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  401875:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  40187a:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  40187f:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
  401884:	48 83 c4 38          	add    $0x38,%rsp
  401888:	c3                   	retq   
  401889:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000401890 <__libc_csu_fini>:
  401890:	f3 c3                	repz retq 
  401892:	90                   	nop
  401893:	90                   	nop
  401894:	90                   	nop
  401895:	90                   	nop
  401896:	90                   	nop
  401897:	90                   	nop
  401898:	90                   	nop
  401899:	90                   	nop
  40189a:	90                   	nop
  40189b:	90                   	nop
  40189c:	90                   	nop
  40189d:	90                   	nop
  40189e:	90                   	nop
  40189f:	90                   	nop

00000000004018a0 <__do_global_ctors_aux>:
  4018a0:	55                   	push   %rbp
  4018a1:	48 89 e5             	mov    %rsp,%rbp
  4018a4:	53                   	push   %rbx
  4018a5:	48 83 ec 08          	sub    $0x8,%rsp
  4018a9:	48 8b 05 10 0a 20 00 	mov    0x200a10(%rip),%rax        # 6022c0 <__CTOR_LIST__>
  4018b0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4018b4:	74 19                	je     4018cf <__do_global_ctors_aux+0x2f>
  4018b6:	bb c0 22 60 00       	mov    $0x6022c0,%ebx
  4018bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  4018c0:	48 83 eb 08          	sub    $0x8,%rbx
  4018c4:	ff d0                	callq  *%rax
  4018c6:	48 8b 03             	mov    (%rbx),%rax
  4018c9:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  4018cd:	75 f1                	jne    4018c0 <__do_global_ctors_aux+0x20>
  4018cf:	48 83 c4 08          	add    $0x8,%rsp
  4018d3:	5b                   	pop    %rbx
  4018d4:	5d                   	pop    %rbp
  4018d5:	c3                   	retq   
  4018d6:	90                   	nop
  4018d7:	90                   	nop

Disassembly of section .fini:

00000000004018d8 <_fini>:
  4018d8:	48 83 ec 08          	sub    $0x8,%rsp
  4018dc:	e8 af f3 ff ff       	callq  400c90 <__do_global_dtors_aux>
  4018e1:	48 83 c4 08          	add    $0x8,%rsp
  4018e5:	c3                   	retq   
