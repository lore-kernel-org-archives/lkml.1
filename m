Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXHMJxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXHMJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967143AbXHMGds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1391 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967128AbXHMGdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:37 -0400
Date: Sun, 12 Aug 2007 23:33:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, proski@gnu.org,
       orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, hermes@gibson.dropbear.id.au,
       akpm@linux-foundation.org
Subject: [PATCH] [360/2many] MAINTAINERS - ORINOCO DRIVER
Message-ID: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 96aeb40..f374fa8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3463,6 +3463,7 @@ L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
+F:	drivers/net/wireless/orinoco*
 
 PA SEMI ETHERNET DRIVER
 P:	Olof Johansson
