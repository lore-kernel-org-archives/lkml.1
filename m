Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYHHQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYHHQmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYHHQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36124 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118AbYHHQgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:39 -0400
Date: Fri, 8 Aug 2008 19:35:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: [17/17] include/linux/bcd.h: remove comments
Message-ID: <20080808163504.GX14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- the macros are gone
- there's no more code in this file,
  LGPL + GPL = GPL,
  and the code that was moved to lib/bcd.c is anyway trivial

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

964d2de58494d74cabb3a74e6bfce51f0c5e9b18 
diff --git a/include/linux/bcd.h b/include/linux/bcd.h
index 75f6d6e..22ea563 100644
--- a/include/linux/bcd.h
+++ b/include/linux/bcd.h
@@ -1,12 +1,3 @@
-/* Permission is hereby granted to copy, modify and redistribute this code
- * in terms of the GNU Library General Public License, Version 2 or later,
- * at your option.
- */
-
-/* macros to translate to/from binary and binary-coded decimal (frequently
- * found in RTC chips).
- */
-
 #ifndef _BCD_H
 #define _BCD_H
 

