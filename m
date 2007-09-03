Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXICWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXICWJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 18:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXICWJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 18:09:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbXICWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 18:09:41 -0400
Date: Tue, 4 Sep 2007 03:52:50 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH -mm 2/2] 3c59x MAINTAINERS
In-Reply-To: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709040351310.8504@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate entry for the same driver.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

--- linux-2.6.23-rc4-mm1/MAINTAINERS~fix	2007-09-04 03:49:16.000000000 +0530
+++ linux-2.6.23-rc4-mm1/MAINTAINERS	2007-09-04 03:49:28.000000000 +0530
@@ -104,12 +104,6 @@ M:	klassert@mathematik.tu-chemnitz.de
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-3C59X NETWORK DRIVER
-P:	Steffen Klassert
-M:	klassert@mathematik.tu-chemnitz.de
-L:	netdev@vger.kernel.org
-S:	Maintained
-
 3CR990 NETWORK DRIVER
 P:	David Dillow
 M:	dave@thedillows.org
