Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXAZRP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXAZRP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030843AbXAZRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:15:57 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030761AbXAZRP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:15:56 -0500
Date: Fri, 26 Jan 2007 09:15:47 -0800
From: "H. Peter Anvin" <hpa@anvin.org>
Message-Id: <200701261715.l0QHFlND013482@tazenda.hos.anvin.org>
To: akpm@osdl.org, etienne_lorrain@yahoo.fr, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] Boot loader ID for Gujin
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an official boot loader ID for Gujin.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>

---
commit 1edec5c931a67413245cd41c10694a69f7750497
tree cd7838958c199bbc1f9f0e819aaf12d58e9b6ef7
parent 44597f65f6af3c692560a639f61d25398d13d1b6
author H. Peter Anvin <hpa@zytor.com> Fri, 26 Jan 2007 09:07:01 -0800
committer H. Peter Anvin <hpa@zytor.com> Fri, 26 Jan 2007 09:07:01 -0800

 Documentation/i386/boot.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index c51314b..477dad2 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2005-09-02
+			Last update 2007-01-26
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -182,6 +182,7 @@ filled out, however:
 	7  GRuB
 	8  U-BOOT
 	9  Xen
+	A  Gujin
 
 	Please contact <hpa@zytor.com> if you need a bootloader ID
 	value assigned.
