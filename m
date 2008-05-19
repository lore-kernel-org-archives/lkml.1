Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbYESWA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbYESWA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764589AbYESWAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:00:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39959 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764350AbYESWAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:00:31 -0400
Date: Tue, 20 May 2008 00:58:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] telephony: remove CVS keywords
Message-ID: <20080519215826.GS17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/telephony/ixj.c   |    2 --
 include/linux/telephony.h |    4 ----
 2 files changed, 6 deletions(-)

413f5fb4ebba4bbc4a2a0061ba475c897842e334 diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..127f761 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -42,8 +42,6 @@
  ***************************************************************************/
 
 /*
- * $Log: ixj.c,v $
- *
  * Revision 4.8  2003/07/09 19:39:00  Daniele Bellucci
  * Audit some copy_*_user and minor cleanup.
  *
diff --git a/include/linux/telephony.h b/include/linux/telephony.h
index 0d0cf2a..5b2b626 100644
--- a/include/linux/telephony.h
+++ b/include/linux/telephony.h
@@ -28,10 +28,6 @@
  * ON AN "AS IS" BASIS, AND QUICKNET TECHNOLOGIES, INC. HAS NO OBLIGATION
  * TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
  *
- * Version:       $Revision: 4.2 $
- *
- * $Id: telephony.h,v 4.2 2001/08/06 07:09:43 craigs Exp $
- *
  *****************************************************************************/
 
 #ifndef TELEPHONY_H
