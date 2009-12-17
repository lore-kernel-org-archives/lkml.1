Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbZLQEja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbZLQEja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936641AbZLQEif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:38:35 -0500
Received: from kroah.org ([198.145.64.141]:55484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763967AbZLQEEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:49 2009
Message-Id: <20091217035649.141399735@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [048/151] USB: xhci: Add correct email and files to MAINTAINERS entry.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 36d0344c254a7b333272757f858c403ea3a2d29f upstream.

Add the xHCI driver files to its MAINTAINERS entry so that I'm Cc'd on
cleanup patches.  Update the email address to one I actually use for
sending patches and responding to Linux mailing list emails.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5594,9 +5594,11 @@ S:	Maintained
 F:	drivers/net/wireless/rndis_wlan.c
 
 USB XHCI DRIVER
-M:	Sarah Sharp <sarah.a.sharp@intel.com>
+M:	Sarah Sharp <sarah.a.sharp@linux.intel.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
+F:	drivers/usb/host/xhci*
+F:	drivers/usb/host/pci-quirks*
 
 USB ZC0301 DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>


