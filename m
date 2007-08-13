Return-Path: <linux-kernel-owner+w=401wt.eu-S942690AbXHMIuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942690AbXHMIuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966591AbXHMGae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4805 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966251AbXHMGaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:30 -0400
Date: Sun, 12 Aug 2007 23:30:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       infinipath@qlogic.com, general@lists.openfabrics.org,
       akpm@linux-foundation.org
Subject: [PATCH] [263/2many] MAINTAINERS - IPATH DRIVER:
Message-ID: <46bffa73.TlHrGgz5328/gmg4%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 629b64c..4157218 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2516,6 +2516,7 @@ M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
+F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 P:	Corey Minyard
