Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYBWOIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYBWOIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYBWOFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:17790 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYBWOFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=OOogw7P4Wj6kA6oLJhwA5wzliZEiLBijHIJERv6pWnyV1dEH7QspgAdlIDccfzcam8PDdN/ttBfY+yRyEgivt9EQx4EGV9BrgerL7u4HGVt/9MnHswOVodSFRezI1CZt+zER6a9OMaUdwX6ZQ8DHAiX9rRaK2BDTjXG94UnSti8=
Date: Sat, 23 Feb 2008 15:05:32 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 06/10] IDE: Coding Style fixes to
 drivers/ide/legacy/ide-4drives.c
Message-ID: <20080223150532.7b33250c@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/legacy/ide-4drives.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/legacy/ide-4drives.c b/drivers/ide/legacy/ide-4drives.c
index d7bc94f..c352f12 100644
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -4,7 +4,7 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
-int probe_4drives = 0;
+int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
-- 
1.5.4.2.316.gf7a7

