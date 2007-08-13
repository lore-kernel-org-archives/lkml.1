Return-Path: <linux-kernel-owner+w=401wt.eu-S940927AbXHMHPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940927AbXHMHPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966158AbXHMGYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3873 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965939AbXHMGYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:46 -0400
Date: Sun, 12 Aug 2007 23:24:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxk@qualcomm.com, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [96/2many] MAINTAINERS - BLUETOOTH SUBSYSTEM
Message-ID: <46bff919.Rp2duBBGB6cu6MsA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 912950f..763854e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -973,6 +973,9 @@ W:	http://www.bluez.org
 W:	http://www.holtmann.org/linux/bluetooth/
 T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
+F:	drivers/bluetooth/
+F:	net/bluetooth/
+F:	include/net/bluetooth/
 
 BLUETOOTH RFCOMM LAYER
 P:	Marcel Holtmann
