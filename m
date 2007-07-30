Return-Path: <linux-kernel-owner+w=401wt.eu-S968330AbXG3TL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968330AbXG3TL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968201AbXG3TK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:10:56 -0400
Received: from mailhost.nmt.edu ([129.138.4.52]:35908 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968134AbXG3TKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:10:54 -0400
Date: Mon, 30 Jul 2007 13:10:52 -0600
From: Valerie Henson <val@nmt.edu>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tulip-users@lists.sourceforge.net
Cc: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] tulip: Remove tulip maintainer
Message-ID: <20070730191052.GB16182@rainbow>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Val Henson as tulip maintainer and let her roam free, FREE!

Signed-off-by: Val Henson <val@nmt.edu>

--- linux-2.6.orig/MAINTAINERS
+++ linux-2.6/MAINTAINERS
@@ -3569,11 +3569,9 @@ W:	http://www.auk.cx/tms380tr/
 S:	Maintained
 
 TULIP NETWORK DRIVER
-P:	Valerie Henson
-M:	val@nmt.edu
 L:	tulip-users@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tulip/
-S:	Maintained
+S:	Orphan
 
 TUN/TAP driver
 P:	Maxim Krasnyansky
