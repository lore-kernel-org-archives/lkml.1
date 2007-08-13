Return-Path: <linux-kernel-owner+w=401wt.eu-S941103AbXHMHQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941103AbXHMHQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966039AbXHMGYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3875 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966042AbXHMGYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:47 -0400
Date: Sun, 12 Aug 2007 23:24:34 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxk@qualcomm.com, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [101/2many] MAINTAINERS - BLUETOOTH HCI UART DRIVER
Message-ID: <46bff922.aUKxQuU3P7AVMdv1%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 49b1202..6f706da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1012,6 +1012,11 @@ M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	drivers/bluetooth/btuart_cs.c
+F:	drivers/bluetooth/hci_bcsp.c
+F:	drivers/bluetooth/hci_h4.c
+F:	drivers/bluetooth/hci_ldisc.c
+F:	drivers/bluetooth/hci_uart.h
 
 BLUETOOTH HCI USB DRIVER
 P:	Marcel Holtmann
