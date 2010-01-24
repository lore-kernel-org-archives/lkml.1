Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884Ab0AXWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0AXWiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001Ab0AXWiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:38:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab0AXWhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:37:31 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Oliver Neukum" <oliver@neukum.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.TWH.IZMXLB@chimera>
Subject: [Bug #15134] gobi_loader hangs after commit 8e8dce065088
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15134
Subject		: gobi_loader hangs after commit 8e8dce065088
Submitter	: Matthew Garrett <mjg59@srcf.ucam.org>
Date		: 2010-01-17 2:55 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=126369696509502&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
		  Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://patchwork.kernel.org/patch/73878/


