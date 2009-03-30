Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZC3KC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZC3KC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZC3KCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:02:43 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbZC3KCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:42 -0400
Subject: [PATCH] toshiba-acpi: remove MAINTAINERS entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Len Brown <len.brown@intel.com>
Cc: Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 12:02:35 +0200
Message-Id: <1238407355.24972.29.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The web server at memebeam.org refuses connections and the domain no
longer has an MX entry, so apparently John Belmonte has vanished.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 MAINTAINERS |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- wireless-testing.orig/MAINTAINERS	2009-03-30 12:00:57.000000000 +0200
+++ wireless-testing/MAINTAINERS	2009-03-30 12:01:16.000000000 +0200
@@ -4294,10 +4294,7 @@ W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
 
 TOSHIBA ACPI EXTRAS DRIVER
-P:	John Belmonte
-M:	toshiba_acpi@memebeam.org
-W:	http://memebeam.org/toys/ToshibaAcpiDriver
-S:	Maintained
+S:	Orphan
 
 TOSHIBA SMM DRIVER
 P:	Jonathan Buzzard


