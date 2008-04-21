Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbYDUKgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbYDUKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbYDUKaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:25 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37959
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYDUKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 22/31] KVM: Add MAINTAINERS entry for PowerPC KVM
Date: Mon, 21 Apr 2008 13:29:48 +0300
Message-Id: <1208773797-7829-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a18aac1..6072f2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2293,6 +2293,13 @@ L:	kvm-devel@lists.sourceforge.net
 W:	kvm.sourceforge.net
 S:	Supported
 
+KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
+P:	Hollis Blanchard
+M:	hollisb@us.ibm.com
+L:	kvm-ppc-devel@lists.sourceforge.net
+W:	kvm.sourceforge.net
+S:	Supported
+
 KERNEL VIRTUAL MACHINE For Itanium(KVM/IA64)
 P:	Anthony Xu
 M:	anthony.xu@intel.com
-- 
1.5.5

