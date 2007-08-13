Return-Path: <linux-kernel-owner+w=401wt.eu-S968218AbXHMJWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968218AbXHMJWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966998AbXHMGcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1119 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966950AbXHMGcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:10 -0400
Date: Sun, 12 Aug 2007 23:31:22 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, paulus@samba.org, paulus@au.ibm.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, anton@samba.org,
       anton@au.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [298/2many] MAINTAINERS - LINUX FOR 64BIT POWERPC
Message-ID: <46bffaba.dVM9Q/vXNeROaC6B%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d10932..36c4960 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2857,6 +2857,9 @@ M:	anton@au.ibm.com
 W:	http://www.penguinppc.org/ppc64/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/configs/ppc64_defconfig
+F:	arch/powerpc/kernel/proc_ppc64.c
+F:	include/asm-powerpc/pgtable-ppc64.h
 
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
