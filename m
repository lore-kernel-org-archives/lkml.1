Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbYDCTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbYDCTlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbYDCTdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:24 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53023
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbYDCTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:01 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/35] KVM: no longer EXPERIMENTAL
Date: Thu,  3 Apr 2008 22:32:47 +0300
Message-Id: <1207251170-5013-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long overdue.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 41962e7..76c70ab 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM && EXPERIMENTAL
+	depends on HAVE_KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
-- 
1.5.4.5

