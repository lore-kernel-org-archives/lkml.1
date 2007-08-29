Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbXH2RWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbXH2RWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXH2RW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:22:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46185 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbXH2RW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:22:28 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 29 Aug 2007 13:11:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: lenb@kernel.org, trivial@kernel.org
Subject: [PATCH] Documentation:  Remove remaining useless reference to
 acpi_fake_ecdt.
Message-ID: <Pine.LNX.4.64.0708291309020.29146@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b:

"Similar functionality was turned on by acpi_fake_ecdt=1 command line
before. Now it is on all the time."

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b41cde3..4395ee8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -218,9 +218,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Warning: Many of these options can produce a lot of
 			output and make your system unusable. Be very careful.

-
-	acpi_fake_ecdt	[HW,ACPI] Workaround failure due to BIOS lacking ECDT
-
 	acpi_pm_good	[X86-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
