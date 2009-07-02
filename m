Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZGBPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZGBPrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZGBPr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:47:28 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:64969 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZGBPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:47:26 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 11:47:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=wFAK2AHNUbzM4sH/Cau2YtS94LkoQkVwu/rQAAhi7dbZBcEZHUVhQnF6HLfx++s4rH
         T3Pgjovj+TjPdoDVs7GBzwCDGD9+qv5y+0HtzEDBHCIN49E4nC/n3t5gDCjhjdMXEDwp
         I8adKIWMA/zNm9uor3J3I/hCW7TmKTFNckEDI=
Date: Fri, 3 Jul 2009 00:39:38 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: yuasa@linux-mips.org, linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] update Yoichi's e-mail addresses
Message-Id: <20090703003938.96316cd9.yuasa@linux-mips.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>

diff --git a/arch/mips/cobalt/buttons.c b/arch/mips/cobalt/buttons.c
index 9e14398..4eaec8b 100644
--- a/arch/mips/cobalt/buttons.c
+++ b/arch/mips/cobalt/buttons.c
@@ -1,7 +1,7 @@
 /*
  *  Cobalt buttons platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/lcd.c b/arch/mips/cobalt/lcd.c
index 0720e4f..0f1cd90 100644
--- a/arch/mips/cobalt/lcd.c
+++ b/arch/mips/cobalt/lcd.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of Cobalt LCD platform device.
  *
- *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/led.c b/arch/mips/cobalt/led.c
index 1c6ebd4..d3ce6fa 100644
--- a/arch/mips/cobalt/led.c
+++ b/arch/mips/cobalt/led.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of Cobalt LED platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/mtd.c b/arch/mips/cobalt/mtd.c
index 2b088ef..691d620 100644
--- a/arch/mips/cobalt/mtd.c
+++ b/arch/mips/cobalt/mtd.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of Cobalt MTD device.
  *
- *  Copyright (C) 2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2006  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/rtc.c b/arch/mips/cobalt/rtc.c
index e70794b..3ab3989 100644
--- a/arch/mips/cobalt/rtc.c
+++ b/arch/mips/cobalt/rtc.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of Cobalt RTC platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/serial.c b/arch/mips/cobalt/serial.c
index 53b8d0d..7cb51f5 100644
--- a/arch/mips/cobalt/serial.c
+++ b/arch/mips/cobalt/serial.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of Cobalt UART platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/cobalt/time.c b/arch/mips/cobalt/time.c
index 4a570e7..0162f9e 100644
--- a/arch/mips/cobalt/time.c
+++ b/arch/mips/cobalt/time.c
@@ -1,7 +1,7 @@
 /*
  *  Cobalt time initialization.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/gt64120/wrppmc/serial.c b/arch/mips/gt64120/wrppmc/serial.c
index 5ec1c2f..6f9d085 100644
--- a/arch/mips/gt64120/wrppmc/serial.c
+++ b/arch/mips/gt64120/wrppmc/serial.c
@@ -1,7 +1,7 @@
 /*
  *  Registration of WRPPMC UART platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/ds1287.h b/arch/mips/include/asm/ds1287.h
index ba1702e..3af0b8f 100644
--- a/arch/mips/include/asm/ds1287.h
+++ b/arch/mips/include/asm/ds1287.h
@@ -1,7 +1,7 @@
 /*
  *  DS1287 timer functions.
  *
- *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/irq_gt641xx.h b/arch/mips/include/asm/irq_gt641xx.h
index f9a7c3a..250a240 100644
--- a/arch/mips/include/asm/irq_gt641xx.h
+++ b/arch/mips/include/asm/irq_gt641xx.h
@@ -1,7 +1,7 @@
 /*
  *  Galileo/Marvell GT641xx IRQ definitions.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/mach-cobalt/irq.h b/arch/mips/include/asm/mach-cobalt/irq.h
index 57c8c9a..9da9acf 100644
--- a/arch/mips/include/asm/mach-cobalt/irq.h
+++ b/arch/mips/include/asm/mach-cobalt/irq.h
@@ -8,7 +8,7 @@
  * Copyright (C) 1997 Cobalt Microserver
  * Copyright (C) 1997, 2003 Ralf Baechle
  * Copyright (C) 2001-2003 Liam Davies (ldavies@agile.tv)
- * Copyright (C) 2007 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2007 Yoichi Yuasa <yuasa@linux-mips.org>
  */
 #ifndef _ASM_COBALT_IRQ_H
 #define _ASM_COBALT_IRQ_H
