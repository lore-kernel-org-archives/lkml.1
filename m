Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZBDNGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZBDNGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZBDMv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:51:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45110 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbZBDMv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:51:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Schwab" <schwab@suse.de>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.d9C.euYiJB@chimera>
Subject: [Bug #12621] Resume broken on iBook
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12621
Subject		: Resume broken on iBook
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2009-02-01 16:54 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=aa8c6c93747f7b55fa11e1624fec8ca33763a805
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20085&action=view


