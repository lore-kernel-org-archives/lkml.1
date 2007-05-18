Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXEROOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXEROOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXERON4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:13:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39900 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754561AbXERONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:13:54 -0400
Date: Fri, 18 May 2007 16:13:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [oops] in bluetooth
Message-ID: <20070518141342.GA3692@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I played with rfcomm here -- I'm trying to emulate bluetooth gps using
normal pc -- and got couple of oopses.

pavel@amd:~$ uname -a
Linux amd 2.6.21 #421 SMP Fri Apr 27 15:06:54 CEST 2007 i686 GNU/Linux
pavel@amd:~$



								Pavel


...
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SCSI device sdb: 3920896 512-byte hdwr sectors (2007 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
SCSI device sdb: 3920896 512-byte hdwr sectors (2007 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
 sdb: sdb1
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
usb 5-1: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:5-1
PM: Adding info for No Bus:usbdev5.3_ep00
usb 5-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-1:1.0
PM: Adding info for No Bus:hci0
PM: Adding info for No Bus:usbdev5.3_ep81
PM: Adding info for No Bus:usbdev5.3_ep82
PM: Adding info for No Bus:usbdev5.3_ep02
PM: Adding info for usb:5-1:1.1
PM: Adding info for No Bus:usbdev5.3_ep83
PM: Adding info for No Bus:usbdev5.3_ep03
PM: Adding info for usb:5-1:1.2
PM: Adding info for No Bus:usbdev5.3_ep84
PM: Adding info for No Bus:usbdev5.3_ep04
PM: Adding info for usb:5-1:1.3
PM: Adding info for No Bus:usbdev5.3
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl000A840045E3
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl000A840045E3
PM: Adding info for bluetooth:acl000C76AB309B
PM: Removing info for bluetooth:acl0001E34C01FC
hci_acldata_packet: hci0 ACL packet for unknown connection handle 13
hci_acldata_packet: hci0 ACL packet for unknown connection handle 13
hci_acldata_packet: hci0 ACL packet for unknown connection handle 13
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl000C76AB309B
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl000C76AB309B
hci_acldata_packet: hci0 ACL packet for unknown connection handle 12
hci_acldata_packet: hci0 ACL packet for unknown connection handle 12
hci_acldata_packet: hci0 ACL packet for unknown connection handle 12
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000A840045E3
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl000A840045E3
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl0001E34C01FC
PM: Removing info for bluetooth:acl0001E34C01FC
PM: Adding info for bluetooth:acl000C76AB309B
PM: Adding info for No Bus:rfcomm0
PM: Removing info for No Bus:rfcomm0
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000C76AB309B
PM: Adding info for No Bus:rfcomm0
PM: Removing info for No Bus:rfcomm0
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000C76AB309B
PM: Adding info for No Bus:rfcomm0
PM: Removing info for No Bus:rfcomm0
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000C76AB309B
PM: Adding info for No Bus:rfcomm0
PM: Removing info for No Bus:rfcomm0
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000C76AB309B
PM: Adding info for No Bus:rfcomm0
PM: Removing info for bluetooth:acl000C76AB309B
PM: Adding info for bluetooth:acl000C76AB309B
kobject_add failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
 [<c02547c1>] kobject_shadow_add+0x171/0x1d0
 [<c032c697>] device_add+0xc7/0x6e0
 [<c02543af>] kobject_get+0xf/0x20
 [<c0254b1f>] kobject_init+0x2f/0x50
 [<c032cd49>] device_create+0x89/0xc0
 [<c02db26b>] tty_register_device+0x5b/0xf0
 [<c0614c3f>] rfcomm_dev_ioctl+0x43f/0x5e0
 [<c0612dc9>] rfcomm_sock_ioctl+0x29/0x50
 [<c0556f2f>] sock_ioctl+0xaf/0x1d0
 [<c0556e80>] sock_ioctl+0x0/0x1d0
 [<c017d4eb>] do_ioctl+0x2b/0xa0
 [<c017d5bc>] vfs_ioctl+0x5c/0x2e0
 [<c017d87d>] sys_ioctl+0x3d/0x70
 [<c0104050>] syscall_call+0x7/0xb
 [<c0630000>] ieee80211_translate_scan+0x2f0/0xa90
 =======================
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000007f
 printing eip:
c02552d6
*pde = 00000000
BUG: soft lockup detected on CPU#1!
 [<c0150029>] softlockup_tick+0xa9/0xd0
 [<c0131f73>] update_process_times+0x33/0x80
 [<c01431a2>] tick_periodic+0x22/0x70
 [<c0143207>] tick_handle_periodic+0x17/0x80
 [<c011b95f>] smp_apic_timer_interrupt+0x4f/0x90
 [<c0104aa8>] apic_timer_interrupt+0x28/0x30
 [<c0258bc4>] delay_tsc+0x14/0x20
 [<c0258c06>] __delay+0x6/0x10
 [<c0120ebb>] do_page_fault+0x35b/0x600
 [<c0120b60>] do_page_fault+0x0/0x600
 [<c063840c>] error_code+0x7c/0x84
 [<c02552d6>] kref_get+0x6/0x50
 [<c06380c8>] _read_lock_bh+0x8/0x20
 [<c0608762>] hci_get_route+0x112/0x120
 [<c02543af>] kobject_get+0xf/0x20
 [<c032b94e>] get_device+0xe/0x20
 [<c032be5f>] device_move+0x1f/0x110
 [<c061462f>] rfcomm_tty_open+0x20f/0x240
 [<c0124eb0>] default_wake_function+0x0/0x10
 [<c02df02b>] tty_open+0x14b/0x2c0
 [<c01748ed>] chrdev_open+0xad/0x1a0
 [<c0174840>] chrdev_open+0x0/0x1a0
 [<c0171438>] __dentry_open+0xb8/0x1d0
 [<c0171605>] nameidata_to_filp+0x35/0x40
 [<c017165b>] do_filp_open+0x4b/0x60
 [<c016d91e>] cache_alloc_debugcheck_after+0x3e/0x150
 [<c0170ff2>] get_unused_fd+0x52/0xc0
 [<c01716ba>] do_sys_open+0x4a/0xe0
 [<c017178c>] sys_open+0x1c/0x20
 [<c0104050>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0150029>] softlockup_tick+0xa9/0xd0
 [<c0131f73>] update_process_times+0x33/0x80
 [<c01431a2>] tick_periodic+0x22/0x70
 [<c0143207>] tick_handle_periodic+0x17/0x80
 [<c01437ea>] tick_do_broadcast+0x6a/0x80
 [<c014381c>] tick_do_periodic_broadcast+0x1c/0x30
 [<c014384b>] tick_handle_periodic_broadcast+0x1b/0x60
 [<c01077cc>] timer_interrupt+0x2c/0x40
 [<c0150255>] handle_IRQ_event+0x25/0x60
 [<c0151fd7>] handle_edge_irq+0xe7/0x130
 [<c0106adb>] do_IRQ+0x3b/0x80
 [<c01049eb>] common_interrupt+0x23/0x28
 [<c063834e>] lock_kernel+0x1e/0x30
 [<c02dd08b>] tty_write+0x11b/0x1f0
 [<c02dfd90>] write_chan+0x0/0x320
 [<c0171c0c>] do_loop_readv_writev+0x6c/0x80
 [<c0172830>] do_readv_writev+0x170/0x180
 [<c02dcf70>] tty_write+0x0/0x1f0
 [<c01327c4>] do_gettimeofday+0x44/0x120
 [<c017287c>] vfs_writev+0x3c/0x60
 [<c01728e1>] sys_writev+0x41/0x70
 [<c0104050>] syscall_call+0x7/0xb
 =======================
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c02552d6>]    Not tainted VLI
EFLAGS: 00010286   (2.6.21 #421)
EIP is at kref_get+0x6/0x50
eax: 0000007f   ebx: 0000007f   ecx: f7b779c4   edx: 00000000
esi: f7ae8598   edi: e16abd58   ebp: ffffffea   esp: dfd8fe3c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rfcomm (pid: 3595, ti=dfd8e000 task=cc00b5b0 task.ti=dfd8e000)
Stack: c06380c8 e16abd24 c0608762 f7b779c4 00000067 c02543af e16abd24 c032b94e 
       c032be5f 00000000 e16abd24 f7ae851e e16abd58 f7ae8508 c061462f 00000001 
       f7b77ad8 e16abd52 e16abd4c 00000000 f7b77ad8 f7b779c4 00000000 cc00b5b0 
Call Trace:
 [<c06380c8>] _read_lock_bh+0x8/0x20
 [<c0608762>] hci_get_route+0x112/0x120
 [<c02543af>] kobject_get+0xf/0x20
 [<c032b94e>] get_device+0xe/0x20
 [<c032be5f>] device_move+0x1f/0x110
 [<c061462f>] rfcomm_tty_open+0x20f/0x240
 [<c0124eb0>] default_wake_function+0x0/0x10
 [<c02df02b>] tty_open+0x14b/0x2c0
 [<c01748ed>] chrdev_open+0xad/0x1a0
 [<c0174840>] chrdev_open+0x0/0x1a0
 [<c0171438>] __dentry_open+0xb8/0x1d0
 [<c0171605>] nameidata_to_filp+0x35/0x40
 [<c017165b>] do_filp_open+0x4b/0x60
 [<c016d91e>] cache_alloc_debugcheck_after+0x3e/0x150
 [<c0170ff2>] get_unused_fd+0x52/0xc0
 [<c01716ba>] do_sys_open+0x4a/0xe0
 [<c017178c>] sys_open+0x1c/0x20
 [<c0104050>] syscall_call+0x7/0xb
 =======================
Code: af 52 25 c0 e8 fc 5d 30 00 e9 23 fe ff ff 0f 0b eb fe 8d 76 00 31 c9 e9 19 fb ff ff 90 90 90 90 90 90 90 90 90 53 89 c3 83 ec 10 <8b> 00 85 c0 74 08 f0 ff 03 83 c4 10 5b c3 b9 04 77 64 c0 ba 20 
EIP: [<c02552d6>] kref_get+0x6/0x50 SS:ESP 0068:dfd8fe3c
BUG: unable to handle kernel paging request at virtual address 0008eb24
 printing eip:
c02552d6
*pde = 2922d067
BUG: soft lockup detected on CPU#0!
 [<c0150029>] softlockup_tick+0xa9/0xd0
 [<c0131f73>] update_process_times+0x33/0x80
 [<c01431a2>] tick_periodic+0x22/0x70
 [<c0143207>] tick_handle_periodic+0x17/0x80
 [<c01437ea>] tick_do_broadcast+0x6a/0x80
 [<c014381c>] tick_do_periodic_broadcast+0x1c/0x30
 [<c014384b>] tick_handle_periodic_broadcast+0x1b/0x60
 [<c01077cc>] timer_interrupt+0x2c/0x40
 [<c0150255>] handle_IRQ_event+0x25/0x60
 [<c0151fd7>] handle_edge_irq+0xe7/0x130
 [<c0106adb>] do_IRQ+0x3b/0x80
 [<c01049eb>] common_interrupt+0x23/0x28
 [<c063834e>] lock_kernel+0x1e/0x30
 [<c02dd276>] tty_read+0x76/0xd0
 [<c01723f1>] vfs_read+0xa1/0x130
 [<c02dd200>] tty_read+0x0/0xd0
 [<c0172d41>] sys_read+0x41/0x70
 [<c0104050>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#1!
 [<c0150029>] softlockup_tick+0xa9/0xd0
 [<c0131f73>] update_process_times+0x33/0x80
 [<c01431a2>] tick_periodic+0x22/0x70
 [<c0143207>] tick_handle_periodic+0x17/0x80
 [<c011b95f>] smp_apic_timer_interrupt+0x4f/0x90
 [<c0104aa8>] apic_timer_interrupt+0x28/0x30
 [<c019007b>] sys_vmsplice+0x26b/0x2d0
 [<c0258bc4>] delay_tsc+0x14/0x20
 [<c0258c06>] __delay+0x6/0x10
 [<c0120ebb>] do_page_fault+0x35b/0x600
 [<c0120b60>] do_page_fault+0x0/0x600
 [<c063840c>] error_code+0x7c/0x84
 [<c016007b>] unmap_mapping_range+0x14b/0x280
 [<c02552d6>] kref_get+0x6/0x50
 [<c016d029>] poison_obj+0x29/0x60
 [<c0104a18>] reschedule_interrupt+0x28/0x30
 [<c02543af>] kobject_get+0xf/0x20
 [<c02549f0>] kobject_move+0x30/0x130
 [<c01c00d8>] update_backups+0x98/0x270
 [<c032be91>] device_move+0x51/0x110
 [<c0614772>] rfcomm_tty_close+0x52/0x90
 [<c02de3b9>] release_dev+0x149/0x670
 [<c01031db>] __switch_to+0x14b/0x190
 [<c06360e4>] schedule+0x2e4/0x900
 [<c016d029>] poison_obj+0x29/0x60
 [<c02de8ef>] tty_release+0xf/0x20
 [<c01732c1>] __fput+0x91/0x160
 [<c0170747>] filp_close+0x47/0x90
 [<c0125886>] __cond_resched+0x16/0x30
 [<c012aef6>] put_files_struct+0x66/0xb0
 [<c012bead>] do_exit+0x11d/0x7b0
 [<c012c566>] do_group_exit+0x26/0x70
 [<c0135ed2>] get_signal_to_deliver+0x282/0x3e0
 [<c0103c3c>] do_notify_resume+0x3dc/0x6c4
 [<c02db084>] tty_ldisc_deref+0x44/0x70
 [<c02dd2a8>] tty_read+0xa8/0xd0
 [<c02e11e0>] read_chan+0x0/0x600
 [<c01723f1>] vfs_read+0xa1/0x130
 [<c02dd200>] tty_read+0x0/0xd0
 [<c0172d41>] sys_read+0x41/0x70
 [<c01040de>] work_notifysig+0x13/0x19
 =======================
*pte = 00000000
Oops: 0000 [#2]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c02552d6>]    Not tainted VLI
EFLAGS: 00010282   (2.6.21 #421)
EIP is at kref_get+0x6/0x50
eax: 0008eb24   ebx: 0008eb24   ecx: 0008eaf0   edx: 0008eb0c
esi: 00000067   edi: ffffffea   ebp: 0008eb0c   esp: c96dbd34
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cat (pid: 3589, ti=c96da000 task=c224b570 task.ti=c96da000)
Stack: 0005ba4c c016d029 6b000017 c0104a18 0008eb0c c02543af 0008eb0c c02549f0 
       e406c2a0 ffffffea ffffffef f788007b 0000007b c01c00d8 ffffffef 00000000 
       e406c2a0 0008eb0c c032be91 00000067 e16abd24 f762d344 e406c2a0 cac2711c 
Call Trace:
 [<c016d029>] poison_obj+0x29/0x60
 [<c0104a18>] reschedule_interrupt+0x28/0x30
 [<c02543af>] kobject_get+0xf/0x20
 [<c02549f0>] kobject_move+0x30/0x130
 [<c01c00d8>] update_backups+0x98/0x270
 [<c032be91>] device_move+0x51/0x110
 [<c0614772>] rfcomm_tty_close+0x52/0x90
 [<c02de3b9>] release_dev+0x149/0x670
 [<c01031db>] __switch_to+0x14b/0x190
 [<c06360e4>] schedule+0x2e4/0x900
 [<c016d029>] poison_obj+0x29/0x60
 [<c02de8ef>] tty_release+0xf/0x20
 [<c01732c1>] __fput+0x91/0x160
 [<c0170747>] filp_close+0x47/0x90
 [<c0125886>] __cond_resched+0x16/0x30
 [<c012aef6>] put_files_struct+0x66/0xb0
 [<c012bead>] do_exit+0x11d/0x7b0
 [<c012c566>] do_group_exit+0x26/0x70
 [<c0135ed2>] get_signal_to_deliver+0x282/0x3e0
 [<c0103c3c>] do_notify_resume+0x3dc/0x6c4
 [<c02db084>] tty_ldisc_deref+0x44/0x70
 [<c02dd2a8>] tty_read+0xa8/0xd0
 [<c02e11e0>] read_chan+0x0/0x600
 [<c01723f1>] vfs_read+0xa1/0x130
 [<c02dd200>] tty_read+0x0/0xd0
 [<c0172d41>] sys_read+0x41/0x70
 [<c01040de>] work_notifysig+0x13/0x19
 =======================
Code: af 52 25 c0 e8 fc 5d 30 00 e9 23 fe ff ff 0f 0b eb fe 8d 76 00 31 c9 e9 19 fb ff ff 90 90 90 90 90 90 90 90 90 53 89 c3 83 ec 10 <8b> 00 85 c0 74 08 f0 ff 03 83 c4 10 5b c3 b9 04 77 64 c0 ba 20 
EIP: [<c02552d6>] kref_get+0x6/0x50 SS:ESP 0068:c96dbd34
Fixing recursive fault but reboot is needed!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
