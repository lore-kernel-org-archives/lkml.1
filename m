Return-Path: <linux-kernel-owner+w=401wt.eu-S966713AbXHMG2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966713AbXHMG2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXHMGWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3460 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965526AbXHMGWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:30 -0400
Date: Sun, 12 Aug 2007 23:22:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, len.brown@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [22/2many] MAINTAINERS - ACPI
Message-ID: <46bff88d.zVo0DUSTuvIvka+P%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1162fb7..93a100b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -251,6 +251,9 @@ L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
+F:	drivers/acpi/
+F:	drivers/ata/libata-acp*
+F:	drivers/pnp/pnpacpi/
 
 ACPI BATTERY DRIVERS
 P:	Alexey Starikovskiy
