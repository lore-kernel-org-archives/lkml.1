Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZHBVzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZHBVzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZHBVum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:50:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbZHBVuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:50:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       "Matthias Tingelhoff" <mindo83@t-online.de>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
In-Reply-To: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <iZB3Pj-uj3M.A.-sD.cdgdKB@chimera>
Subject: [Bug #13762] AHCI on HP Compaq 6715s broken, did not detect slots/ports -> unable to boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 20:58:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13762
Subject		: AHCI on HP Compaq 6715s broken, did not detect slots/ports -> unable to boot
Submitter	: Matthias Tingelhoff <mindo83@t-online.de>
Date		: 2009-07-11 20:48 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a76117dfd687ec4be0a9a05214f3009cc5f73a42


