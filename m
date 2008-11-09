Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYKIUAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYKIUAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbYKIT4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:56:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbYKIT4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:56:31 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Lukas Hejtmanek" <xhejtman@fi.muni.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.ZQH.G5zFJB@chimera>
Subject: [Bug #11905] lots of extra timer interrupts costing 2W
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
Subject		: lots of extra timer interrupts costing 2W
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-10-30 2:18 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fb02fbc14d17837b4b7b02dbb36142c16a7bf208
References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4


