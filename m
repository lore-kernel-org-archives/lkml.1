Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbYHFVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbYHFVPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYHFVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47620 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbYHFVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:10 -0400
Date: Thu, 7 Aug 2008 00:10:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] asm-h8300/md.h: remove CVS keyword
Message-ID: <20080806211042.GK1702@cs181140183.pp.htv.fi>
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

This patch has ben sent on:
- 20 May 2008

0bda44fc75018619bac248acd44c04c41b96fee9 diff --git a/include/asm-h8300/md.h b/include/asm-h8300/md.h
index 1a47dc6..1b7300e 100644
--- a/include/asm-h8300/md.h
+++ b/include/asm-h8300/md.h
@@ -1,4 +1,4 @@
-/* $Id: md.h,v 1.1 2002/11/19 02:09:26 gerg Exp $
+/*
  * md.h: High speed xor_block operation for RAID4/5 
  *
  */

