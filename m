Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZJUMoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZJUMoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 08:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZJUMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 08:44:01 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50773 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZJUMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 08:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=v4+ykMcu9ghgRWzdfGyK1AR0kHh61A0piNZIxIawaJMiv7m8QXMbgmIkR/B3c6Ytkg
         sFpDASOlGg6LAHiazWib04GaZOsYyKgag8/4jLECNqVpgbjszCd+1sW12akDdbhI5QCw
         lAw0MSMQNV6B8DAQj1e5e3WMAkI/hvxhedfBo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Staging: update TODO files
Date: Wed, 21 Oct 2009 14:42:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910211442.11785.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: update TODO files

Remove my mail address.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/TODO |    3 +--
 drivers/staging/rtl8192su/TODO |    3 +--
 drivers/staging/vt6655/TODO    |    5 ++---
 drivers/staging/vt6656/TODO    |    5 ++---
 4 files changed, 6 insertions(+), 10 deletions(-)

Index: b/drivers/staging/rtl8187se/TODO
===================================================================
--- a/drivers/staging/rtl8187se/TODO
+++ b/drivers/staging/rtl8187se/TODO
@@ -11,5 +11,4 @@ TODO:
 - sparse fixes
 - integrate with drivers/net/wireless/rtl818x
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
-Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>.
Index: b/drivers/staging/rtl8192su/TODO
===================================================================
--- a/drivers/staging/rtl8192su/TODO
+++ b/drivers/staging/rtl8192su/TODO
@@ -14,5 +14,4 @@ TODO:
 - sparse fixes
 - integrate with drivers/net/wireless/rtl818x
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
-Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>.
Index: b/drivers/staging/vt6655/TODO
===================================================================
--- a/drivers/staging/vt6655/TODO
+++ b/drivers/staging/vt6655/TODO
@@ -16,6 +16,5 @@ TODO:
 - sparse fixes
 - integrate with drivers/net/wireless
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
-Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
-<bzolnier@gmail.com>.
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
+and Forest Bond <forest@alittletooquiet.net>.
Index: b/drivers/staging/vt6656/TODO
===================================================================
--- a/drivers/staging/vt6656/TODO
+++ b/drivers/staging/vt6656/TODO
@@ -15,6 +15,5 @@ TODO:
 - sparse fixes
 - integrate with drivers/net/wireless
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
-Forest Bond <forest@alittletooquiet.net> and Bartlomiej Zolnierkiewicz
-<bzolnier@gmail.com>.
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
+and Forest Bond <forest@alittletooquiet.net>.
