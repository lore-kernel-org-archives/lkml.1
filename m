Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbXHSADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbXHSADr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 20:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXHSADj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 20:03:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXHSADi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 20:03:38 -0400
Date: Sun, 19 Aug 2007 01:03:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] soft-fp.h tpyo
Message-ID: <20070819000307.GQ21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/math-emu/soft-fp.h b/include/math-emu/soft-fp.h
index a0721ef..a6f873b 100644
--- a/include/math-emu/soft-fp.h
+++ b/include/math-emu/soft-fp.h
@@ -98,7 +98,7 @@
 #endif
 
 #ifndef FP_TRAPPING_EXCEPTIONS
-#define FP_TRAPPING_EXCPETIONS 0
+#define FP_TRAPPING_EXCEPTIONS 0
 #endif
 
 #define FP_SET_EXCEPTION(ex)				\
