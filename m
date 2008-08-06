Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbYHFVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbYHFVTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760807AbYHFVMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59620 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbYHFVMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:23 -0400
Date: Thu, 7 Aug 2008 00:10:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
Message-ID: <20080806211054.GN1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the FRAMEBUFFER LAYER entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 20 May 2008

fc7a740aef47772e5417c71f52aa9726eb5c716d diff --git a/MAINTAINERS b/MAINTAINERS
index 2f74092..af69cab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1822,13 +1822,6 @@ M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-HGA FRAMEBUFFER DRIVER
-P:	Ferenc Bakonyi
-M:	fero@drama.obuda.kando.hu
-L:	linux-nvidia@lists.surfsouth.com
-W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
-S:	Maintained
-
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz

