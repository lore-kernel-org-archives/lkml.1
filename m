Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724Ab0ALSNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0ALSNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684Ab0ALSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:13:38 -0500
Received: from smtp.nokia.com ([192.100.122.230]:39039 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0ALSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:13:37 -0500
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paulo R. Zanoni" <przanoni@gmail.com>, Henry Zhao <Henry.Zhao@Sun.COM>,
       Andy Getzendanner <james.getzendanner@students.olin.edu>,
       Brad Spengler <spender@grsecurity.net>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH-again] vgaarb: use MIT license
Date: Tue, 12 Jan 2010 19:58:33 +0200
Message-Id: <1263319113-6631-3-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
References: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
 <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
X-OriginalArrivalTime: 12 Jan 2010 18:12:51.0187 (UTC) FILETIME=[DA725C30:01CA93B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
Hi. All authors already decided about such change. So I'd please ask (again)
that you put the s-o-b tag here. Thanks.

 drivers/gpu/vga/vgaarb.c |   26 +++++++++++++++++++++++---
 include/linux/vgaarb.h   |   21 +++++++++++++++++++++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 0f5f64d..53dd628 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1,12 +1,32 @@
 /*
- * vgaarb.c
+ * vgaarb.c: Implements the VGA arbitration. For details refer to
+ * Documentation/vgaarbiter.txt
+ *
  *
  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
  *
- * Implements the VGA arbitration. For details refer to
- * Documentation/vgaarbiter.txt
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS
+ * IN THE SOFTWARE.
+ *
  */
 
 #include <linux/module.h>
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 2dfaa29..c9a9759 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -5,6 +5,27 @@
  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
  * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS
+ * IN THE SOFTWARE.
+ *
  */
 
 #ifndef LINUX_VGA_H
-- 
1.6.0.4

