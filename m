Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZBNX3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZBNX3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZBNXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:19:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589AbZBNXTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:19:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Patrick Walton" <pcwalton@cs.ucla.edu>,
       "Philipp Kohlbecher" <xt28@gmx.de>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
In-Reply-To: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ROx6X68CGJG.A.MMH.c40lJB@chimera>
Subject: [Bug #12645] DMI low-memory-protect quirk causes resume hang on Samsung NC10
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:50:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12645
Subject		: DMI low-memory-protect quirk causes resume hang on Samsung NC10
Submitter	: Patrick Walton <pcwalton@cs.ucla.edu>
Date		: 2009-02-06 18:35 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0af40a4b1050c050e62eb1dc30b82d5ab22bf221


