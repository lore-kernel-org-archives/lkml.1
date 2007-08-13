Return-Path: <linux-kernel-owner+w=401wt.eu-S941389AbXHMHSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941389AbXHMHSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXHMGY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3903 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966059AbXHMGY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:57 -0400
Date: Sun, 12 Aug 2007 23:24:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [106/2many] MAINTAINERS - BLUETOOTH HCI DTL1 DRIVER
Message-ID: <46bff92b.TxgSr/e/GX2BywAh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b702bf..ea3634e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1048,6 +1048,7 @@ BLUETOOTH HCI DTL1 DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/dtl1_cs.c
 
 BLUETOOTH HCI BLUECARD DRIVER
 P:	Marcel Holtmann
