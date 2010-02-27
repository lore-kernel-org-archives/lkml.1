Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab0B0Qwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:52:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab0B0Qwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bbw8j0y++e/C91FV9raO+YSuH/C4tHDj5t28lFLCUUbXImAa+JZJ+aOXQ0xh9TBCho
         qM7GiWtJiJ1kug2g8ZPSbhPFmx5kolwvWAS7ShpibkPCDEUjEkPcdN5WAMNs6Nq0wLQV
         I3suboCkCeSbHzdJ0DEaCjGVMfktuOUcSQxvc=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/66] arch/arm/mach-sa1100/include/mach/timex.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:50:49 +0100
Message-Id: <1267289508-31031-9-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-sa1100/include/mach/timex.h:6: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/mach-sa1100/include/mach/timex.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/timex.h b/arch/arm/mach-sa1100/include/mach/timex.h
index 7a5d017..7dc68ec 100644
--- a/arch/arm/mach-sa1100/include/mach/timex.h
+++ b/arch/arm/mach-sa1100/include/mach/timex.h
@@ -3,7 +3,7 @@
  *
  * SA1100 architecture timex specifications
  *
- * Copyright (C) 1998 
+ * Copyright (C) 1998
  */
 
 /*
-- 
1.7.0.90.g251a4

