Return-Path: <linux-kernel-owner+w=401wt.eu-S967588AbXHMHdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967588AbXHMHdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966242AbXHMGZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4073 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966236AbXHMGZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:56 -0400
Date: Sun, 12 Aug 2007 23:25:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, simon.derr@bull.net, pj@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [137/2many] MAINTAINERS - CPUSETS
Message-ID: <46bff966.vXK5z8tiwKW7cypt%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cd1e24..07df33a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1327,6 +1327,9 @@ M:	simon.derr@bull.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 S:	Supported
+F:	Documentation/cpusets.txt
+F:	include/linux/cpuset.h
+F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
