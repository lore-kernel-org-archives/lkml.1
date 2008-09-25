Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYIYL7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYIYL7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYIYLzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48553 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbYIYLzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:41 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 13/39] KVM: SVM: Fix typo
Date: Thu, 25 Sep 2008 14:54:45 +0300
Message-Id: <1222343711-12508-14-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

Fix typo in as-yet unused macro definition.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 179c2e0..be86c09 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -44,7 +44,7 @@ MODULE_LICENSE("GPL");
 
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
-#define SVM_DEATURE_SVML (1 << 2)
+#define SVM_FEATURE_SVML (1 << 2)
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
-- 
1.6.0.1

