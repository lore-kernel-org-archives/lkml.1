Return-Path: <linux-kernel-owner+w=401wt.eu-S937533AbXGQX5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937533AbXGQX5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937365AbXGQX4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:56:55 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11649 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762980AbXGQX4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:56:53 -0400
Date: Tue, 17 Jul 2007 18:03:34 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/6] drivers edac add to maintainers new info
Message-ID: <469d58d6.Kzg6fu1oseNgJwdZ%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Update maintainer information on edac components

Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 MAINTAINERS |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc6-mm1/MAINTAINERS
===================================================================
--- linux-2.6.22-rc6-mm1.orig/MAINTAINERS
+++ linux-2.6.22-rc6-mm1/MAINTAINERS
@@ -1352,21 +1352,23 @@ S:	Supported
 
 EDAC-CORE
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
 
 EDAC-E752X
 P:	Mark Gross
+P:	Doug Thompson
 M:	mark.gross@intel.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
 EDAC-E7XXX
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -1387,7 +1389,23 @@ S:	Maintained
 
 EDAC-I5000
 P:	Doug Thompson
-M:	norsk5@xmission.com
+M:	dougthompson@xmission.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I82975X
+P:	Ranganathan Desikan
+P:	Arvind R.
+M:	rdesikan@jetzbroadband.com
+M:	arvind@acarlab.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-PASEMI
+P:	Egor Martovetsky
+M:	egor@pasemi.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
