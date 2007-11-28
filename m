Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXK1WyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXK1WyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbXK1Wxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:57412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761988AbXK1Wxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hans J Koch <hjk@linutronix.de>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] UIO: add UIO documentation target to DocBook Makefile
Date: Wed, 28 Nov 2007 14:52:18 -0800
Message-Id: <1196290340-28828-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J Koch <hjk@linutronix.de>

Add the DocBook documentation for the Userspace I/O framework
to the Makefile.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 054a7ec..4953bc2 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mcabook.xml videobook.xml \
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml
+	    genericirq.xml s390-drivers.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
-- 
1.5.3.4

