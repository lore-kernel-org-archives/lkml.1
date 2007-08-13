Return-Path: <linux-kernel-owner+w=401wt.eu-S942458AbXHMLan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942458AbXHMLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939240AbXHMGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2195 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966670AbXHMGia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:30 -0400
Date: Sun, 12 Aug 2007 23:38:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ok@artecdesign.ee,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [498/2many] MAINTAINERS - USB ISP116X DRIVER
Message-ID: <46bffc59.531ResBtuq5CfRyB%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d46c083..2759bc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4712,6 +4712,8 @@ P:	Olav Kongas
 M:	ok@artecdesign.ee
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/host/isp116x*
+F:	include/linux/usb/isp116x.h
 
 USB KAWASAKI LSI DRIVER
 P:	Oliver Neukum
