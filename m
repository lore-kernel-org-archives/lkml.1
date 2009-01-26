Return-Path: <linux-kernel-owner+w=401wt.eu-S1751004AbZAZCCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbZAZCCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZAZCCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:02:00 -0500
Received: from vps1.tull.net ([66.180.172.116]:50671 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751533AbZAZCB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:01:59 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 04/20] Fix misspelling of firmware in thinkpad_acpi.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:01:31 +1100
Message-ID: <20090126020131.15168.51958.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in thinkpad_acpi.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index bcbc051..54e0cbc 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5811,7 +5811,7 @@ static struct ibm_struct volume_driver_data = {
  *	ThinkPads from this same time period (and earlier) probably lack the
  *	tachometer as well.
  *
- *	Unfortunately a lot of ThinkPads with new-style ECs but whose firwmare
+ *	Unfortunately a lot of ThinkPads with new-style ECs but whose firmware
  *	was never fixed by IBM to report the EC firmware version string
  *	probably support the tachometer (like the early X models), so
  *	detecting it is quite hard.  We need more data to know for sure.

