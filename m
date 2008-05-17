Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbYEQUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbYEQUgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbYEQUg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:36:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:45084 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYEQUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:36:27 -0400
Date: Sat, 17 May 2008 16:36:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Current list of includes of non-existent <linux/whatever.h>
 headers.
Message-ID: <alpine.LFD.1.10.0805171633520.5061@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since the merge activity is cooling off, here's a list of references
to <linux/whatever.h> headers that simply don't exist.  i've made no
attempt to cull the list based on semantic rationalization of any
kind.  enjoy.


=== Missing: include/linux/autoconf.h ===
arch/ia64/kvm/asm-offsets.c:#include <linux/autoconf.h>
drivers/accessibility/braille/braille_console.c:#include <linux/autoconf.h>
=== Missing: include/linux/blk.h ===
arch/frv/kernel/setup.c:#include <linux/blk.h>
=== Missing: include/linux/bounds.h ===
include/linux/mmzone.h:#include <linux/bounds.h>
include/linux/page-flags.h:#include <linux/bounds.h>
=== Missing: include/linux/cachefs.h ===
fs/afs/cache.h:#include <linux/cachefs.h>
=== Missing: include/linux/compile.h ===
arch/x86/boot/version.c:#include <linux/compile.h>
init/version.c:#include <linux/compile.h>
=== Missing: include/linux/debugger.h ===
arch/blackfin/kernel/kgdb.c:#include <linux/debugger.h>
=== Missing: include/linux/kdb.h ===
drivers/acpi/osl.c:#include <linux/kdb.h>
=== Missing: include/linux/l3/l3.h ===
sound/arm/sa11xx-uda1341.c:#include <linux/l3/l3.h>
sound/i2c/l3/uda1341.c:#include <linux/l3/l3.h>
=== Missing: include/linux/pkthook.h ===
arch/ppc/8xx_io/fec.c:#include <linux/pkthook.h>
=== Missing: include/linux/r4k-timer.h ===
arch/mips/kernel/sync-r4k.c:#include <linux/r4k-timer.h>
=== Missing: include/linux/serial_ip3106.h ===
arch/mips/nxp/pnx8550/common/gdb_hook.c:#include <linux/serial_ip3106.h>
=== Missing: include/linux/spi/tsc2102.h ===
arch/arm/mach-omap1/board-palmte.c:#include <linux/spi/tsc2102.h>
=== Missing: include/linux/squashfs_fs.h ===
arch/mips/pmc-sierra/msp71xx/msp_prom.c:#include <linux/squashfs_fs.h>
=== Missing: include/linux/tqueue.h ===
drivers/pcmcia/au1000_pb1x00.c:#include <linux/tqueue.h>
drivers/pcmcia/au1000_xxs1500.c:#include <linux/tqueue.h>
=== Missing: include/linux/usb/isp1362.h ===
arch/blackfin/mach-bf533/boards/cm_bf533.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/stamp.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/ip0x.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/H8606.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/ezkit.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf527/boards/ezkit.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/generic_board.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/stamp.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/cm_bf537.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/minotaur.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/pnav10.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf561/boards/cm_bf561.c:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf561/boards/ezkit.c:#include <linux/usb/isp1362.h>
=== Missing: include/linux/usb/musb.h ===
arch/arm/mach-omap2/usb-tusb6010.c:#include <linux/usb/musb.h>
arch/blackfin/mach-bf548/boards/cm_bf548.c:#include <linux/usb/musb.h>
arch/blackfin/mach-bf548/boards/ezkit.c:#include <linux/usb/musb.h>
arch/blackfin/mach-bf527/boards/ezkit.c:#include <linux/usb/musb.h>

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
