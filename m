Return-Path: <linux-kernel-owner+w=401wt.eu-S1765778AbYESWPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765778AbYESWPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764654AbYESWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:09:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45228 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764482AbYESWJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:09:51 -0400
Date: Tue, 20 May 2008 01:07:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] asm-h8300/md.h: remove CVS keyword
Message-ID: <20080519220745.GP17716@cs181133002.pp.htv.fi>
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

