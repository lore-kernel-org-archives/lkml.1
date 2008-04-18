Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYDRQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYDRQeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYDRQd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:33:56 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:45241 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYDRQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:33:55 -0400
From: Timur Tabi <timur@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>
Subject: [PATCH] Add Timur Tabi to the MAINTAINERS file
Date: Fri, 18 Apr 2008 11:33:28 -0500
Message-Id: <12085364084040-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Timur TAbi as the maintainer for the Freescale QE library, the Freescale
QE UART device driver, the Freescale SOC sound drivers, and the Crystal
Semiconductor CS4270 device driver.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

This patch is for 2.6.26.

 MAINTAINERS |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90dcbbc..7a8bc0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1104,6 +1104,12 @@ M:	kernel@wantstofly.org
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 
+CIRRUS LOGIC CS4270 SOUND DRIVER
+P:	Timur Tabi
+M:	timur@freescale.com
+L:	alsa-devel@alsa-project.org
+S:	Supported
+
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Cirrus Logic Corporation (kernel 2.2 driver)
 M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
@@ -1626,6 +1632,12 @@ L:	linuxppc-dev@ozlabs.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+FREESCALE QUICC ENGINE LIBRARY
+P:	Timur Tabi
+M:	timur@freescale.com
+L:	linuxppc-dev@ozlabs.org
+S:	Supported
+
 FREESCALE HIGHSPEED USB DEVICE DRIVER
 P:	Li Yang
 M:	leoli@freescale.com
@@ -1640,6 +1652,19 @@ L:	netdev@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
+FREESCALE QUICC ENGINE UCC UART DRIVER
+P:	Timur Tabi
+M:	timur@freescale.com
+L:	linuxppc-dev@ozlabs.org
+S:	Supported
+
+FREESCALE SOC SOUND DRIVERS
+P:	Timur Tabi
+M:	timur@freescale.com
+L:	alsa-devel@alsa-project.org
+L:	linuxppc-dev@ozlabs.org
+S:	Supported
+
 FILE LOCKING (flock() and fcntl()/lockf())
 P:	Matthew Wilcox
 M:	matthew@wil.cx
-- 
1.5.3

