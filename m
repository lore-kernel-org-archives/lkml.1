Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXIQJJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXIQJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXIQIeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:21 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 008/104] KVM: Trivial: Comment spelling may escape grep
Date: Mon, 17 Sep 2007 10:30:50 +0200
Message-Id: <11900179462917-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Speling error in comment.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f5e4644..db9f955 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -6,7 +6,7 @@
  * Copyright (c) 2005 Keir Fraser
  *
  * Linux coding style, mod r/m decoder, segment base fixes, real-mode
- * privieged instructions:
+ * privileged instructions:
  *
  * Copyright (C) 2006 Qumranet
  *
-- 
1.5.3

