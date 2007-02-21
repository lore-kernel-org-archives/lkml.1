Return-Path: <linux-kernel-owner+w=401wt.eu-S1422753AbXBUSSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422753AbXBUSSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422759AbXBUSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:18:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:47685 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422753AbXBUSSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:18:37 -0500
Subject: [PATCH 6/6] KVM: Bump API version
From: Avi Kivity <avi@qumranet.com>
Date: Wed, 21 Feb 2007 18:18:35 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45DC8B6E.5050205@qumranet.com>
In-Reply-To: <45DC8B6E.5050205@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070221181835.C000425016D@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7c9a400..275354f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 3
+#define KVM_API_VERSION 4
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
