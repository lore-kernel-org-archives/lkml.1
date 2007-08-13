Return-Path: <linux-kernel-owner+w=401wt.eu-S966422AbXHMG0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966422AbXHMG0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965568AbXHMGW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3451 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965499AbXHMGWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:25 -0400
Date: Sun, 12 Aug 2007 23:22:07 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       akpm@linux-foundation.org
Subject: [PATCH] [23/2many] MAINTAINERS - ACPI BATTERY DRIVERS
Message-ID: <46bff88f.DlQUzlREkbeqr4cb%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 93a100b..6bb5785 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -261,6 +261,7 @@ M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/battery.c
 
 ACPI EC DRIVER
 P:	Alexey Starikovskiy
