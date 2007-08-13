Return-Path: <linux-kernel-owner+w=401wt.eu-S942185AbXHMHhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942185AbXHMHhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966274AbXHMG0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4119 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966256AbXHMG0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:09 -0400
Date: Sun, 12 Aug 2007 23:25:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       akpm@linux-foundation.org
Subject: [PATCH] [135/2many] MAINTAINERS - CPU FREQUENCY DRIVERS
Message-ID: <46bff962.fBD4aAz2pZsNqDAn%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a51b89e..60e6fb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1309,6 +1309,9 @@ L:	cpufreq@lists.linux.org.uk
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
 T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
+F:	arch/i386/kernel/cpu/cpufreq/
+F:	drivers/cpufreq/
+F:	include/linux/cpufreq.h
 
 CPUID/MSR DRIVER
 P:	H. Peter Anvin
