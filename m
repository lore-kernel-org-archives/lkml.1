Return-Path: <linux-kernel-owner+w=401wt.eu-S943013AbXHMIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943013AbXHMIun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966873AbXHMGag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4813 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966816AbXHMGad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:33 -0400
Date: Sun, 12 Aug 2007 23:30:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, perex@suse.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [267/2many] MAINTAINERS - ISAPNP
Message-ID: <46bffa7d.5LzVq5KCXqfE59nJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d726c8..ab9ba39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2552,6 +2552,9 @@ ISAPNP
 P:	Jaroslav Kysela
 M:	perex@suse.cz
 S:	Maintained
+F:	Documentation/isapnp.txt
+F:	drivers/pnp/isapnp/
+F:	include/linux/isapnp.h
 
 ISDN SUBSYSTEM
 P:	Karsten Keil
