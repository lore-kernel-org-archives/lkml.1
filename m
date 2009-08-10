Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZHJSkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZHJSkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZHJSkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:40:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2644 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZHJSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:40:51 -0400
Subject: [PATCH] MAINTAINERS: OSD LIBRARY and FILESYSTEM pattern fix
From: Joe Perches <joe@perches.com>
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 11:40:31 -0700
Message-Id: <1249929631.8895.47.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..50f25e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3796,7 +3796,7 @@ W:	http://open-osd.org
 T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
 F:	drivers/scsi/osd/
-F:	drivers/include/scsi/osd_*
+F:	include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER


