Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZAKN6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZAKN6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZAKN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:57:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZAKN5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:57:42 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.7fD.xbfaJB@chimera>
Subject: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12155
Subject		: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2008-11-23 16:17 (50 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5e55aa8db085dad1aabb4574c73c23c7ae571e7b
References	: http://marc.info/?l=linux-kernel&m=122745709926361&w=4


