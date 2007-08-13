Return-Path: <linux-kernel-owner+w=401wt.eu-S940600AbXHMHMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940600AbXHMHMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966119AbXHMGYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3852 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116AbXHMGYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:39 -0400
Date: Sun, 12 Aug 2007 23:24:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, maxk@qualcomm.com, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [97/2many] MAINTAINERS - BLUETOOTH RFCOMM LAYER
Message-ID: <46bff91b.9XudEGoPd6Gp2h4+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 763854e..d14b78b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -983,6 +983,8 @@ M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	net/bluetooth/rfcomm/
+F:	include/net/bluetooth/rfcomm.h
 
 BLUETOOTH BNEP LAYER
 P:	Marcel Holtmann
