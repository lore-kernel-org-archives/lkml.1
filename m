Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYDWKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYDWKM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYDWKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:12:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5974 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDWKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZkhPihST6fbTXsn95baf5RozwlilEIymUZ6IXqNsrI0QYPqWpy09aZ45WnV/sJ/CNQcqBWXYeT8NdXgmXw8+c1xO5qwOOY2crrgFFtEctja071eIHKakO4ypCIGiiABEsucw0LQRYKMJsVaJg+x2COw72MB53OK0tPzO61jFRlA=
Subject: [PATCH] [Trivial] Update contact information
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 23 Apr 2008 12:10:33 +0200
Message-Id: <1208945433.4298.12.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I have changed my email address as well as the drivers/auxdisplay webpage, so this patch updates the contact information.

PS: If anyone has emailed me last weeks at maxextreme@gmail.com, please send again your message, I may have lost it. Sorry for the inconvenience.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

---
diff -uprN linux-2.6.25-o/CREDITS linux-2.6.25/CREDITS
--- linux-2.6.25-o/CREDITS	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/CREDITS	2008-04-21 17:54:39.000000000 +0200
@@ -2609,8 +2609,8 @@ S: Perth, Western Australia
 S: Australia
 
 N: Miguel Ojeda Sandonis
-E: maxextreme@gmail.com
-W: http://maxextreme.googlepages.com/
+E: miguel.ojeda.sandonis@gmail.com
+W: http://jair.lab.fi.uva.es/~migojed/
 D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
 D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
 S: C/ Mieses 20, 9-B
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b linux-2.6.25/Documentation/auxdisplay/cfag12864b
--- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/cfag12864b	2008-04-21 18:09:14.000000000 +0200
@@ -2,9 +2,9 @@
 	cfag12864b LCD Driver Documentation
 	===================================
 
-License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
-Date:			2006-10-27
+ License: GPLv2
+  Author: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+    Date: 2006-10-27
 
 
 
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c
--- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c	2008-04-21 18:08:45.000000000 +0200
@@ -4,7 +4,8 @@
  * Description: cfag12864b LCD userspace example program
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/ks0108 linux-2.6.25/Documentation/auxdisplay/ks0108
--- linux-2.6.25-o/Documentation/auxdisplay/ks0108	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/ks0108	2008-04-21 18:09:53.000000000 +0200
@@ -2,9 +2,9 @@
 	ks0108 LCD Controller Driver Documentation
 	==========================================
 
-License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
-Date:			2006-10-27
+ License: GPLv2
+  Author: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+    Date: 2006-10-27
 
 
 
diff -uprN linux-2.6.25-o/drivers/auxdisplay/cfag12864b.c linux-2.6.25/drivers/auxdisplay/cfag12864b.c
--- linux-2.6.25-o/drivers/auxdisplay/cfag12864b.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/cfag12864b.c	2008-04-21 18:16:08.000000000 +0200
@@ -5,7 +5,8 @@
  *     License: GPLv2
  *     Depends: ks0108
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -398,5 +399,5 @@ module_init(cfag12864b_init);
 module_exit(cfag12864b_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD driver");
diff -uprN linux-2.6.25-o/drivers/auxdisplay/cfag12864bfb.c linux-2.6.25/drivers/auxdisplay/cfag12864bfb.c
--- linux-2.6.25-o/drivers/auxdisplay/cfag12864bfb.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/cfag12864bfb.c	2008-04-21 18:16:18.000000000 +0200
@@ -5,7 +5,8 @@
  *     License: GPLv2
  *     Depends: cfag12864b
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -186,5 +187,5 @@ module_init(cfag12864bfb_init);
 module_exit(cfag12864bfb_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD framebuffer driver");
diff -uprN linux-2.6.25-o/drivers/auxdisplay/ks0108.c linux-2.6.25/drivers/auxdisplay/ks0108.c
--- linux-2.6.25-o/drivers/auxdisplay/ks0108.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/ks0108.c	2008-04-21 18:16:26.000000000 +0200
@@ -5,7 +5,8 @@
  *     License: GPLv2
  *     Depends: parport
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -173,6 +174,6 @@ module_init(ks0108_init);
 module_exit(ks0108_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("ks0108 LCD Controller driver");
 
diff -uprN linux-2.6.25-o/include/linux/cfag12864b.h linux-2.6.25/include/linux/cfag12864b.h
--- linux-2.6.25-o/include/linux/cfag12864b.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/include/linux/cfag12864b.h	2008-04-21 18:16:57.000000000 +0200
@@ -4,7 +4,8 @@
  * Description: cfag12864b LCD driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-12
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/include/linux/ks0108.h linux-2.6.25/include/linux/ks0108.h
--- linux-2.6.25-o/include/linux/ks0108.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/include/linux/ks0108.h	2008-04-21 18:16:44.000000000 +0200
@@ -4,7 +4,8 @@
  * Description: ks0108 LCD Controller driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *              <miguel.ojeda.sandonis@gmail.com>
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/MAINTAINERS linux-2.6.25/MAINTAINERS
--- linux-2.6.25-o/MAINTAINERS	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/MAINTAINERS	2008-04-21 17:53:47.000000000 +0200
@@ -750,9 +750,9 @@ S:	Maintained
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 AVR32 ARCHITECTURE
@@ -1050,16 +1050,16 @@ S:	Maintained
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFG80211 and NL80211
@@ -2333,9 +2333,9 @@ S:	Maintained
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 LAPB module


