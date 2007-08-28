Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXH1QBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXH1QBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXH1QAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:00:52 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47746 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXH1QAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:00:50 -0400
Message-id: <7515194658758617@pripojeni.net>
In-reply-to: <2713029743177393055@pripojeni.net>
Subject: [PATCH 4/5] Net: ath5k, license is GPLv2
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Tue, 28 Aug 2007 12:00:50 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, license is GPLv2

The files are available only under GPLv2 since now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 330c2ab9a53ddce27003218bd546034e8eeeff17
tree b24cecd991fbe3046d5c5269c61e0090427e4fd3
parent ceeaf6b9aac9daaa41ec38fbba3d2c1972af4470
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:27:51 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:27:51 +0200

 drivers/net/wireless/ath5k.h        |   12 +-----------
 drivers/net/wireless/ath5k_base.c   |   22 +++-------------------
 drivers/net/wireless/ath5k_base.h   |   33 +--------------------------------
 drivers/net/wireless/ath5k_hw.c     |   13 +------------
 drivers/net/wireless/ath5k_hw.h     |   12 +-----------
 drivers/net/wireless/ath5k_reg.h    |   31 +------------------------------
 drivers/net/wireless/ath5k_regdom.c |    4 +---
 drivers/net/wireless/ath5k_regdom.h |    4 +---
 8 files changed, 10 insertions(+), 121 deletions(-)

diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k.h
index 0c6f3f5..c76b97b 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k.h
@@ -2,17 +2,7 @@
  * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
  *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ * This file is released under GPLv2
  */
 
 #ifndef _ATH5K_H
diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k_base.c
index 5ee36b5..8703988 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k_base.c
@@ -4,25 +4,9 @@
  * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
  * All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce at minimum a disclaimer
- *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
- *    redistribution must be conditioned upon including a substantially
- *    similar Disclaimer requirement for further binary redistribution.
- * 3. Neither the names of the above-listed copyright holders nor the names
- *    of any contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * Alternatively, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") version 2 as published by the Free
- * Software Foundation.
- *
+ * This file is released under GPLv2
  */
+
 #define	ATH_PCI_VERSION	"0.9.5.0-BSD"
 
 #include <linux/version.h>
@@ -2530,5 +2514,5 @@ module_exit(exit_ath_pci);
 MODULE_AUTHOR("Jiri Slaby");
 MODULE_DESCRIPTION("Support for Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros WLAN cards");
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(ATH_PCI_VERSION " (EXPERIMENTAL)");
diff --git a/drivers/net/wireless/ath5k_base.h b/drivers/net/wireless/ath5k_base.h
index 15560ad..aa07dfb 100644
--- a/drivers/net/wireless/ath5k_base.h
+++ b/drivers/net/wireless/ath5k_base.h
@@ -2,38 +2,7 @@
  * Copyright (c) 2002-2007 Sam Leffler, Errno Consulting
  * All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce at minimum a disclaimer
- *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
- *    redistribution must be conditioned upon including a substantially
- *    similar Disclaimer requirement for further binary redistribution.
- * 3. Neither the names of the above-listed copyright holders nor the names
- *    of any contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * Alternatively, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") version 2 as published by the Free
- * Software Foundation.
- *
- * NO WARRANTY
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF NONINFRINGEMENT, MERCHANTIBILITY
- * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
- * THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY,
- * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
- * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
- * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
- * THE POSSIBILITY OF SUCH DAMAGES.
- *
- * $FreeBSD: src/sys/dev/ath/if_athvar.h,v 1.20 2005/01/24 20:31:24 sam Exp $
+ * This file is released under GPLv2
  */
 
 /*
diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k_hw.c
index a15aa21..3c44179 100644
--- a/drivers/net/wireless/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k_hw.c
@@ -3,18 +3,7 @@
  * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
  * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- *
+ * This file is released under GPLv2
  */
 
 /*
diff --git a/drivers/net/wireless/ath5k_hw.h b/drivers/net/wireless/ath5k_hw.h
index 55ae849..3d24d48 100644
--- a/drivers/net/wireless/ath5k_hw.h
+++ b/drivers/net/wireless/ath5k_hw.h
@@ -2,17 +2,7 @@
  * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
  *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ * This file is released under GPLv2
  */
 
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/ath5k_reg.h b/drivers/net/wireless/ath5k_reg.h
index c6142d2..870efa1 100644
--- a/drivers/net/wireless/ath5k_reg.h
+++ b/drivers/net/wireless/ath5k_reg.h
@@ -2,36 +2,7 @@
  * Copyright (c) 2007 Nick Kossifidis <mickflemm@gmail.com>
  * All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer,
- *    without modification.
- * 2. Redistributions in binary form must reproduce at minimum a disclaimer
- *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
- *    redistribution must be conditioned upon including a substantially
- *    similar Disclaimer requirement for further binary redistribution.
- * 3. Neither the names of the above-listed copyright holders nor the names
- *    of any contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * Alternatively, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") version 2 as published by the Free
- * Software Foundation.
- *
- * NO WARRANTY
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF NONINFRINGEMENT, MERCHANTIBILITY
- * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
- * THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY,
- * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
- * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
- * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
- * THE POSSIBILITY OF SUCH DAMAGES.
+ * This file is released under GPLv2
  */
 
 /*
diff --git a/drivers/net/wireless/ath5k_regdom.c b/drivers/net/wireless/ath5k_regdom.c
index c345da8..067c837 100644
--- a/drivers/net/wireless/ath5k_regdom.c
+++ b/drivers/net/wireless/ath5k_regdom.c
@@ -1,9 +1,7 @@
 /*
  * Copyright (c) 2004, 2005 Reyk Floeter <reyk@vantronix.net>
  *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
+ * This file is released under GPLv2
  */
 
 /*
diff --git a/drivers/net/wireless/ath5k_regdom.h b/drivers/net/wireless/ath5k_regdom.h
index ebaeabe..d36bec6 100644
--- a/drivers/net/wireless/ath5k_regdom.h
+++ b/drivers/net/wireless/ath5k_regdom.h
@@ -1,9 +1,7 @@
 /*
  * Copyright (c) 2004, 2005 Reyk Floeter <reyk@openbsd.org>
  *
- * Permission to use, copy, modify, and distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
+ * This file is released under GPLv2
  */
 
 #ifndef _IEEE80211_REGDOMAIN_H_
