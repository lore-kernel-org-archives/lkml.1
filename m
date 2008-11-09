Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYKIVnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYKIVnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYKIVkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:40:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbYKIVkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:40:17 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Joshua Hoblitt" <j_kernel@hoblitt.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
In-Reply-To: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4B0Eqx89uNG.A.ZND.0a1FJB@chimera>
Subject: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 20:43:19 +0100 (CET)
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
Date		: 2008-09-11 16:46 (60 days old)
References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
		  Cyrill Gorcunov <gorcunov@gmail.com>
		  Ingo Molnar <mingo@elte.hu>
		  Cyrill Gorcunov <gorcunov@gmail.com>


