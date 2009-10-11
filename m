Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZJKXGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZJKXGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZJKXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:06:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbZJKXGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.lrB.Rzl0KB@chimera>
Subject: [Bug #14377] "conservative" cpufreq governor broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14377
Subject		: "conservative" cpufreq governor broken
Submitter	: Steven Noonan <steven@uplinklabs.net>
Date		: 2009-10-05 16:32 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f2e21c9610991e95621a81407cdbab881226419b
References	: http://marc.info/?l=linux-kernel&m=125476067108252&w=4


