Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYH0Bbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYH0Bbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYH0Bbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:31:38 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45798 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYH0Bbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:31:37 -0400
Date: Tue, 26 Aug 2008 19:31:36 -0600
From: Alex Chiang <achiang@hp.com>
To: jkosina@suse.cz
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix grammo in HID_COMPAT Kconfig help text
Message-ID: <20080827013136.GA21966@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jkosina@suse.cz,
	jirislaby@gmail.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig option for HID_COMPAT should read "lose", not "loose".

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4319af3..46337a2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -78,7 +78,7 @@ config HID_COMPAT
 	support of module loading through aliases and also old
 	module-init-tools which can't handle hid bus, choose Y here. Otherwise
 	say N. If you say N and your userspace is old enough, the only
-	functionality you loose is modules autoloading.
+	functionality you lose is modules autoloading.
 
 	If unsure, say Y.
 
