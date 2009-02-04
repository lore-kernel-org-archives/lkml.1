Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZBDM6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZBDM6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbZBDMuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbZBDMuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Sandeen" <sandeen@sandeen.net>,
       "Lachlan McIlroy" <lachlan@sgi.com>, "Paul Martin" <pm@debian.org>,
       "" <sandeen@sandeen.net>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.EYF.IvYiJB@chimera>
Subject: [Bug #12538] xfs_fsr fails on 2.6.29-rc kernels
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12538
Subject		: xfs_fsr fails on 2.6.29-rc kernels
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-01-25 13:02 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=743bb4650da9e2595d6cedd01c680b5b9398c74a
Handled-By	: Eric Sandeen <sandeen@sandeen.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=19986&action=view


