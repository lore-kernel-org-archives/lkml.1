Return-Path: <linux-kernel-owner+w=401wt.eu-S943541AbXHMLAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943541AbXHMLAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967319AbXHMGhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1984 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967321AbXHMGhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:01 -0400
Date: Sun, 12 Aug 2007 23:36:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [462/2many] MAINTAINERS - STARMODE RADIO IP (STRIP)
 PROTOCOL DRIVER
Message-ID: <46bffc00.4rZktarzOy1dpkG5%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index eead832..9da5a44 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4398,6 +4398,8 @@ F:	drivers/net/starfire*
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 W:	http://mosquitonet.Stanford.EDU/strip.html
 S:	Unsupported ?
+F:	drivers/net/wireless/strip.c
+F:	include/linux/if_strip.h
 
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
