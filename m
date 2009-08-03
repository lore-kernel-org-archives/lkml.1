Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZHCUdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZHCUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZHCUdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:33:44 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2532 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbZHCUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:33:43 -0400
Subject: MAINTAINERS: standardize James Bottomley's name
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 13:32:50 -0700
Message-Id: <1249331570.5149.48.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

His recent patches and sign-offs have not used "E.J."

This reduces the likelihood that get_maintainers.pl will
list his address twice.

Section "MISCELLANEOUS MCA-SUPPORT" already uses this style.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..a7288e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -137,7 +137,7 @@ S:	Supported
 F:	drivers/scsi/3w-xxxx*
 
 53C700 AND 53C700-66 SCSI DRIVER
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/53c700*
@@ -3033,7 +3033,7 @@ F:	include/*/lapb.h
 F:	net/lapb/
 
 LASI 53c700 driver for PARISC
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/53c700.txt
@@ -3469,7 +3469,7 @@ S:	Maintained
 F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/NCR_D700.*
@@ -4394,7 +4394,7 @@ F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
-M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git



