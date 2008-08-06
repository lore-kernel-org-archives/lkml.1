Return-Path: <linux-kernel-owner+w=401wt.eu-S1422919AbYHFVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919AbYHFVOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbYHFVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59606 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbYHFVMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:07 -0400
Date: Thu, 7 Aug 2008 00:10:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/dma.c: remove a CVS keyword
Message-ID: <20080806211038.GJ1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a CVS keyword that wasn't updated for a long time 
from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 20 May 2008

ecbe2e714c6f467a94d2240223dfa335cdfb501e diff --git a/kernel/dma.c b/kernel/dma.c
index d2c60a8..f903189 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -1,4 +1,4 @@
-/* $Id: dma.c,v 1.7 1994/12/28 03:35:33 root Exp root $
+/*
  * linux/kernel/dma.c: A DMA channel allocator. Inspired by linux/kernel/irq.c.
  *
  * Written by Hennus Bergman, 1992.

