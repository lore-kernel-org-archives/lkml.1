Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZFHRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZFHRWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZFHRUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:31 -0400
Received: from relay3.sgi.com ([192.48.156.57]:39354 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753789AbZFHRUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:30 -0400
Message-Id: <20090608172029.055889000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:17:00 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 12/12] GRU - copyright fixes
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_copyright_fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix the copyright statements in a couple of GRU files. No
functional changes are being made.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukdump.c |   18 ++++++++++++++----
 drivers/misc/sgi-gru/grumain.c  |   18 ++++++++++++++----
 2 files changed, 28 insertions(+), 8 deletions(-)

Index: linux/drivers/misc/sgi-gru/grukdump.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukdump.c	2009-06-08 10:28:25.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukdump.c	2009-06-08 10:28:59.000000000 -0500
@@ -3,11 +3,21 @@
  *
  *            Dump GRU State
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
 #include <linux/kernel.h>
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-06-08 10:28:25.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-06-08 10:29:11.000000000 -0500
@@ -3,11 +3,21 @@
  *
  *            DRIVER TABLE MANAGER + GRU CONTEXT LOAD/UNLOAD
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
 #include <linux/kernel.h>