diff --git a/arch/mips/include/asm/mach-cobalt/mach-gt64120.h b/arch/mips/include/asm/mach-cobalt/mach-gt64120.h
index ae9c552..f8afec3 100644
--- a/arch/mips/include/asm/mach-cobalt/mach-gt64120.h
+++ b/arch/mips/include/asm/mach-cobalt/mach-gt64120.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2006  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/capcella.h b/arch/mips/include/asm/vr41xx/capcella.h
index e0ee05a..fcc6569 100644
--- a/arch/mips/include/asm/vr41xx/capcella.h
+++ b/arch/mips/include/asm/vr41xx/capcella.h
@@ -1,7 +1,7 @@
 /*
  *  capcella.h, Include file for ZAO Networks Capcella.
  *
- *  Copyright (C) 2002-2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/giu.h b/arch/mips/include/asm/vr41xx/giu.h
index b369c09..6a90bc1 100644
--- a/arch/mips/include/asm/vr41xx/giu.h
+++ b/arch/mips/include/asm/vr41xx/giu.h
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series General-purpose I/O Unit.
  *
- *  Copyright (C) 2005-2009  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2009  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/irq.h b/arch/mips/include/asm/vr41xx/irq.h
index d315dfb..b07f732 100644
--- a/arch/mips/include/asm/vr41xx/irq.h
+++ b/arch/mips/include/asm/vr41xx/irq.h
@@ -7,7 +7,7 @@
  * Copyright (C) 2001, 2002 Paul Mundt
  * Copyright (C) 2002 MontaVista Software, Inc.
  * Copyright (C) 2002 TimeSys Corp.
- * Copyright (C) 2003-2006 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2003-2006 Yoichi Yuasa <yuasa@linux-mips.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/arch/mips/include/asm/vr41xx/mpc30x.h b/arch/mips/include/asm/vr41xx/mpc30x.h
index 1d67df8..130d09d 100644
--- a/arch/mips/include/asm/vr41xx/mpc30x.h
+++ b/arch/mips/include/asm/vr41xx/mpc30x.h
@@ -1,7 +1,7 @@
 /*
  *  mpc30x.h, Include file for Victor MP-C303/304.
  *
- *  Copyright (C) 2002-2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/pci.h b/arch/mips/include/asm/vr41xx/pci.h
index 6fc01ce..c231a3d 100644
--- a/arch/mips/include/asm/vr41xx/pci.h
+++ b/arch/mips/include/asm/vr41xx/pci.h
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series PCI Control Unit.
  *
- *  Copyright (C) 2004-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2004-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/siu.h b/arch/mips/include/asm/vr41xx/siu.h
index da9f6e3..ca806bc 100644
--- a/arch/mips/include/asm/vr41xx/siu.h
+++ b/arch/mips/include/asm/vr41xx/siu.h
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2005-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/tb0219.h b/arch/mips/include/asm/vr41xx/tb0219.h
index dc981b4..c78e824 100644
--- a/arch/mips/include/asm/vr41xx/tb0219.h
+++ b/arch/mips/include/asm/vr41xx/tb0219.h
@@ -1,7 +1,7 @@
 /*
  *  tb0219.h, Include file for TANBAC TB0219.
  *
- *  Copyright (C) 2002-2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  Modified for TANBAC TB0219:
  *  Copyright (C) 2003 Megasolution Inc.  <matsu@megasolution.jp>
diff --git a/arch/mips/include/asm/vr41xx/tb0226.h b/arch/mips/include/asm/vr41xx/tb0226.h
index de527dc..36f5f79 100644
--- a/arch/mips/include/asm/vr41xx/tb0226.h
+++ b/arch/mips/include/asm/vr41xx/tb0226.h
@@ -1,7 +1,7 @@
 /*
  *  tb0226.h, Include file for TANBAC TB0226.
  *
- *  Copyright (C) 2002-2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/include/asm/vr41xx/vr41xx.h b/arch/mips/include/asm/vr41xx/vr41xx.h
index 22be649..7b96a43 100644
--- a/arch/mips/include/asm/vr41xx/vr41xx.h
+++ b/arch/mips/include/asm/vr41xx/vr41xx.h
@@ -7,7 +7,7 @@
  * Copyright (C) 2001, 2002 Paul Mundt
  * Copyright (C) 2002 MontaVista Software, Inc.
  * Copyright (C) 2002 TimeSys Corp.
- * Copyright (C) 2003-2008 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2003-2008 Yoichi Yuasa <yuasa@linux-mips.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/arch/mips/kernel/cevt-ds1287.c b/arch/mips/kernel/cevt-ds1287.c
index 1ada45e..6996da4 100644
--- a/arch/mips/kernel/cevt-ds1287.c
+++ b/arch/mips/kernel/cevt-ds1287.c
@@ -1,7 +1,7 @@
 /*
  *  DS1287 clockevent driver
  *
- *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/kernel/cevt-gt641xx.c b/arch/mips/kernel/cevt-gt641xx.c
index e9b787f..92351e0 100644
--- a/arch/mips/kernel/cevt-gt641xx.c
+++ b/arch/mips/kernel/cevt-gt641xx.c
@@ -1,7 +1,7 @@
 /*
  *  GT641xx clockevent routines.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/kernel/csrc-ioasic.c b/arch/mips/kernel/csrc-ioasic.c
index b551f48..23da108 100644
--- a/arch/mips/kernel/csrc-ioasic.c
+++ b/arch/mips/kernel/csrc-ioasic.c
@@ -1,7 +1,7 @@
 /*
  *  DEC I/O ASIC's counter clocksource
  *
- *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/kernel/irq-gt641xx.c b/arch/mips/kernel/irq-gt641xx.c
index 1b81b13..ebcc5f7 100644
--- a/arch/mips/kernel/irq-gt641xx.c
+++ b/arch/mips/kernel/irq-gt641xx.c
@@ -1,7 +1,7 @@
 /*
  *  GT641xx IRQ routines.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/fixup-capcella.c b/arch/mips/pci/fixup-capcella.c
index 1416bca..1c02f57 100644
--- a/arch/mips/pci/fixup-capcella.c
+++ b/arch/mips/pci/fixup-capcella.c
@@ -1,7 +1,7 @@
 /*
  *  fixup-cappcela.c, The ZAO Networks Capcella specific PCI fixups.
  *
- *  Copyright (C) 2002,2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002,2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/fixup-mpc30x.c b/arch/mips/pci/fixup-mpc30x.c
index 5911596..e08f49c 100644
--- a/arch/mips/pci/fixup-mpc30x.c
+++ b/arch/mips/pci/fixup-mpc30x.c
@@ -1,7 +1,7 @@
 /*
  *  fixup-mpc30x.c, The Victor MP-C303/304 specific PCI fixups.
  *
- *  Copyright (C) 2002,2004  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002,2004  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/fixup-tb0219.c b/arch/mips/pci/fixup-tb0219.c
index ed87733..8084b17 100644
--- a/arch/mips/pci/fixup-tb0219.c
+++ b/arch/mips/pci/fixup-tb0219.c
@@ -2,7 +2,7 @@
  *  fixup-tb0219.c, The TANBAC TB0219 specific PCI fixups.
  *
  *  Copyright (C) 2003  Megasolution Inc. <matsu@megasolution.jp>
- *  Copyright (C) 2004-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2004-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/fixup-tb0226.c b/arch/mips/pci/fixup-tb0226.c
index e3eedf4..4196ccf 100644
--- a/arch/mips/pci/fixup-tb0226.c
+++ b/arch/mips/pci/fixup-tb0226.c
@@ -1,7 +1,7 @@
 /*
  *  fixup-tb0226.c, The TANBAC TB0226 specific PCI fixups.
  *
- *  Copyright (C) 2002-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/fixup-tb0287.c b/arch/mips/pci/fixup-tb0287.c
index 267ab3d..2fe29db 100644
--- a/arch/mips/pci/fixup-tb0287.c
+++ b/arch/mips/pci/fixup-tb0287.c
@@ -1,7 +1,7 @@
 /*
  *  fixup-tb0287.c, The TANBAC TB0287 specific PCI fixups.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/pci/ops-vr41xx.c b/arch/mips/pci/ops-vr41xx.c
index 900c6b3..28962a7 100644
--- a/arch/mips/pci/ops-vr41xx.c
+++ b/arch/mips/pci/ops-vr41xx.c
@@ -2,8 +2,8 @@
  *  ops-vr41xx.c, PCI configuration routines for the PCIU of NEC VR4100 series.
  *
  *  Copyright (C) 2001-2003 MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copyright (C) 2004-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2004-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -21,7 +21,7 @@
  */
 /*
  * Changes:
- *  MontaVista Software Inc. <yyuasa@mvista.com> or <source@mvista.com>
+ *  MontaVista Software Inc. <source@mvista.com>
  *  - New creation, NEC VR4122 and VR4131 are supported.
  */
 #include <linux/pci.h>
