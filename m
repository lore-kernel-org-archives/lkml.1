Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbYLGWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbYLGWrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYLGWqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:46:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYLGWqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:46:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Joshua Hoblitt" <j_kernel@hoblitt.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
In-Reply-To: <SeAiKqCewiJ.A.VBH.CAFPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XUKIyYFWoBG.A.Ih.nBFPJB@chimera>
Subject: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:41:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
Subject		: kernel panic: softlockup in tick_periodic() ???
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-09-11 16:46 (88 days old)
References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Ingo Molnar <mingo@elte.hu>
		  Cyrill Gorcunov <gorcunov@gmail.com>


