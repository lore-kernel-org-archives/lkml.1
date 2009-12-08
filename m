Return-Path: <linux-kernel-owner+w=401wt.eu-S966392AbZLHVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966392AbZLHVVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966218AbZLHVQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49504 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966198AbZLHVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:11 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [1/31] HWPOISON: Add Andi Kleen as hwpoison maintainer to MAINTAINERS
Message-Id: <20091208211617.45C20B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -2322,6 +2322,15 @@ W:	http://www.kernel.org/pub/linux/kerne
 S:	Maintained
 F:	drivers/hwmon/hdaps.c
 
+HWPOISON MEMORY FAILURE HANDLING
+M:	Andi Kleen <andi@firstfloor.org>
+L:	linux-mm@kvack.org
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
+S:	Maintained
+F:	mm/memory-failure.c
+F:	mm/hwpoison-inject.c
+
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@ozlabs.org
 S:	Odd Fixes
