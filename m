Return-Path: <linux-kernel-owner+w=401wt.eu-S1030540AbXBAIRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540AbXBAIRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030530AbXBAIRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:17:13 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:3207 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030540AbXBAIRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:17:12 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 03:17:12 EST
Date: Thu, 1 Feb 2007 08:09:24 +0000
From: Jon Masters <jonathan@jonmasters.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update MAINTAINERS file entry for module-init-tools
Message-ID: <20070201080924.GB32510@dallas.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jcm@dallas.jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters has taken over upstream maintainership of module-init-tools from
Rusty, update MAINTAINERS file to reflect this change and to provide
information about the location of new releases and the mailing list.

Signed-off-by: Jon Masters <jcm@jonmasters.org>

---
 MAINTAINERS |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0e3361..bd502a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2204,9 +2204,10 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 MODULE SUPPORT
-P:	Rusty Russell
-M:	rusty@rustcorp.com.au
-L:	linux-kernel@vger.kernel.org
+P:	Jon Masters
+M:	jcm@jonmasters.org
+L:	mit-devel@lists.printk.net
+W:	http://www.kerneltools.org/
 S:	Maintained
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
-- 
1.4.4.2

