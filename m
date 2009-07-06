Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZGFPkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZGFPkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZGFPjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:39:35 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42215 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZGFPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:39:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 01/16] drbd: Entry in the MAINTAINERS file for DRBD
Date: Mon,  6 Jul 2009 17:39:20 +0200
Message-Id: <1246894775-10855-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/MAINTAINERS b/MAINTAINERS
index fa2a16d..a351378 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1939,6 +1939,19 @@ S:	Maintained
 F:	drivers/scsi/dpt*
 F:	drivers/scsi/dpt/
 
+DRBD DRIVER
+P:     Philipp Reisner
+P:     Lars Ellenberg
+M:     drbd-dev@lists.linbit.com
+L:     drbd-user@lists.linbit.com
+W:     http://www.drbd.org
+T:     git git://git.drbd.org/linux-2.6-drbd.git drbd
+T:     git git://git.drbd.org/drbd-8.3.git
+S:     Supported
+F:     drivers/block/drbd/
+F:     lib/lru_cache.c
+F:     Documentation/blockdev/drbd/
+
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
