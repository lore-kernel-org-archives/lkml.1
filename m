Return-Path: <linux-kernel-owner+w=401wt.eu-S970972AbXHMJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970972AbXHMJDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966920AbXHMGbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4938 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966923AbXHMGbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:15 -0400
Date: Sun, 12 Aug 2007 23:30:49 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, ebiederm@xmission.com,
       akpm@linux-foundation.org
Subject: [PATCH] [281/2many] MAINTAINERS - KEXEC
Message-ID: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d9a53d9..71738bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2694,6 +2694,8 @@ W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
+F:	include/linux/kexec.h
+F:	kernel/kexec.c
 
 KPROBES
 P:	Prasanna S Panchamukhi
