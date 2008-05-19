Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbYESWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbYESWIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYESWFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:05:40 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40172 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbYESWFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:05:38 -0400
Date: Tue, 20 May 2008 01:03:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] alpha: remove CVS keywords
Message-ID: <20080519220332.GH17716@cs181133002.pp.htv.fi>
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

 include/asm-alpha/dma.h   |    2 +-
 include/asm-alpha/md.h    |    2 +-
 include/asm-alpha/namei.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

3c0a3ce6f7e45ae28adab81d6cd25fa8f0b8b8f8 diff --git a/include/asm-alpha/dma.h b/include/asm-alpha/dma.h
index 87cfdbd..ee9ff3b 100644
--- a/include/asm-alpha/dma.h
+++ b/include/asm-alpha/dma.h
@@ -8,7 +8,7 @@
  * as this will also enable DMA across 64 KB boundaries.
  */
 
-/* $Id: dma.h,v 1.7 1992/12/14 00:29:34 root Exp root $
+/*
  * linux/include/asm/dma.h: Defines for using and allocating dma channels.
  * Written by Hennus Bergman, 1992.
  * High DMA channel support & info by Hannu Savolainen
diff --git a/include/asm-alpha/md.h b/include/asm-alpha/md.h
index 6c9b822..1b7300e 100644
--- a/include/asm-alpha/md.h
+++ b/include/asm-alpha/md.h
@@ -1,4 +1,4 @@
-/* $Id: md.h,v 1.1 1997/12/15 15:11:48 jj Exp $
+/*
  * md.h: High speed xor_block operation for RAID4/5 
  *
  */
diff --git a/include/asm-alpha/namei.h b/include/asm-alpha/namei.h
index 5cc9bb3..6704a76 100644
--- a/include/asm-alpha/namei.h
+++ b/include/asm-alpha/namei.h
@@ -1,4 +1,4 @@
-/* $Id: namei.h,v 1.1 1996/12/13 14:48:21 jj Exp $
+/*
  * linux/include/asm-alpha/namei.h
  *
  * Included from linux/fs/namei.c

