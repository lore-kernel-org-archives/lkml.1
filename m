Return-Path: <linux-kernel-owner+w=401wt.eu-S966052AbXHMG7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052AbXHMG7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966063AbXHMGYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3743 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966039AbXHMGYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:03 -0400
Date: Sun, 12 Aug 2007 23:23:37 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sziwan@users.sourceforge.net,
       linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       akpm@linux-foundation.org, acpi4asus-user@lists.sourceforge.net
Subject: [PATCH] [71/2many] MAINTAINERS - ASUS ACPI EXTRAS DRIVER
Message-ID: <46bff8e9.umjgFORKvlQhf+LK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ac2226b..622a600 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -708,6 +708,8 @@ L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
+F:	arch/i386/kernel/acpi/boot.c
+F:	drivers/acpi/asus_acpi.c
 
 ASUS ASB100 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
