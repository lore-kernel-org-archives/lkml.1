Return-Path: <linux-kernel-owner+w=401wt.eu-S967632AbXHMHnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967632AbXHMHnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965503AbXHMG0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4183 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966338AbXHMG0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:35 -0400
Date: Sun, 12 Aug 2007 23:26:14 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, akpm@linux-foundation.org
Subject: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER  (LVM)
Message-ID: <46bff986.szARdClTcYqQa8So%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ea991f0..36a7d25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1472,6 +1472,7 @@ P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 S:	Maintained
+F:	drivers/md/dm*
 
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
