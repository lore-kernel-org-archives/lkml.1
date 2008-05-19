Return-Path: <linux-kernel-owner+w=401wt.eu-S1765454AbYESWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765454AbYESWPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765100AbYESWJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:09:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45214 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763367AbYESWJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:09:31 -0400
Date: Tue, 20 May 2008 01:07:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] powerpc/mm/hash_low_32.S: remove CVS keyword
Message-ID: <20080519220725.GO17716@cs181133002.pp.htv.fi>
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
92f17f771c22fa93afe058210ddf51920aca1451 diff --git a/arch/powerpc/mm/hash_low_32.S b/arch/powerpc/mm/hash_low_32.S
index ddeaf9e..b9ba7d9 100644
--- a/arch/powerpc/mm/hash_low_32.S
+++ b/arch/powerpc/mm/hash_low_32.S
@@ -1,6 +1,4 @@
 /*
- *  $Id: hashtable.S,v 1.6 1999/10/08 01:56:15 paulus Exp $
- *
  *  PowerPC version
  *    Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
  *  Rewritten by Cort Dougan (cort@cs.nmt.edu) for PReP

