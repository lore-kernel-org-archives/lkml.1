Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZDZJua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZDZJua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZDZJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:50:20 -0400
Received: from verein.lst.de ([213.95.11.210]:33979 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZDZJuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:50:19 -0400
Date: Sun, 26 Apr 2009 11:49:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org, roland@redhat.com, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add ptrace entry
Message-ID: <20090426094923.GC10194@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Roland and Oleg as formal ptrace maintainers, they've been doing the
job for a while.

Includes the file patterns requested by Joe.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2009-04-25 19:54:02.538948908 +0200
+++ linux-2.6/MAINTAINERS	2009-04-26 11:47:17.102978940 +0200
@@ -4521,6 +4521,19 @@ M:	jim@jtan.com
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
+PTRACE SUPPORT
+P:	Roland McGrath
+M:	roland@redhat.com
+P:	Oleg Nesterov
+M:	oleg@redhat.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/asm-generic/syscall.h
+F:	include/linux/ptrace.h
+F:	include/linux/regset.h
+F:	include/linux/tracehook.h
+F:	kernel/ptrace.c
+
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
