Return-Path: <linux-kernel-owner+w=401wt.eu-S970034AbXHMIhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970034AbXHMIhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966592AbXHMG3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4700 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966595AbXHMG3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:48 -0400
Date: Sun, 12 Aug 2007 23:29:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rolandd@cisco.com, mshefty@ichips.intel.com,
       linux-kernel@vger.kernel.org, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: [PATCH] [247/2many] MAINTAINERS - INFINIBAND SUBSYSTEM
Message-ID: <46bffa4d.lrrIPefFmHe22+xM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index afc7780..7460778 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2341,6 +2341,9 @@ L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
+F:	Documentation/infiniband/
+F:	drivers/infiniband/
+F:	include/linux/if_infiniband.h
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
