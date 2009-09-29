Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZI2WN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZI2WN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZI2WN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:13:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZI2WN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aSGWH0zt8n/HKrVol0T7HKXJ7fUp4jUiHGS5mMPVVJfln4DgFZWDLBfnbWSOeubVbY
         zfewc9oXii222DZXq+m7rGPcn0AHFc1IqgUBgLsZ47l2C7YrfT+CFlMoDITcvuFtAsCv
         sq7s11qF89WIxzA5SW2twJqQ2sqa1ocnWg/WY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Update the e-mail for the userspace tools to use ohci1394_dma=early for debugging. Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Date: Tue, 29 Sep 2009 15:13:58 -0700
Message-Id: <1254262438-31323-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
References: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Documentation/debugging-via-ohci1394.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
index 59a91e5..8be3c78 100644
--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.txt
@@ -64,14 +64,14 @@ be used to view the printk buffer of a remote machine, even with live update.
 
 Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
 from 32-bit firescope and vice versa:
-- ftp://ftp.suse.de/private/bk/firewire/tools/firescope-0.2.2.tar.bz2
+- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
 
 and he implemented fast system dump (alpha version - read README.txt):
-- ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
+- http://halobates.de/firewire/firedump-0.1.tar.bz2
 
 There is also a gdb proxy for firewire which allows to use gdb to access
 data which can be referenced from symbols found by gdb in vmlinux:
-- ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
+- http://halobates.de/firewire/fireproxy-0.33.tar.bz2
 
 The latest version of this gdb proxy (fireproxy-0.34) can communicate (not
 yet stable) with kgdb over an memory-based communication module (kgdbom).
@@ -178,7 +178,7 @@ Step-by-step instructions for using firescope with early OHCI initialization:
 
 Notes
 -----
-Documentation and specifications: ftp://ftp.suse.de/private/bk/firewire/docs
+Documentation and specifications: http://halobates.de/firewire/ 
 
 FireWire is a trademark of Apple Inc. - for more information please refer to:
 http://en.wikipedia.org/wiki/FireWire
-- 
1.6.5.rc2

