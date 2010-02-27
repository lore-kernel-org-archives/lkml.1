Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030398Ab0B0QzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:20 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab0B0QzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=M8bZGxjtODVjCpwEgdKdG+1SWXgFGFPuVozpM9mO/zK0dhoMleXiDnk5vdSIR/inHP
         VLDc8EUGJ1rlCc8ESO3iLVaxEq3Xq+a05TM9NsIFrItwkvxNNUfYFi4SwH35hZUVSG5N
         +bmPIX57ZY/iRmQWfWSOPX/dq6wd4u9jCbx/c=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 32/66] arch/parisc/include/asm/parport.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:13 +0100
Message-Id: <1267289508-31031-33-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/parisc/include/asm/parport.h:1: ERROR: trailing whitespace
arch/parisc/include/asm/parport.h:11: WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/parisc/include/asm/parport.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/parport.h b/arch/parisc/include/asm/parport.h
index 00d9cc3..5cbf98b 100644
--- a/arch/parisc/include/asm/parport.h
+++ b/arch/parisc/include/asm/parport.h
@@ -1,4 +1,4 @@
-/* 
+/*
  *
  * parport.h: ia32-compatible parport initialisation
  *
@@ -8,8 +8,7 @@
 #define _ASM_PARPORT_H 1
 
 
-static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
-{
+static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma) {
 	/* nothing ! */
 	return 0;
 }
-- 
1.7.0.90.g251a4

