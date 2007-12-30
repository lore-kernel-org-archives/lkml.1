Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXL3HUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXL3HUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbXL3HLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:59499 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbXL3HKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 32/52] KVM: Export include/asm-x86/kvm.h
Date: Sun, 30 Dec 2007 09:10:18 +0200
Message-Id: <1198998638-22713-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 12db5a1..da5eb69 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -3,6 +3,7 @@ include include/asm-generic/Kbuild.asm
 header-y += boot.h
 header-y += bootparam.h
 header-y += debugreg.h
+header-y += kvm.h
 header-y += ldt.h
 header-y += msr-index.h
 header-y += prctl.h
-- 
1.5.3.7

