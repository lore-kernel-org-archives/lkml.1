Return-Path: <linux-kernel-owner+w=401wt.eu-S942680AbXHMHqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942680AbXHMHqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966197AbXHMG0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4206 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966373AbXHMG0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:43 -0400
Date: Sun, 12 Aug 2007 23:26:29 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, kristen.c.accardi@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [160/2many] MAINTAINERS - DOCKING STATION DRIVER
Message-ID: <46bff995.TAA7qqrnMrIxNSfv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fafb83..b8ff492 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1565,6 +1565,7 @@ P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-acpi@vger.kernel.org
 S:	Supported
+F:	drivers/acpi/dock.c
 
 DOUBLETALK DRIVER
 P:	James R. Van Zandt