diff --git a/arch/mips/pci/pci-vr41xx.c b/arch/mips/pci/pci-vr41xx.c
index d1e049b..5652571 100644
--- a/arch/mips/pci/pci-vr41xx.c
+++ b/arch/mips/pci/pci-vr41xx.c
@@ -2,8 +2,8 @@
  *  pci-vr41xx.c, PCI Control Unit routines for the NEC VR4100 series.
  *
  *  Copyright (C) 2001-2003 MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copyright (C) 2004-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2004-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *  Copyright (C) 2004 by Ralf Baechle (ralf@linux-mips.org)
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -22,7 +22,7 @@
  */
 /*
  * Changes:
- *  MontaVista Software Inc. <yyuasa@mvista.com> or <source@mvista.com>
+ *  MontaVista Software Inc. <source@mvista.com>
  *  - New creation, NEC VR4122 and VR4131 are supported.
  */
 #include <linux/init.h>
diff --git a/arch/mips/pci/pci-vr41xx.h b/arch/mips/pci/pci-vr41xx.h
index 8a35e32..6b1ae2e 100644
--- a/arch/mips/pci/pci-vr41xx.h
+++ b/arch/mips/pci/pci-vr41xx.h
@@ -2,8 +2,8 @@
  *  pci-vr41xx.h, Include file for PCI Control Unit of the NEC VR4100 series.
  *
  *  Copyright (C) 2002  MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copyright (C) 2004-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2004-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/casio-e55/setup.c b/arch/mips/vr41xx/casio-e55/setup.c
