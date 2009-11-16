Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZKPWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZKPWyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZKPWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:54:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZKPWya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Soeren Sandmann" <sandmann@daimi.au.dk>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.PxF.1SdALB@chimera>
Subject: [Bug #14625] Commit d451564 breaks ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14625
Subject		: Commit d451564 breaks ARM
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2009-11-13 15:11 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d4515646699b6ad7b1a98ceb871296b957f3ef47
References	: http://marc.info/?l=linux-kernel&m=125812520315835&w=4


