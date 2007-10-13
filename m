Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXJMJzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXJMJzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXJMJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:55:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60971 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbXJMJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:55:34 -0400
Date: Sat, 13 Oct 2007 11:57:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: dontdiff update needed
Message-ID: <20071013095705.GA29008@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy.

I tried to do a simple find -name 'xxx'
where xxx was the file patters from dontdiff.
A suprisingly number of files showed up
in a clean kernel.

Ignoring all the .gitignore hits wc counted
58 matches (a few is false).

The list is below.
I did a git clean -d -x before executing the scripts som there
should be no output files present.

Something you could take a look at and minimize?

	Sam

./Documentation/logo.gif
./Documentation/sound/alsa/seq_oss.html
./Documentation/video4linux/API.html
./include/asm-x86/alternative-asm_64.i
./include/asm-x86/alternative-asm_32.i
./include/asm-x86/frame.i
./include/asm-x86/alternative-asm.i
./include/asm-um/frame.i
./include/asm-um/alternative-asm.i
./Documentation/cdrom/cdrom-standard.tex
.
./.git
./.mailmap
./COPYING
./CREDITS
./Documentation/isdn/CREDITS
./Documentation/usb/CREDITS
./drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
./drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
./drivers/scsi/aic7xxx_old/aic7xxx_reg.h
./drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
./drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
./drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
./drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
./drivers/scsi/aic7xxx/aicasm
./include/asm-cris/arch-v32/hwregs/asm
./include/asm-cris/arch-v32/hwregs/iop/asm
./.git/config
./drivers/message/i2o/config-osm.c
./drivers/char/defkeymap.c_shipped
./drivers/s390/char/defkeymap.c
./scripts/genksyms
./scripts/kconfig
./scripts/genksyms/keywords.c_shipped
./scripts/genksyms/lex.c_shipped
./scripts/kconfig/lxdialog
./arch/sh/tools/mach-types
./arch/arm/tools/mach-types
./include/asm-cris/arch-v32/offset.h
./include/asm-cris/arch-v10/offset.h
./scripts/genksyms/parse.c_shipped
./scripts/genksyms/parse.h_shipped
./.git/refs/tags
./include/linux/times.h
./arch/x86/math-emu/version.h
./include/xen/interface/version.h
./include/pcmcia/version.h
./include/sound/version.h
./include/linux/dvb/version.h
./drivers/net/cxgb3/version.h
./arch/m68k/kernel/vmlinux-sun3.lds
./arch/m68k/kernel/vmlinux-std.lds
./arch/h8300/boot/compressed/vmlinux.lds
./arch/x86/ia32/vsyscall.lds
./arch/powerpc/boot/zImage.lds.S
./arch/powerpc/boot/zImage.ps3.lds.S
./arch/powerpc/boot/zImage.coff.lds.S
./Documentation/powerpc/zImage_layout.txt
