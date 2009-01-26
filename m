Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZAZCHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZAZCHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZAZCGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:06:53 -0500
Received: from vps1.tull.net ([66.180.172.116]:36459 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753332AbZAZCGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:06:53 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 14/20] Fix misspelling of firmware in disk.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:06:45 +1100
Message-ID: <20090126020645.15168.17198.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in disk.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 kernel/power/disk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 45e8541..760e863 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -249,7 +249,7 @@ static int create_image(int platform_mode)
  *	hibernation_snapshot - quiesce devices and create the hibernation
  *	snapshot image.
  *	@platform_mode - if set, use the platform driver, if available, to
- *			 prepare the platform frimware for the power transition.
+ *			 prepare the platform firmware for the power transition.
  *
  *	Must be called with pm_mutex held
  */
@@ -360,7 +360,7 @@ static int resume_target_kernel(void)
  *	hibernation_restore - quiesce devices and restore the hibernation
  *	snapshot image.  If successful, control returns in hibernation_snaphot()
  *	@platform_mode - if set, use the platform driver, if available, to
- *			 prepare the platform frimware for the transition.
+ *			 prepare the platform firmware for the transition.
  *
  *	Must be called with pm_mutex held
  */

