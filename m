Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZLBRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZLBRbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZLBRbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:31:52 -0500
Received: from smtp.nokia.com ([192.100.122.230]:32627 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZLBRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:31:51 -0500
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paulo R. Zanoni" <przanoni@gmail.com>, Henry Zhao <Henry.Zhao@Sun.COM>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH] vgaarb: use MIT license
Date: Wed,  2 Dec 2009 19:19:28 +0200
Message-Id: <1259774368-27516-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 02 Dec 2009 17:31:33.0338 (UTC) FILETIME=[4A98DBA0:01CA7375]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
Hi. I'd please ask that other copyright holders put yours s-o-b tag there.
Thanks.

 drivers/gpu/vga/vgaarb.c |   26 +++++++++++++++++++++++---
 include/linux/vgaarb.h   |   21 +++++++++++++++++++++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 1ac0c93..7553cc3 100644
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

