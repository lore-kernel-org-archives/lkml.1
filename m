Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbXHMKL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbXHMKL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967200AbXHMGec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1356 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967107AbXHMGd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:27 -0400
Date: Sun, 12 Aug 2007 23:33:13 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, corbet@lwn.net, akpm@linux-foundation.org
Subject: [PATCH] [356/2many] MAINTAINERS - OMNIVISION OV7670 SENSOR DRIVER
Message-ID: <46bffb29.4+WKeEPlSAeAam/+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index abac381..dbe6a36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3421,10 +3421,11 @@ S:	Maintained
 F:	drivers/char/pcmcia/cm4040_cs.*
 
 OMNIVISION OV7670 SENSOR DRIVER
-P:   	Jonathan Corbet
+P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/ov7670.c
 
 ONENAND FLASH DRIVER
 P:	Kyungmin Park
