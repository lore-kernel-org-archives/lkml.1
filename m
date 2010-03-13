Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab0CMM77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:59:59 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:55485 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0CMM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:59:58 -0500
Date: Sat, 13 Mar 2010 07:58:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: trivial@kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: [PATCH] KOBJECTS:  kref.h incorrectly describes itself as kref.c.
Message-ID: <alpine.LFD.2.00.1003130756060.8626@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/kref.h b/include/linux/kref.h
index b0cb0eb..baf4b9e 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -1,5 +1,5 @@
 /*
- * kref.c - library routines for handling generic reference counted objects
+ * kref.h - library routines for handling generic reference counted objects
  *
  * Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (C) 2004 IBM Corp.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
