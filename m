Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbXISFI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbXISFI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXISFIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:08:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42519 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbXISFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:07:59 -0400
Date: Tue, 18 Sep 2007 22:05:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] sound/hda: fix help text
Message-Id: <20070918220524.8024e503.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hda help text typo.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc6-mm1.orig/sound/pci/Kconfig
+++ linux-2.6.23-rc6-mm1/sound/pci/Kconfig
@@ -506,7 +506,7 @@ config SND_HDA_HWDEP
 	select SND_HWDEP
 	help
 	  Say Y here to build a hwdep interface for HD-audio driver.
-	  This interface can be used for out-of-bound communication
+	  This interface can be used for out-of-band communication
 	  with codecs for debugging purposes.
 
 config SND_HDA_CODEC_REALTEK
