Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZIXSnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZIXSnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZIXSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:41:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1151 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZIXSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/11] MAINTAINERS: Update GENERIC UIO FOR PCI DEVICES
Date: Thu, 24 Sep 2009 11:41:49 -0700
Message-Id: <4d102da869e0b56592b316cabb7e8a6f52e50e71.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote a name with a period
remove L: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e797c4d..f8cea20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2236,9 +2236,8 @@ S:	Maintained
 F:	include/asm-generic
 
 GENERIC UIO DRIVER FOR PCI DEVICES
-M:	Michael S. Tsirkin <mst@redhat.com>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
-- 
1.6.3.1.10.g659a0.dirty

