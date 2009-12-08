Return-Path: <linux-kernel-owner+w=401wt.eu-S966349AbZLHVRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966349AbZLHVRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966314AbZLHVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966301AbZLHVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [27/31] HWPOISON: Use correct name for MADV_HWPOISON in documentation
Message-Id: <20091208211643.8FB73B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/vm/hwpoison.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/Documentation/vm/hwpoison.txt
===================================================================
--- linux.orig/Documentation/vm/hwpoison.txt
+++ linux/Documentation/vm/hwpoison.txt
@@ -92,7 +92,7 @@ PR_MCE_KILL_GET
 
 Testing:
 
-madvise(MADV_POISON, ....)
+madvise(MADV_HWPOISON, ....)
 	(as root)
 	Poison a page in the process for testing
 
