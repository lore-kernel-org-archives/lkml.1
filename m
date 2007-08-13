Return-Path: <linux-kernel-owner+w=401wt.eu-S944572AbXHMLdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944572AbXHMLdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939280AbXHMGij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2215 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939271AbXHMGii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:38 -0400
Date: Sun, 12 Aug 2007 23:38:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, smurf@smurf.noris.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [502/2many] MAINTAINERS - USB OPTION-CARD DRIVER
Message-ID: <46bffc60.d3vgI8/TucUOIemK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 94ce5ce..23b7c3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4746,6 +4746,7 @@ P:	Matthias Urlichs
 M:	smurf@smurf.noris.de
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/option.c
 
 USB OV511 DRIVER
 P:	Mark McClelland