index 6d9bab8..719f4a5 100644
--- a/arch/mips/vr41xx/casio-e55/setup.c
+++ b/arch/mips/vr41xx/casio-e55/setup.c
@@ -1,7 +1,7 @@
 /*
  *  setup.c, Setup for the CASIO CASSIOPEIA E-11/15/55/65.
  *
- *  Copyright (C) 2002-2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2006  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/bcu.c b/arch/mips/vr41xx/common/bcu.c
index d77c330..6346c59 100644
--- a/arch/mips/vr41xx/common/bcu.c
+++ b/arch/mips/vr41xx/common/bcu.c
@@ -2,8 +2,8 @@
  *  bcu.c, Bus Control Unit routines for the NEC VR4100 series.
  *
  *  Copyright (C) 2002  MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com, or source@mvista.com>
- *  Copyright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2003-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -21,11 +21,11 @@
  */
 /*
  * Changes:
- *  MontaVista Software Inc. <yyuasa@mvista.com> or <source@mvista.com>
+ *  MontaVista Software Inc. <source@mvista.com>
  *  - New creation, NEC VR4122 and VR4131 are supported.
  *  - Added support for NEC VR4111 and VR4121.
  *
- *  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Yoichi Yuasa <yuasa@linux-mips.org>
  *  - Added support for NEC VR4133.
  */
 #include <linux/kernel.h>
diff --git a/arch/mips/vr41xx/common/cmu.c b/arch/mips/vr41xx/common/cmu.c
index ad0e8e3..8ba7d04 100644
--- a/arch/mips/vr41xx/common/cmu.c
+++ b/arch/mips/vr41xx/common/cmu.c
@@ -2,8 +2,8 @@
  *  cmu.c, Clock Mask Unit routines for the NEC VR4100 series.
  *
  *  Copyright (C) 2001-2002  MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copuright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copuright (C) 2003-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -21,11 +21,11 @@
  */
 /*
  * Changes:
- *  MontaVista Software Inc. <yyuasa@mvista.com> or <source@mvista.com>
+ *  MontaVista Software Inc. <source@mvista.com>
  *  - New creation, NEC VR4122 and VR4131 are supported.
  *  - Added support for NEC VR4111 and VR4121.
  *
- *  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Yoichi Yuasa <yuasa@linux-mips.org>
  *  - Added support for NEC VR4133.
  */
 #include <linux/init.h>
