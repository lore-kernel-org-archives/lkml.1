Return-Path: <linux-kernel-owner+w=401wt.eu-S1161026AbXBTWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161026AbXBTWpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXBTWpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:45:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45568 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbXBTWp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:45:29 -0500
Date: Tue, 20 Feb 2007 16:45:27 -0600
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kou.ishizaki@toshiba.co.jp, arnd@arndb.de,
       Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] spidernet: maintainership
Message-ID: <20070220224526.GL28895@austin.ibm.com>
References: <20070220221314.GU923@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220221314.GU923@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Update driver support contact info.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

----
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.20-git16/MAINTAINERS
===================================================================
--- linux-2.6.20-git16.orig/MAINTAINERS	2007-02-20 14:23:52.000000000 -0600
+++ linux-2.6.20-git16/MAINTAINERS	2007-02-20 15:02:53.000000000 -0600
@@ -3178,8 +3178,8 @@ L:	linux-kernel@vger.kernel.org ?
 S:	Supported
 
 SPIDERNET NETWORK DRIVER for CELL
-P:	Jim Lewis
-M:	jim@jklewis.com
+P:	Linas Vepstas
+M:	linas@austin.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
