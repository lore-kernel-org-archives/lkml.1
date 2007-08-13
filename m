Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXHMLJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXHMLJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966394AbXHMGhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2052 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967226AbXHMGhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:24 -0400
Date: Sun, 12 Aug 2007 23:37:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dsaxena@plexity.net, akpm@linux-foundation.org
Subject: [PATCH] [473/2many] MAINTAINERS - TI OMAP RANDOM NUMBER GENERATOR SUPPORT
Message-ID: <46bffc16.2V09zuqBN/CLpaFd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a7f837..c8ce755 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4488,6 +4488,7 @@ TI OMAP RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/omap-rng.c
 
 TASKSTATS STATISTICS INTERFACE
 P:	Shailabh Nagar
