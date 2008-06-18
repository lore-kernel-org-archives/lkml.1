Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYFRVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYFRVnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFRVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:42:52 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56184 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYFRVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:42:51 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 17:42:51 EDT
Date: Wed, 18 Jun 2008 23:42:28 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] MFD maintainer
Message-ID: <20080618214223.GE22566@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We probably need someone to look after the few drivers/mfd patches coming
every now and then. As agreed with Andrew, I'm ok to do so and my employer
is fine with me spending a few working hours on it, if needed.
Ben, Philipp, feel free to add your names there too if you wish.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
--

 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd587ee..f45938b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2814,6 +2814,12 @@ W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
+MULTIFUNCTION DEVICES (MFD)
+P:	Samuel Ortiz
+M:	sameo@openedhand.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
