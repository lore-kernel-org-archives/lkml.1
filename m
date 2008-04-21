Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYDUKch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYDUKch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYDUKaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:13 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37887
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/31] KVM: ia64: Stub out kvmtrace
Date: Mon, 21 Apr 2008 13:29:34 +0300
Message-Id: <1208773797-7829-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index d2e54b9..7914e48 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -43,4 +43,7 @@ config KVM_INTEL
 	  Provides support for KVM on Itanium 2 processors equipped with the VT
 	  extensions.
 
+config KVM_TRACE
+       bool
+
 endif # VIRTUALIZATION
-- 
1.5.5

