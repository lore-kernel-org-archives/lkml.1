Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793Ab0A1Pxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0A1Pxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524Ab0A1Pxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:53:44 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34977 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0A1Pxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:53:44 -0500
Message-ID: <4B61B287.5010801@vflare.org>
Date: Thu, 28 Jan 2010 21:21:35 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] Update copyright notice
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update copyright notice.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c   |    2 +-
 drivers/staging/ramzswap/ramzswap_drv.h   |    2 +-
 drivers/staging/ramzswap/ramzswap_ioctl.h |    2 +-
 drivers/staging/ramzswap/xvmalloc.c       |    2 +-
 drivers/staging/ramzswap/xvmalloc.h       |    2 +-
 drivers/staging/ramzswap/xvmalloc_int.h   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 1bca069..5e422e2 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/ramzswap/ramzswap_drv.h
index 5b67222..c7e0e76 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.h
+++ b/drivers/staging/ramzswap/ramzswap_drv.h
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/ramzswap/ramzswap_ioctl.h
index 1edaeba..d26076d 100644
--- a/drivers/staging/ramzswap/ramzswap_ioctl.h
+++ b/drivers/staging/ramzswap/ramzswap_ioctl.h
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc.c b/drivers/staging/ramzswap/xvmalloc.c
index dabd266..3fdbb8a 100644
--- a/drivers/staging/ramzswap/xvmalloc.c
+++ b/drivers/staging/ramzswap/xvmalloc.c
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc.h b/drivers/staging/ramzswap/xvmalloc.h
index 010c6fe..5b1a81a 100644
--- a/drivers/staging/ramzswap/xvmalloc.h
+++ b/drivers/staging/ramzswap/xvmalloc.h
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc_int.h b/drivers/staging/ramzswap/xvmalloc_int.h
index 263c72d..e23ed5c 100644
--- a/drivers/staging/ramzswap/xvmalloc_int.h
+++ b/drivers/staging/ramzswap/xvmalloc_int.h
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
--
1.6.2.5


