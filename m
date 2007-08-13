Return-Path: <linux-kernel-owner+w=401wt.eu-S941693AbXHMK6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941693AbXHMK6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967016AbXHMGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1964 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966719AbXHMGgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:55 -0400
Date: Sun, 12 Aug 2007 23:36:37 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bootc@bootc.net, akpm@linux-foundation.org
Subject: [PATCH] [456/2many] MAINTAINERS - SOEKRIS NET48XX LED SUPPORT
Message-ID: <46bffbf5.hJnAR64qkx85eKAW%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cb9f9da..aab0075 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4355,6 +4355,7 @@ SOEKRIS NET48XX LED SUPPORT
 P:	Chris Boot
 M:	bootc@bootc.net
 S:	Maintained
+F:	drivers/leds/leds-net48xx.c
 
 SPARC (sparc32):
 P:	William L. Irwin
