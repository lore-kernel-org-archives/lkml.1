Return-Path: <linux-kernel-owner+w=401wt.eu-S940391AbXHMHNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940391AbXHMHNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966142AbXHMGYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3863 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966134AbXHMGYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:43 -0400
Date: Sun, 12 Aug 2007 23:24:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [99/2many] MAINTAINERS - BLUETOOTH CMTP LAYER
Message-ID: <46bff91e.MaxOkZwNvsTlFbp0%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index df93f4f..1285f64 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -998,6 +998,7 @@ BLUETOOTH CMTP LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	net/bluetooth/cmtp/
 
 BLUETOOTH HIDP LAYER
 P:	Marcel Holtmann
