Return-Path: <linux-kernel-owner+w=401wt.eu-S936270AbZLQEH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936270AbZLQEH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935738AbZLQEHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:07:09 -0500
Received: from kroah.org ([198.145.64.141]:52318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936217AbZLQEGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:06:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035702.312208598@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: [149/151] netfilter: xtables: document minimal required version
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Engelhardt <jengelh@medozas.de>

commit 7a92263705435d046d37a0990d0edfcb517f7ad3 upstream.

For both .33 and .32-stable.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/Changes |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -49,6 +49,8 @@ o  oprofile               0.9           
 o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
 o  mcelog		  0.6
+o  iptables               1.4.1                   # iptables -V
+
 
 Kernel compilation
 ==================


