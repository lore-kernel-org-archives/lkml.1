Return-Path: <linux-kernel-owner+w=401wt.eu-S1945903AbXBBIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945903AbXBBIa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423201AbXBBIa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:30:29 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:12272 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423197AbXBBIa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:30:28 -0500
Date: Fri, 2 Feb 2007 11:36:34 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: ufs entry
Message-ID: <20070202083634.GA14773@rain>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark ufs file system as maintainable, and add me as maintainer,
to help people find appropriate person to assign bugs.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.20-rc7/MAINTAINERS
===================================================================
--- linux-2.6.20-rc7.orig/MAINTAINERS
+++ linux-2.6.20-rc7/MAINTAINERS
@@ -3599,6 +3599,12 @@ M:	ysato@users.sourceforge.jp
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
+UFS FILESYSTEM
+P: Evgeniy Dushistov
+M: dushistov@mail.ru
+L: linux-kernel@vger.kernel.org
+S: Maintained
+
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
 M:	miquel@df.uba.ar

-- 
/Evgeniy

