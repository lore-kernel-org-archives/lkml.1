Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZAZCG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZAZCG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZAZCGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:06:45 -0500
Received: from vps1.tull.net ([66.180.172.116]:36457 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751293AbZAZCGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:06:45 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 01/20] Fix misspelling of "firmware" in ia64-kvm.txt
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 12:59:57 +1100
Message-ID: <20090126015956.15168.55248.stgit@marcab.local.tull.net>
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

Fix misspelling of "firmware" in ia64-kvm.txt

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 Documentation/ia64/kvm.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/Documentation/ia64/kvm.txt b/Documentation/ia64/kvm.txt
index 84f7cb3..ffb5c80 100644
--- a/Documentation/ia64/kvm.txt
+++ b/Documentation/ia64/kvm.txt
@@ -42,7 +42,7 @@ Note: For step 2, please make sure that host page size == TARGET_PAGE_SIZE of qe
 		hg clone http://xenbits.xensource.com/ext/efi-vfirmware.hg
 	    you can get the firmware's binary in the directory of efi-vfirmware.hg/binaries.
 
-	(3) Rename the firware you owned to Flash.fd, and copy it to /usr/local/share/qemu
+	(3) Rename the firmware you owned to Flash.fd, and copy it to /usr/local/share/qemu
 
 4. Boot up Linux or Windows guests:
 	4.1 Create or install a image for guest boot. If you have xen experience, it should be easy.

