Return-Path: <linux-kernel-owner+w=401wt.eu-S943397AbXHMJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943397AbXHMJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764617AbXHMGc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1159 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967014AbXHMGcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:20 -0400
Date: Sun, 12 Aug 2007 23:32:08 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stelian@popies.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [321/2many] MAINTAINERS - MOTION EYE VAIO PICTUREBOOK
 CAMERA DRIVER
Message-ID: <46bffae8.h0ifTcGlEhSx2VBM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3dbcc24..aeb86e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3089,6 +3089,9 @@ P:	Stelian Pop
 M:	stelian@popies.net
 W:	http://popies.net/meye/
 S:	Maintained
+F:	Documentation/video4linux/meye.txt
+F:	drivers/media/video/meye.*
+F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 P:	Pavel Pisa
