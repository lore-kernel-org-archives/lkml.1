Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKLSAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKLSAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZKLSAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:00:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1358 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZKLSAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:00:47 -0500
Subject: [PATCH V2] MAINTAINERS: KMEMCHECK - Add file patterns, use M: for
 Pekka's name and address
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Vegard Nossum <vegardno@ifi.uio.no>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 10:00:52 -0800
Message-ID: <1258048852.1988.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8264e6b..b7dbdd9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3086,9 +3086,13 @@ F:	kernel/kgdb.c
 
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
-P	Pekka Enberg
-M:	penberg@cs.helsinki.fi
+M:	Pekka Enberg <penberg@cs.helsinki.fi>
 S:	Maintained
+F:	Documentation/kmemcheck.txt
+F:	arch/x86/include/asm/kmemcheck.h
+F:	arch/x86/mm/kmemcheck/
+F:	include/linux/kmemcheck.h
+F:	mm/kmemcheck.c
 
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>



