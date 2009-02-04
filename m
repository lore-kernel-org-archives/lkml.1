Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbZBDNEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbZBDNEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbZBDMvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:51:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45081 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbZBDMvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:51:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.sIE.wuYiJB@chimera>
Subject: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12608
Subject		: 2.6.29-rc powerpc G5 Xorg legacy_mem regression
Submitter	: Hugh Dickins <hugh@veritas.com>
Date		: 2009-01-21 21:12 (15 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3a54014e2a94bd37b7dee5e76e03f7bc4fab49a
References	: http://marc.info/?l=linux-kernel&m=123257250431870&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


