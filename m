Return-Path: <linux-kernel-owner+w=401wt.eu-S970777AbXHMJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970777AbXHMJBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966909AbXHMGbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4926 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966900AbXHMGbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:09 -0400
Date: Sun, 12 Aug 2007 23:30:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [285/2many] MAINTAINERS - LED SUBSYSTEM
Message-ID: <46bffaa1.MMdbKl1MIc5INuZU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f8a3640..5b8199d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2738,6 +2738,8 @@ LED SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	drivers/leds/
+F:	include/linux/leds.h
 
 LEGO USB Tower driver
 P:	Juergen Stuber
