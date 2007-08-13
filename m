Return-Path: <linux-kernel-owner+w=401wt.eu-S968985AbXHMMOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968985AbXHMMOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967466AbXHMGks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2520 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967533AbXHMGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:30 -0400
Date: Sun, 12 Aug 2007 23:40:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rbultje@ronald.bitfreak.net,
       mjpeg-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [554/2many] MAINTAINERS - ZR36067 VIDEO FOR LINUX DRIVER
Message-ID: <46bffcc6.Vkf/E2Q+WGsqMG/q%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b21841e..d291a71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5244,6 +5244,7 @@ M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
+F:	drivers/media/video/zoran_*
 
 ZR36120 VIDEO FOR LINUX DRIVER
 P:	Pauline Middelink
