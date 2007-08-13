Return-Path: <linux-kernel-owner+w=401wt.eu-S968723AbXHMITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968723AbXHMITV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966462AbXHMG2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4533 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966714AbXHMG2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:44 -0400
Date: Sun, 12 Aug 2007 23:28:29 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       arobinso@nyx.net, akpm@linux-foundation.org
Subject: [PATCH] [214/2many] MAINTAINERS - HAYES ESP SERIAL DRIVER
Message-ID: <46bffa0d.W+yTeqAcmb78H+mN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b8aaabd..cabdc6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2047,6 +2047,7 @@ M:	arobinso@nyx.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
+F:	drivers/char/esp.c
 
 HFS FILESYSTEM
 P:	Roman Zippel
