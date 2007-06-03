Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXFCOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXFCOv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbXFCOox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:44:53 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:33742 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758386AbXFCOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:44:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Sh0j+lnnexGK5B9GUZJwUZ6+v6sJxY2QO2nPJOY9+XW4qss3L60Ae8rx0WgK9J0P5mWDC/mzqCcyp8mCmVstZZql2NycotNXbjJ3NUGSgtla5rPBQAQ1gXDDXMvJRXIUXS4sSmeBBxfLHQHtlPV6Ge54aG7Yd1yL7rYWXY2TNYk=;
X-YMail-OSG: VsNHNdgVM1k_RBStEFSVMk93adYK8FIRcpZ8DeHcyiodmdZaVtQu8zdPc3wRYefdiKreXK0zm2vZv24HY9DFbfWZhBdGzMbyS7dLzlgvXwJgIi8ke7uKfdWsDCfN2PtlGxglaCt2uA--
Date: Sun, 3 Jun 2007 07:44:50 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 36/36] drivers edac update maintainers
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <939987.84243.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Added new maintainers for the new EDAC drivers.

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---

 MAINTAINERS |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.22-rc3-mm1/MAINTAINERS
===================================================================
--- linux-2.6.22-rc3-mm1.orig/MAINTAINERS
+++ linux-2.6.22-rc3-mm1/MAINTAINERS
@@ -1377,6 +1377,27 @@ L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
+EDAC-I82443BXGX
+P:	Tim Small
+M:	tim@buttersideup.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I3000
+P:	Jason Uhlenkott
+M:	juhlenko@akamai.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
+EDAC-I5000
+P:	Doug Thompson
+M:	norsk5@xmission.com
+L:	bluesmoke-devel@lists.sourceforge.net
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+
 EDAC-R82600
 P:	Tim Small
 M:	tim@buttersideup.com