diff --git a/arch/mips/vr41xx/common/giu.c b/arch/mips/vr41xx/common/giu.c
index 2b272f1..22cc6f2 100644
--- a/arch/mips/vr41xx/common/giu.c
+++ b/arch/mips/vr41xx/common/giu.c
@@ -1,7 +1,7 @@
 /*
  *  NEC VR4100 series GIU platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 3f23d9f..6d39e22 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -2,8 +2,8 @@
  *  icu.c, Interrupt Control Unit routines for the NEC VR4100 series.
  *
  *  Copyright (C) 2001-2002  MontaVista Software Inc.
- *    Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copyright (C) 2003-2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *    Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2003-2006  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -21,11 +21,11 @@
  */
 /*
  * Changes:
- *  MontaVista Software Inc. <yyuasa@mvista.com> or <source@mvista.com>
+ *  MontaVista Software Inc. <source@mvista.com>
  *  - New creation, NEC VR4122 and VR4131 are supported.
  *  - Added support for NEC VR4111 and VR4121.
  *
- *  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Yoichi Yuasa <yuasa@linux-mips.org>
  *  - Coped with INTASSIGN of NEC VR4133.
  */
 #include <linux/errno.h>
diff --git a/arch/mips/vr41xx/common/init.c b/arch/mips/vr41xx/common/init.c
index c649953..1386e6f 100644
--- a/arch/mips/vr41xx/common/init.c
+++ b/arch/mips/vr41xx/common/init.c
@@ -1,7 +1,7 @@
 /*
  *  init.c, Common initialization routines for NEC VR4100 series.
  *
- *  Copyright (C) 2003-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index 9cc3891..bef0687 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -1,7 +1,7 @@
 /*
  *  Interrupt handing routines for NEC VR4100 series.
  *
- *  Copyright (C) 2005-2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/pmu.c b/arch/mips/vr41xx/common/pmu.c
index 028aaf7..692b4e8 100644
--- a/arch/mips/vr41xx/common/pmu.c
+++ b/arch/mips/vr41xx/common/pmu.c
@@ -1,7 +1,7 @@
 /*
  *  pmu.c, Power Management Unit routines for NEC VR4100 series.
  *
- *  Copyright (C) 2003-2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/rtc.c b/arch/mips/vr41xx/common/rtc.c
index 9f26c14..ebc5dcf 100644
--- a/arch/mips/vr41xx/common/rtc.c
+++ b/arch/mips/vr41xx/common/rtc.c
@@ -1,7 +1,7 @@
 /*
  *  NEC VR4100 series RTC platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/siu.c b/arch/mips/vr41xx/common/siu.c
index 654dee6..54eae56 100644
--- a/arch/mips/vr41xx/common/siu.c
+++ b/arch/mips/vr41xx/common/siu.c
@@ -1,7 +1,7 @@
 /*
  *  NEC VR4100 series SIU platform device.
  *
- *  Copyright (C) 2007-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/common/type.c b/arch/mips/vr41xx/common/type.c
index e0c1ac5..ff84142 100644
--- a/arch/mips/vr41xx/common/type.c
+++ b/arch/mips/vr41xx/common/type.c
@@ -1,7 +1,7 @@
 /*
  *  type.c, System type for NEC VR4100 series.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/arch/mips/vr41xx/ibm-workpad/setup.c b/arch/mips/vr41xx/ibm-workpad/setup.c
index 9eef297..3982f37 100644
--- a/arch/mips/vr41xx/ibm-workpad/setup.c
+++ b/arch/mips/vr41xx/ibm-workpad/setup.c
@@ -1,7 +1,7 @@
 /*
  *  setup.c, Setup for the IBM WorkPad z50.
  *
- *  Copyright (C) 2002-2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2002-2006  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/char/tb0219.c b/drivers/char/tb0219.c
index 6062b62..b3ec9b1 100644
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for TANBAC TB0219 base board.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -28,7 +28,7 @@
 #include <asm/vr41xx/giu.h>
 #include <asm/vr41xx/tb0219.h>
 
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_DESCRIPTION("TANBAC TB0219 base board driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index f691ffa..b70e061 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -2,8 +2,8 @@
  *  Driver for NEC VR4100 series General-purpose I/O Unit.
  *
  *  Copyright (C) 2002 MontaVista Software Inc.
- *	Author: Yoichi Yuasa <yyuasa@mvista.com or source@mvista.com>
- *  Copyright (C) 2003-2009  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *	Author: Yoichi Yuasa <source@mvista.com>
+ *  Copyright (C) 2003-2009  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -37,7 +37,7 @@
 #include <asm/vr41xx/irq.h>
 #include <asm/vr41xx/vr41xx.h>
 
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_DESCRIPTION("NEC VR4100 series General-purpose I/O Unit driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
index 2adf9cb..d114d3a 100644
--- a/drivers/input/misc/cobalt_btns.c
+++ b/drivers/input/misc/cobalt_btns.c
@@ -1,7 +1,7 @@
 /*
  *  Cobalt button interface driver.
  *
- *  Copyright (C) 2007-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -148,7 +148,7 @@ static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
 	return 0;
 }
 
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_DESCRIPTION("Cobalt button interface driver");
 MODULE_LICENSE("GPL");
 /* work with hotplug and coldplug */
