Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbYESWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbYESWSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760423AbYESWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:11:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40378 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765598AbYESWLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:11:34 -0400
Date: Tue, 20 May 2008 01:09:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
Message-ID: <20080519220928.GW17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the FRAMEBUFFER LAYER entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
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

