Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0BJR06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/40] KVM: powerpc: Change maintainer
Date: Wed, 10 Feb 2010 19:22:53 +0200
Message-Id: <1265822589-11155-25-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Progress on KVM for Embedded PowerPC has stalled, but for Book3S there's quite
a lot of work to do and going on.

So in agreement with Hollis and Avi, we should switch maintainers for PowerPC.

Signed-off-by: Alexander Graf <agraf@suse.de>
Acked-by: Hollis Blanchard <hollis@penguinppc.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03f38c1..6c99c00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3136,7 +3136,7 @@ F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
-M:	Hollis Blanchard <hollisb@us.ibm.com>
+M:	Alexander Graf <agraf@suse.de>
 L:	kvm-ppc@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
-- 
1.6.5.3