diff --git a/drivers/leds/leds-cobalt-raq.c b/drivers/leds/leds-cobalt-raq.c
index ff0e8c3..5f1ce81 100644
--- a/drivers/leds/leds-cobalt-raq.c
+++ b/drivers/leds/leds-cobalt-raq.c
@@ -1,7 +1,7 @@
 /*
  *  LEDs driver for the Cobalt Raq series.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index 659421d..d4ad50d 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -1,7 +1,7 @@
 /*
  * vrc4171_card.c, NEC VRC4171 Card Controller driver for Socket Services.
  *
- * Copyright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2003-2005  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -32,7 +32,7 @@
 #include "i82365.h"
 
 MODULE_DESCRIPTION("NEC VRC4171 Card Controllers driver for Socket Services");
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_LICENSE("GPL");
 
 #define CARD_MAX_SLOTS		2
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index 812f038..9b3c158 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -6,7 +6,7 @@
  * 	NEC VRC4173 CARDU driver for Socket Services
  *	(This device doesn't support CardBus. it is supporting only 16bit PC Card.)
  *
- * Copyright 2002,2003 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright 2002,2003 Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the
@@ -41,7 +41,7 @@
 #include "vrc4173_cardu.h"
 
 MODULE_DESCRIPTION("NEC VRC4173 CARDU driver for Socket Services");
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_LICENSE("GPL");
 
 static int vrc4173_cardu_slots;
diff --git a/drivers/pcmcia/vrc4173_cardu.h b/drivers/pcmcia/vrc4173_cardu.h
index 7d77c74..a7d9601 100644
--- a/drivers/pcmcia/vrc4173_cardu.h
+++ b/drivers/pcmcia/vrc4173_cardu.h
@@ -5,7 +5,7 @@
  * BRIEF MODULE DESCRIPTION
  *	Include file for NEC VRC4173 CARDU.
  *
- * Copyright 2002 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright 2002 Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index f11297a..2c839d0 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for NEC VR4100 series Real Time Clock unit.
  *
- *  Copyright (C) 2003-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -33,7 +33,7 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
+MODULE_AUTHOR("Yoichi Yuasa <yuasa@linux-mips.org>");
 MODULE_DESCRIPTION("NEC VR4100 series RTC driver");
 MODULE_LICENSE("GPL v2");
 
diff --git a/drivers/serial/vr41xx_siu.c b/drivers/serial/vr41xx_siu.c
index 0573f3b..dac550e 100644
--- a/drivers/serial/vr41xx_siu.c
+++ b/drivers/serial/vr41xx_siu.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2004-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2004-2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  Based on drivers/serial/8250.c, by Russell King.
  *
diff --git a/drivers/video/cobalt_lcdfb.c b/drivers/video/cobalt_lcdfb.c
index 7bad24e..108b89e 100644
--- a/drivers/video/cobalt_lcdfb.c
+++ b/drivers/video/cobalt_lcdfb.c
@@ -1,7 +1,7 @@
 /*
  *  Cobalt server LCD frame buffer driver.
  *
- *  Copyright (C) 2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2008  Yoichi Yuasa <yuasa@linux-mips.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
