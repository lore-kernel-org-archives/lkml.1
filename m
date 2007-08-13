Return-Path: <linux-kernel-owner+w=401wt.eu-S966683AbXHMIP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966683AbXHMIP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966530AbXHMG2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4503 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966678AbXHMG2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:35 -0400
Date: Sun, 12 Aug 2007 23:28:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mb@bu3sch.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [211/2many] MAINTAINERS - HARDWARE RANDOM NUMBER
 GENERATOR CORE
Message-ID: <46bffa07.y26Ko+o8Rq3I5PgF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f422277..14cef9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2021,6 +2021,9 @@ HARDWARE RANDOM NUMBER GENERATOR CORE
 P:	Michael Buesch
 M:	mb@bu3sch.de
 S:	Maintained
+F:	Documentation/hw_random.txt
+F:	drivers/char/hw_random/
+F:	include/linux/hw_random.h
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
