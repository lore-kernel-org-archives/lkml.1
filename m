Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZDHX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZDHX2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZDHX2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:28:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60362 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbZDHX2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:28:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.13033.345975.434902@cargo.ozlabs.ibm.com>
Date: Thu, 9 Apr 2009 09:27:37 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: add MAINTAINERS entry
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an entry in MAINTAINERS for the perf_counter subsystem.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
As requested.  Ingo, do you want to be listed or do you have enough to
do already? :-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3b2159..f8d80ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3483,6 +3483,14 @@ M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+PERFORMANCE COUNTER SUBSYSTEM
+P:	Peter Zijlstra
+M:	a.p.zijlstra@chello.nl
+P:	Paul Mackerras
+M:	paulus@samba.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 PERSONALITY HANDLING
 P:	Christoph Hellwig
 M:	hch@infradead.org
