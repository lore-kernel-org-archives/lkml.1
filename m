Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXFOTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXFOTgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbXFOTft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:35:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53876 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbXFOTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:35:48 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 15 Jun 2007 15:33:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: dtor@mail.ru, dmitry.torokhov@gmail.com
Subject: [PATCH] Update MAINTAINERS to explicitly mention touchscreens.
Message-ID: <Pine.LNX.4.64.0706151532430.16641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c715a7..1f16787 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1846,7 +1846,7 @@ W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported

-INPUT (KEYBOARD, MOUSE, JOYSTICK) DRIVERS
+INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
