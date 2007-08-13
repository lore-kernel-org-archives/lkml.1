Return-Path: <linux-kernel-owner+w=401wt.eu-S941239AbXHMHRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941239AbXHMHRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966170AbXHMGYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3886 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965858AbXHMGYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:51 -0400
Date: Sun, 12 Aug 2007 23:24:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [103/2many] MAINTAINERS - BLUETOOTH HCI BCM203X DRIVER
Message-ID: <46bff926.2JAamJuXAviq1bKM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 277b091..ebcdfa6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1030,6 +1030,7 @@ BLUETOOTH HCI BCM203X DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bcm203x.c
 
 BLUETOOTH HCI BPA10X DRIVER
 P:	Marcel Holtmann
