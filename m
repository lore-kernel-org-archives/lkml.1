Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZFFRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZFFRQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 13:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZFFRQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 13:16:11 -0400
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:49551 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZFFRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 13:16:11 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 13:16:10 EDT
Message-ID: <4A2AA21C.4020401@freemail.hu>
Date: Sat, 06 Jun 2009 19:06:36 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: fix missing space typo in doc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32721; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc7/Documentation/usb/callbacks.txt.orig	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.30-rc7/Documentation/usb/callbacks.txt	2009-06-03 19:51:07.000000000 +0200
@@ -65,7 +65,7 @@ Accept or decline an interface. If you a
 otherwise -ENODEV or -ENXIO. Other error codes should be used only if a
 genuine error occurred during initialisation which prevented a driver
 from accepting a device that would else have been accepted.
-You are strongly encouraged to use usbcore'sfacility,
+You are strongly encouraged to use usbcore's facility,
 usb_set_intfdata(), to associate a data structure with an interface, so
 that you know which internal state and identity you associate with a
 particular interface. The device will not be suspended and you may do IO
