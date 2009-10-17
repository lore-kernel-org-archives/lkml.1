Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZJQXrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZJQXrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZJQXrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:47:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2243 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbZJQXrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:47:00 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] MAINTAINERS: ASUS ACPI EXTRAS - remove F:arch/x86/kernel/acpi/boot.c
Date: Sat, 17 Oct 2009 16:47:01 -0700
Message-Id: <f88df4bf6d25b8546df73093c6607f9d06f378ac.1255822797.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255822797.git.joe@perches.com>
References: <cover.1255822797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops.  How did that get there?
(Don't look, it's my original pattern commit...)

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8824115..0b70ca9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -898,7 +898,6 @@ M:	Karol Kozimor <sziwan@users.sourceforge.net>
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://acpi4asus.sf.net
 S:	Maintained
-F:	arch/x86/kernel/acpi/boot.c
 F:	drivers/platform/x86/asus_acpi.c
 
 ASUS ASB100 HARDWARE MONITOR DRIVER
-- 
1.6.5.rc3.dirty

