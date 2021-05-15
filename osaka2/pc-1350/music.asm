;modified for the AS61860 assembler by Robert van Engelen:
;https://shop-pdp.net/ashtml/asmlnk.htm

.area	play (REL)

;	.org 0x88b5		; PC-1403 0x88b5

plist:
	.dw ptn0		; PC-1403 0x88b9
	.dw ptn1		; PC-1403 0x8a3a
	.db 0x00

ptn0:
	.db 0x19,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x1a,0x14,0xe
	.db 0x18,0x11,0xf
	.db 0x18,0xd,0x10
	.db 0x18,0xb,0x11
	.db 0x19,0x2d,0x12
	.db 0x18,0x2d,0x13
	.db 0x18,0x2d,0x14
	.db 0x18,0x2d,0x14
	.db 0x19,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x19,0x24,0x14
	.db 0x18,0x24,0x14
	.db 0x1a,0x22,0xff
	.db 0x18,0x22,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x19,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x19,0xff,0x11
	.db 0x18,0xff,0x11
	.db 0x19,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0x10
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x1a,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0x10
	.db 0x19,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x19,0x1b,0xf
	.db 0x18,0x1b,0xf
	.db 0x18,0xff,0xf
	.db 0x18,0xff,0x10
	.db 0x19,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x1a,0x1e,0x11
	.db 0x18,0x1e,0x11
	.db 0x18,0x1e,0xf
	.db 0x18,0x1e,0xf
	.db 0x19,0x22,0xf
	.db 0x18,0x22,0xe
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x19,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x1a,0xff,0x12
	.db 0x18,0xff,0x13
	.db 0x18,0xff,0x13
	.db 0x18,0xff,0x14
	.db 0x19,0x2d,0x14
	.db 0x18,0x2d,0x14
	.db 0x18,0x2d,0x14
	.db 0x18,0x2d,0x14
	.db 0x19,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x19,0x24,0x14
	.db 0x18,0x24,0x14
	.db 0x19,0x22,0x14
	.db 0x18,0x22,0x14
	.db 0x1a,0xd,0x14
	.db 0x18,0xd,0x14
	.db 0x18,0xd,0x14
	.db 0x18,0xd,0x14
	.db 0x18,0xf,0x14
	.db 0x18,0xf,0x14
	.db 0x19,0xf,0x14
	.db 0x18,0xf,0x14
	.db 0x19,0x1b,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x12,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x1b,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x12,0xf
	.db 0x18,0x16,0xf
	.db 0x1a,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x19,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x19,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xe
	.db 0x18,0x16,0xf
	.db 0x19,0x18,0x10
	.db 0x18,0x19,0x11
	.db 0x19,0x1b,0x13
	.db 0x18,0x1e,0x14
	.db 0x1a,0x1e,0xff
	.db 0x18,0xff,0xff
	.db 0x19,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0x35,0xff
	.db 0x18,0x32,0xff
	.db 0x18,0x30,0xff
	.db 0x18,0x2d,0xff
	.db 0xff

ptn1:
	.db 0x19,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x18,0x28,0xd
	.db 0x1a,0x14,0xe
	.db 0x18,0x11,0xf
	.db 0x18,0xd,0x10
	.db 0x18,0xb,0x11
	.db 0x19,0x2d,0x12
	.db 0x18,0x2d,0x13
	.db 0x18,0x2d,0x14
	.db 0x18,0x2d,0x14
	.db 0x19,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x14
	.db 0x19,0x24,0x14
	.db 0x18,0x24,0x14
	.db 0x1a,0x22,0xff
	.db 0x18,0x22,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x18,0xff,0xff
	.db 0x1b,0xff,0xff
	.db 0x19,0xff,0xff
	.db 0x19,0xff,0xff
	.db 0x19,0x18,0x10
	.db 0x19,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0x10
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x1a,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0x10
	.db 0x19,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x18,0x35,0x11
	.db 0x19,0x1b,0xf
	.db 0x18,0x1b,0xf
	.db 0x18,0xff,0xf
	.db 0x18,0xff,0x10
	.db 0x19,0x1b,0x11
	.db 0x18,0x1b,0x11
	.db 0x1a,0x1e,0x11
	.db 0x18,0x1e,0x11
	.db 0x18,0x1e,0xf
	.db 0x18,0x1e,0xf
	.db 0x19,0x22,0xf
	.db 0x18,0x22,0xe
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x18,0x24,0xd
	.db 0x19,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x11
	.db 0x1a,0xff,0x11
	.db 0x18,0xff,0x11
	.db 0x18,0xff,0x11
	.db 0x18,0xff,0x11
	.db 0x19,0x2d,0x11
	.db 0x18,0x2d,0x14
	.db 0x18,0x2d,0x11
	.db 0x18,0x2d,0x14
	.db 0x19,0x28,0x11
	.db 0x18,0x28,0x14
	.db 0x18,0x28,0x11
	.db 0x18,0x28,0x14
	.db 0x19,0x24,0x11
	.db 0x18,0x24,0x14
	.db 0x19,0x22,0x11
	.db 0x18,0x22,0x14
	.db 0x1a,0xd,0x11
	.db 0x18,0xd,0x16
	.db 0x18,0xd,0x11
	.db 0x18,0xd,0x14
	.db 0x18,0xf,0x11
	.db 0x18,0xf,0x14
	.db 0x19,0xf,0x11
	.db 0x18,0xf,0x14
	.db 0x19,0x1b,0xf
	.db 0x18,0x16,0x14
	.db 0x18,0x12,0xf
	.db 0x18,0xa,0xff
	.db 0x18,0x1b,0xf
	.db 0x18,0x16,0x14
	.db 0x18,0x12,0xf
	.db 0x18,0xb,0x14
	.db 0x1a,0x35,0xf
	.db 0x18,0x35,0x16
	.db 0x18,0x35,0xf
	.db 0x18,0x35,0x16
	.db 0x19,0x1b,0xf
	.db 0x18,0x1b,0x16
	.db 0x18,0x1b,0xf
	.db 0x18,0x1b,0x16
	.db 0x19,0x32,0xf
	.db 0x18,0x32,0x16
	.db 0x18,0x32,0xf
	.db 0x18,0x32,0x16
	.db 0x19,0x19,0xf
	.db 0x18,0x19,0x16
	.db 0x19,0x19,0xf
	.db 0x18,0x19,0x16
	.db 0x1a,0x2d,0xf
	.db 0x18,0x2d,0x16
	.db 0x19,0x2d,0xf
	.db 0x18,0x2d,0x16
	.db 0x18,0x16,0xf
	.db 0x18,0x16,0x16
	.db 0x1a,0x16,0xf
	.db 0x18,0x16,0x16
	.db 0xff
