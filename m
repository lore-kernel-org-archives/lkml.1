Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZJQXrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZJQXrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZJQXrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:47:04 -0400
Received: from mail.perches.com ([173.55.12.10]:2247 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZJQXrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:47:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] MAINTAINERS: VMWARE VMXNET3 - Quote name with comma and period, use tabs
Date: Sat, 17 Oct 2009 16:47:04 -0700
Message-Id: <aac38fb155b241f00d025d7746236b498264e3ff.1255822797.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255822797.git.joe@perches.com>
References: <cover.1255822797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Names with periods or commas need to be quoted
Use tab not spaces

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e0a3e52..f40dcce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5663,11 +5663,11 @@ F:	drivers/vlynq/vlynq.c
 F:	include/linux/vlynq.h
 
 VMWARE VMXNET3 ETHERNET DRIVER
-M:     Shreyas Bhatewara <sbhatewara@vmware.com>
-M:     VMware, Inc. <pv-drivers@vmware.com>
-L:     netdev@vger.kernel.org
-S:     Maintained
-F:     drivers/net/vmxnet3/
+M:	Shreyas Bhatewara <sbhatewara@vmware.com>
+M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/vmxnet3/
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
 M:	Liam Girdwood <lrg@slimlogic.co.uk>
-- 
1.6.5.rc3.dirty

