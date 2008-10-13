Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYJMXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYJMXic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760753AbYJMXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:38:20 -0400
Received: from fw.bitband.com ([213.8.50.174]:46500 "EHLO mail.bitband.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756667AbYJMXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:38:19 -0400
Subject: Subject: [PATCH 1/2] linux-acpi: sos documentation
From: raz ben yehuda <razb@bitband.com>
To: lenb@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Oct 2008 01:38:13 +0200
Message-Id: <1223941094.5437.17.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raz Ben Yehuda <razb@bitband.com>

Signed-off-by: Raz Ben Yehuda <razb@bitband.com>
---

diff -urpN linux-2.6.27/Documentation/SOS.txt linux-2.6.27-dbg/Documentation/SOS.txt
--- linux-2.6.27/Documentation/SOS.txt	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.27-dbg/Documentation/SOS.txt	2008-10-14 00:29:32.000000000 +0200
@@ -0,0 +1,14 @@
+				SOS
+
+SOS is a service oriented scheduler. SOS is a method of relating one or more
+distinct services to a processor.In other words, a core(s) is assigned to
+a chore, not a chore to a core.
+Technically speaking, by virtually removing a processor from the operating
+system, using Linux ACPI facility one can bind processors to services.
+SOS management and control is done by sosctl.
+To fully understand what is SOS, when should it be used it and for which
+puprose,please refer to http://sos-linux.cvs.sourceforge.net/sos-linux/sos/Documentation/.
+
+Author: Raz Ben Yehuda
+Date: 2/08/2008
+Open University Israel.Computer Sciences Department. MSC.

