Return-Path: <linux-kernel-owner+w=401wt.eu-S936448AbYBVWUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936448AbYBVWUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbYBVWLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:11:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935601AbYBVWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=aLASswmHqmJlXz4lcYEKE8zNaVyrjokXphfYe+LyVeryFAoBBtJ1DqZPVC9mujNJQFsyixZAq3qZSlFd2I/7wzPPpYlHRBory09aE3ADFyaIJIWMtS7xHKMqW+pexS8nfq1B83pnhLxoSFzf747Mum+umm/eWm0ket9U1sLwWO4=
Date: Fri, 22 Feb 2008 23:11:39 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/20] x86: Coding Style fixes to
 arch/x86/kernel/acpi/sleep.c
Message-ID: <20080222231139.7fdd84a9@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 6bc815c..dd78326 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -13,7 +13,7 @@
 #include <asm/smp.h>
 
 /* address in low memory of the wakeup routine. */
-unsigned long acpi_wakeup_address = 0;
+unsigned long acpi_wakeup_address;
 unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
-- 
1.5.4.GIT

