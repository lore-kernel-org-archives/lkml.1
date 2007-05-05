Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXEEQT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXEEQT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXEEQTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:19:55 -0400
Received: from 67.106.77.56.ptr.us.xo.net ([67.106.77.56]:34196 "HELO
	mail.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755599AbXEEQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:19:47 -0400
X-Greylist: delayed 2800 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 12:19:47 EDT
Message-ID: <20070505092558.joq9kbhn284sc00c@67.106.77.56>
Date: Sat, 05 May 2007 09:25:58 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org
Subject: git-tree compilation error "pci_module_init"
	[drivers/scsi/tmscsim.ko] undefined!
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pull 20070505 0830 UTC-06
...
scripts/kconfig/gconf arch/x86_64/Kconfig
drivers/net/Kconfig:2279:warning: 'select' used by config symbol  
'UCC_GETH' refer to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config  
symbol 'KEYBOARD_ATARI' refer to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:161:warning: 'select' used by config  
symbol 'MOUSE_ATARI' refer to undefined symbol 'ATARI_KBD_CORE'
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CHK     include/linux/compile.h
   MODPOST vmlinux
   Building modules, stage 2.
Kernel: arch/x86_64/boot/bzImage is ready  (#113)
   MODPOST 1234 modules
WARNING: "pci_module_init" [drivers/scsi/tmscsim.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


xboom

art@usfltd.com

