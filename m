Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbYESV7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbYESV7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763936AbYESV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:59:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44769 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764544AbYESV7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:59:33 -0400
Date: Tue, 20 May 2008 00:57:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/mmc/mmc.h: remove CVS tags
Message-ID: <20080519215727.GP17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a CVS tag that wasn't updated for a long time.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
23724d63fa81cfecb4245417456928a582e2b57b diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 4236fbf..14b81f3 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -16,7 +16,6 @@
  * Based strongly on code by:
  *
  * Author: Yong-iL Joh <tolkien@mizi.com>
- * Date  : $Date: 2002/06/18 12:37:30 $
  *
  * Author:  Andrew Christian
  *          15 May 2002

