Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286Ab0AXWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0AXWRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188Ab0AXWRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:17:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0AXWRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:03 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Deucher" <alexdeucher@gmail.com>,
       "Dave Airlie" <airlied@redhat.com>,
       "Markus Trippelsdorf" <markus@trippelsdorf.de>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.kWG.mKMXLB@chimera>
Subject: [Bug #15017] kexec regression, radeon/kms irq related (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15017
Subject		: kexec regression, radeon/kms irq related (bisected)
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-01-09 18:49 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d8f60cfc93452d0554f6a701aa8e3236cbee4636


