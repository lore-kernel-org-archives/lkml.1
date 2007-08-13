Return-Path: <linux-kernel-owner+w=401wt.eu-S940970AbXHMHOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940970AbXHMHOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965968AbXHMGYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3869 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148AbXHMGYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:45 -0400
Date: Sun, 12 Aug 2007 23:24:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [100/2many] MAINTAINERS - BLUETOOTH HIDP LAYER
Message-ID: <46bff920.DKQ2CYo+pw+tnKvj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1285f64..49b1202 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1004,6 +1004,7 @@ BLUETOOTH HIDP LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	net/bluetooth/hidp
 
 BLUETOOTH HCI UART DRIVER
 P:	Marcel Holtmann
