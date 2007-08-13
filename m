Return-Path: <linux-kernel-owner+w=401wt.eu-S940842AbXHMHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940842AbXHMHQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966167AbXHMGYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3881 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966071AbXHMGYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:49 -0400
Date: Sun, 12 Aug 2007 23:24:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxk@qualcomm.com, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [102/2many] MAINTAINERS - BLUETOOTH HCI USB DRIVER
Message-ID: <46bff924.pRanxgf7ILxpvE8y%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f706da..277b091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1024,6 +1024,7 @@ M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	drivers/bluetooth/hci_usb.*
 
 BLUETOOTH HCI BCM203X DRIVER
 P:	Marcel Holtmann
