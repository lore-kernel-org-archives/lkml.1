Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXCSTuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXCSTuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXCSTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:50:35 -0400
Received: from saeurebad.de ([85.214.36.134]:54123 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbXCSTue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:50:34 -0400
Date: Mon, 19 Mar 2007 20:45:57 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH] Documentation/sysrq.txt: added short description for 'Q' (timerlist)
Message-ID: <20070319194556.GB11921@leiferikson>
Mail-Followup-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I added the 'Q' to list. A short description in the `Ok, so what can I
use them for'-section, on when or why to use it would be nice!

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sysrq-timer-list-key.patch"

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 452c0f1..d43aa9d 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -93,6 +93,8 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 
 'p'     - Will dump the current registers and flags to your console.
 
+'q'     - Will dump a list of all running timers.
+
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
 's'     - Will attempt to sync all mounted filesystems.

--qcHopEYAB45HaUaB--
