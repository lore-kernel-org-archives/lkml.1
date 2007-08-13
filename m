Return-Path: <linux-kernel-owner+w=401wt.eu-S939748AbXHMHTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939748AbXHMHTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966049AbXHMGZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3920 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966177AbXHMGZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:00 -0400
Date: Sun, 12 Aug 2007 23:24:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [108/2many] MAINTAINERS - BLUETOOTH HCI BT3C DRIVER
Message-ID: <46bff92f.QXr85dmbf9scyoLF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index af3847f..ac9cded 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1060,6 +1060,7 @@ BLUETOOTH HCI BT3C DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bt3c_cs.c
 
 BLUETOOTH HCI BTUART DRIVER
 P:	Marcel Holtmann
