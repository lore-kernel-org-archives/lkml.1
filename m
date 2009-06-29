Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbZF2BMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbZF2BMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZF2BML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:12:11 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41219 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZF2BMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:12:10 -0400
Date: Sun, 28 Jun 2009 21:10:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] KERNEL:  Correct routine name in comment.
Message-ID: <alpine.LFD.2.00.0906282109240.25795@localhost>
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

diff --git a/kernel/panic.c b/kernel/panic.c
index 984b3ec..b855012 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -177,7 +177,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *
- *	The string is overwritten by the next call to print_taint().
+ *	The string is overwritten by the next call to print_tainted().
  */
 const char *print_tainted(void)
 {

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
