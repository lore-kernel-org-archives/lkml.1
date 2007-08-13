Return-Path: <linux-kernel-owner+w=401wt.eu-S969616AbXHMIbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969616AbXHMIbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966807AbXHMG3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4650 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966524AbXHMG3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:30 -0400
Date: Sun, 12 Aug 2007 23:29:16 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       brking@us.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [238/2many] MAINTAINERS - IBM Power Linux RAID adapter
Message-ID: <46bffa3c.q7BVlUMWzJ2FkPsv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index dd7d6f0..a2e3afc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2260,6 +2260,7 @@ IBM Power Linux RAID adapter
 P:	Brian King
 M:	brking@us.ibm.com
 S:	Supported
+F:	drivers/scsi/ipr.*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
