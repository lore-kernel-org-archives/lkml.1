Return-Path: <linux-kernel-owner+w=401wt.eu-S969647AbXHMJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969647AbXHMJtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967080AbXHMGdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1366 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967048AbXHMGdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:31 -0400
Date: Sun, 12 Aug 2007 23:33:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, osst@riede.org,
       osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [358/2many] MAINTAINERS - ONSTREAM SCSI TAPE DRIVER
Message-ID: <46bffb2d.llEt/oZNIXNGVaQf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 17970b0..89a586a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3441,6 +3441,8 @@ M:	osst@riede.org
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/osst*
+F:	drivers/scsi/st.c
 
 OPROFILE
 P:	Philippe Elie
