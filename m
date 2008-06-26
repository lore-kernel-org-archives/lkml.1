Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYFZNNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYFZNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761205AbYFZNLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:11:21 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23958 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761589AbYFZNLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:11:19 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 07/60] microblaze_v4: Support for semaphores
Date: Thu, 26 Jun 2008 14:29:36 +0200
Message-Id: <1214483429-32360-8-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-7-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/semaphore.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/semaphore.h

diff --git a/include/asm-microblaze/semaphore.h b/include/asm-microblaze/semaphore.h
new file mode 100644
index 0000000..d9b2034
--- /dev/null
+++ b/include/asm-microblaze/semaphore.h
@@ -0,0 +1 @@
+#include <linux/semaphore.h>
-- 
1.5.4.GIT

