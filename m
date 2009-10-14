Return-Path: <linux-kernel-owner+w=401wt.eu-S934776AbZJNP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbZJNP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZJNP7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:59:45 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35128 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694AbZJNP7n (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 11:59:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [NET PATCH 1/9] venet: Update maintainer
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 14 Oct 2009 11:58:51 -0400
Message-ID: <20091014155851.18864.89239.stgit@dev.haskins.net>
In-Reply-To: <20091014154457.18864.28382.stgit@dev.haskins.net>
References: <20091014154457.18864.28382.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe97eb1..55fabad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5617,6 +5617,13 @@ S:	Maintained
 F:	include/linux/vbus*
 F:	drivers/vbus/*
 
+VBUS ETHERNET DRIVER
+M:	Gregory Haskins <ghaskins@novell.com>
+S:	Maintained
+W:	http://developer.novell.com/wiki/index.php/AlacrityVM
+F:	include/linux/venet.h
+F:	drivers/net/vbus-enet.c
+
 VFAT/FAT/MSDOS FILESYSTEM
 M:	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
 S:	Maintained

