Return-Path: <linux-kernel-owner+w=401wt.eu-S1765505AbYESWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765505AbYESWNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764660AbYESWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:08:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40274 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765200AbYESWIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:08:46 -0400
Date: Tue, 20 May 2008 01:06:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/dma.c: remove a CVS keyword
Message-ID: <20080519220641.GM17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a CVS keyword that wasn't updated for a long time 
from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
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

