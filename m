Return-Path: <linux-kernel-owner+w=401wt.eu-S940298AbXHMKqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940298AbXHMKqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967336AbXHMGg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1866 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966924AbXHMGgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:19 -0400
Date: Sun, 12 Aug 2007 23:36:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rjw@sisk.pl, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [444/2many] MAINTAINERS - SUSPEND TO RAM:
Message-ID: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5ae90a2..e9e7a00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4226,6 +4226,7 @@ P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
+F:	kernel/power/
 
 SONIC NETWORK DRIVER
 P:	Thomas Bogendoerfer
