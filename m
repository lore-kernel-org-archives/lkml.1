Return-Path: <linux-kernel-owner+w=401wt.eu-S966840AbXHMLcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966840AbXHMLcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939225AbXHMGih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2199 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966931AbXHMGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:32 -0400
Date: Sun, 12 Aug 2007 23:38:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, oliver@neukum.name,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [499/2many] MAINTAINERS - USB KAWASAKI LSI DRIVER
Message-ID: <46bffc5b.UHe9Khg144/oPYAL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2759bc8..94d4bac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4721,6 +4721,7 @@ M:	oliver@neukum.name
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/kl5kusb105.*
 
 USB MASS STORAGE DRIVER
 P:	Matthew Dharm
