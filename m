Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab0B0QyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:25 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968581Ab0B0QyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uL9QUJGgqmEI/9XNSrYJXk1nGyXZJ0l3i6aoybFtz2earqGiTqopYwryOMvY4v7TT9
         8J6e3Z5F855utEfjURo8D08qIbWt2fRz+VzpltVjzyI+edNkKD8lWHY43pPiij9qOMTX
         28HK/WbN4jqAAQ2jtmdpSgUZcoe67AIIqPHzQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 24/66] arch/h8300/include/asm/tlb.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:05 +0100
Message-Id: <1267289508-31031-25-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/h8300/include/asm/tlb.h:1: ERROR: trailing whitespace
arch/h8300/include/asm/tlb.h:2: ERROR: trailing whitespace
arch/h8300/include/asm/tlb.h:10: ERROR: trailing whitespace
arch/h8300/include/asm/tlb.h:11: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/h8300/include/asm/tlb.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/include/asm/tlb.h b/arch/h8300/include/asm/tlb.h
index 3dea80a..54e30d4 100644
--- a/arch/h8300/include/asm/tlb.h
+++ b/arch/h8300/include/asm/tlb.h
@@ -1,5 +1,5 @@
-/* 
-  include/asm-h8300/tlb.h 
+/*
+  include/asm-h8300/tlb.h
 */
 
 #ifndef __H8300_TLB_H__
@@ -7,8 +7,8 @@
 
 #define tlb_flush(tlb)	do { } while(0)
 
-/* 
-  include/asm-h8300/tlb.h 
+/*
+  include/asm-h8300/tlb.h
 */
 
 #ifndef __H8300_TLB_H__
-- 
1.7.0.90.g251a4

