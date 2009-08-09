Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZHIXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZHIXji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZHIXjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:39:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZHIXja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:39:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mike Snitzer" <snitzer@redhat.com>, "NeilBrown" <neilb@suse.de>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u1L1PAbl8zG.A.RyC.aj1fKB@chimera>
Subject: [Bug #13944] MD raid regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 22:44:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13944
Subject		: MD raid regression
Submitter	: Mike Snitzer <snitzer@redhat.com>
Date		: 2009-08-05 15:06 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=449aad3e25358812c43afc60918c5ad3819488e7
References	: http://marc.info/?l=linux-kernel&m=124948481218857&w=4
Handled-By	: NeilBrown <neilb@suse.de>
Patch		: http://patchwork.kernel.org/patch/39521/


