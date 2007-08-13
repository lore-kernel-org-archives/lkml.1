Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXHML64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXHML64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967503AbXHMGjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2438 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967496AbXHMGjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:53 -0400
Date: Sun, 12 Aug 2007 23:39:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: [PATCH] [539/2many] MAINTAINERS - W83L51xD SD/MMC CARD INTERFACE
 DRIVER
Message-ID: <46bffcaa.WjxiY3mQd2T6Hf5B%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index dcbcd74..71ffe5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5095,6 +5095,7 @@ M:	drzeus-wbsd@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 W:	http://projects.drzeus.cx/wbsd
 S:	Maintained
+F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
