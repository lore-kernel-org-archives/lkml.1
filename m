Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbXFUWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbXFUWR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXFUWRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:17:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbXFUWRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:17:21 -0400
Date: Thu, 21 Jun 2007 15:18:35 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: greg@kroah.com
Cc: zaitcev@redhat.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, <vojtech@suse.cz>
Subject: USB: Take over usblp
Message-Id: <20070621151835.472feff1.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech agreed to pass usblp over to me, so if you find bugs don't bug him.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3702,12 +3702,12 @@ L:	linux-usb-devel@lists.sourceforge.net
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 
-USB PRINTER DRIVER
-P:	Vojtech Pavlik
-M:	vojtech@suse.cz
+USB PRINTER DRIVER (usblp)
+P:	Pete Zaitcev
+M:	zaitcev@redhat.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
-S:	Maintained
+S:	Supported
 
 USB RTL8150 DRIVER
 P:	Petko Manolov
