Return-Path: <linux-kernel-owner+w=401wt.eu-S937302AbXGRXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937302AbXGRXgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936176AbXGRX1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:57575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936451AbXGRX1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] zh_CN/HOWTO: update URLs of git trees
Date: Wed, 18 Jul 2007 16:26:43 -0700
Message-Id: <1184801229849-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848012222611-git-send-email-gregkh@suse.de>
References: <20070718232346.GB4620@kroah.com>
 <11848012031961-git-send-email-gregkh@suse.de>
 <11848012093296-git-send-email-gregkh@suse.de>
 <11848012151444-git-send-email-gregkh@suse.de>
 <11848012222611-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leoli@freescale.com>

Addressing patch from Stefan Richter:
HOWTO: update URLs of git trees
(It will be better if we update this to commit-id later)

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/HOWTO |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 239f454..48fc67b 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -281,39 +281,37 @@ linux-kernel邮件列表中提供反馈，告诉大家你遇到了问题还是�
 下面是目前可用的一些内核源码树的列表：
   通过git管理的源码树：
     - Kbuild开发源码树， Sam Ravnborg <sam@ravnborg.org>
-	kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 
     - ACPI开发源码树, Len Brown <len.brown@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
     - 块设备开发源码树, Jens Axboe <axboe@suse.de>
-	kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM开发源码树, Dave Airlie <airlied@linux.ie>
-	kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 
     - ia64开发源码树, Tony Luck <tony.luck@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 
     - ieee1394开发源码树, Jody McIntyre <scjody@modernduck.com>
-	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
+	git.kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
 
     - infiniband开发源码树, Roland Dreier <rolandd@cisco.com>
-	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 
     - libata开发源码树, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 
     - 网络驱动程序开发源码树, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 
     - pcmcia开发源码树, Dominik Brodowski <linux@dominikbrodowski.net>
-	kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 
     - SCSI开发源码树, James Bottomley <James.Bottomley@SteelEye.com>
-	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-  其他git管理的内核源码树可以在http://kernel.org/git的列表中找到
+	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
   使用quilt管理的补丁集：
     - USB, PCI, 驱动程序核心和I2C, Greg Kroah-Hartman <gregkh@suse.de>
@@ -321,6 +319,8 @@ linux-kernel邮件列表中提供反馈，告诉大家你遇到了问题还是�
     - x86-64, 部分i386, Andi Kleen <ak@suse.de>
 	ftp.firstfloor.org:/pub/ak/x86_64/quilt/
 
+  其他内核源码树可以在http://git.kernel.org的列表中和MAINTAINERS文件里
+  找到。
 
 报告bug
 -------
-- 
1.5.2.2

