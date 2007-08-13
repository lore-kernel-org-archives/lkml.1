Return-Path: <linux-kernel-owner+w=401wt.eu-S965732AbXHMJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965732AbXHMJzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967033AbXHMGdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1428 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967129AbXHMGds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:48 -0400
Date: Sun, 12 Aug 2007 23:33:31 -0700
From: joe@perches.com
To: zach@vmware.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, jeremy@xensource.com, chrisw@sous-sol.org,
       akpm@linux-foundation.org
Subject: [PATCH] [365/2many] MAINTAINERS - PARAVIRT_OPS INTERFACE
Message-ID: <46bffb3b.jTNczaQ2ECqVDjzn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2166416..44768ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3519,6 +3519,9 @@ M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	arch/i386/kernel/paravirt.c
+F:	include/asm-i386/paravirt.h
+F:	include/asm-um/paravirt.h
 
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
