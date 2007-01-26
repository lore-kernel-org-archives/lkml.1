Return-Path: <linux-kernel-owner+w=401wt.eu-S1030874AbXAZQw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874AbXAZQw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030804AbXAZQw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:52:56 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:19180 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030786AbXAZQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:52:46 -0500
Date: Fri, 26 Jan 2007 17:52:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] Update maintainers file.
Message-ID: <20070126165242.GR11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] Update maintainers file.

Use the new linux-s390@vger.kernel.org mailing list instead of
linux-390@vm.marist.edu.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/MAINTAINERS linux-2.6-patched/MAINTAINERS
--- linux-2.6/MAINTAINERS	2007-01-26 17:27:37.000000000 +0100
+++ linux-2.6-patched/MAINTAINERS	2007-01-26 17:28:04.000000000 +0100
@@ -2799,7 +2799,7 @@ M:	schwidefsky@de.ibm.com
 P:	Heiko Carstens
 M:	heiko.carstens@de.ibm.com
 M:	linux390@de.ibm.com
-L:	linux-390@vm.marist.edu
+L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 
@@ -2807,7 +2807,7 @@ S390 NETWORK DRIVERS
 P:	Frank Pavlic
 M:	fpavlic@de.ibm.com
 M:	linux390@de.ibm.com
-L:	linux-390@vm.marist.edu
+L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 
@@ -2815,7 +2815,7 @@ S390 ZFCP DRIVER
 P:	Swen Schillig
 M:	swen@vnet.ibm.com
 M:	linux390@de.ibm.com
-L:	linux-390@vm.marist.edu
+L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 
