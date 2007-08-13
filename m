Return-Path: <linux-kernel-owner+w=401wt.eu-S940862AbXHMHO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940862AbXHMHO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966157AbXHMGYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3868 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966144AbXHMGYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:44 -0400
Date: Sun, 12 Aug 2007 23:24:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, akpm@linux-foundation.org
Subject: [PATCH] [95/2many] MAINTAINERS - BLOCK LAYER
Message-ID: <46bff917.EmblDII2NfX3zJ2k%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b84921..912950f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -960,6 +960,7 @@ M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
+F:	drivers/block/
 
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
