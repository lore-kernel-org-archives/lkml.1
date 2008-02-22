Return-Path: <linux-kernel-owner+w=401wt.eu-S934339AbYBVUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339AbYBVUKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934881AbYBVUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:09:40 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:44565 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863AbYBVUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:09:38 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 20/21] Char: moxa, update credits
Date: Fri, 22 Feb 2008 21:09:34 +0100
Message-Id: <1203710975-24675-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- update version
- update maintainers
- copyright the stuff

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 MAINTAINERS         |    2 +-
 drivers/char/moxa.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5dd270f..4aec40b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2707,7 +2707,7 @@ M:	rubini@ipvvis.unipv.it
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-MOXA SMARTIO/INDUSTIO SERIAL CARD (MXSER 2.0)
+MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 4d595db..3c248bb 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -2,7 +2,8 @@
 /*
  *           moxa.c  -- MOXA Intellio family multiport serial driver.
  *
- *      Copyright (C) 1999-2000  Moxa Technologies (support@moxa.com.tw).
+ *      Copyright (C) 1999-2000  Moxa Technologies (support@moxa.com).
+ *      Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the Linux serial driver, written by
  *      Linus Torvalds, Theodore T'so and others.
@@ -49,7 +50,7 @@
 
 #include "moxa.h"
 
-#define MOXA_VERSION		"5.1k"
+#define MOXA_VERSION		"6.0k"
 
 #define MOXA_FW_HDRLEN		32
 
-- 
1.5.4.1

