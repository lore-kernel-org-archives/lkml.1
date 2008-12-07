Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYLGWvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYLGWvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYLGWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:47:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbYLGWrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:47:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jay Vosburgh" <fubar@us.ibm.com>, "Jesper Krogh" <jesper@krogh.cc>
References: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
In-Reply-To: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XUKIyYFWoBG.A.7MH.JAFPJB@chimera>
Subject: [Bug #12048] Regression in bonding between 2.6.26.8 and 2.6.27.6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:41:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12048
Subject		: Regression in bonding between 2.6.26.8 and 2.6.27.6
Submitter	: Jesper Krogh <jesper@krogh.cc>
Date		: 2008-11-16 9:41 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=122682977001048&w=4


