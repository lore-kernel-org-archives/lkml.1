Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267Ab0AJWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0AJWk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0AJWkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:40:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0AJWku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:40:50 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jonathan Nieder" <jrnieder@gmail.com>,
       "Michael Tokarev" <mjt@tls.msk.ru>, "Michal Marek" <mmarek@suse.cz>,
       "Oliver Hartkopp" <oliver@hartkopp.net>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.lV.kNlSLB@chimera>
Subject: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks build
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14907
Subject		: Commit "kbuild: fix bzImage build for x86" breaks build
Submitter	: Oliver Hartkopp <oliver@hartkopp.net>
Date		: 2009-12-19 19:21 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a2ff67c88211026afcbdbc190c13f705dae1b59
References	: http://marc.info/?l=linux-kernel&m=126125050622195&w=4
		  http://marc.info/?l=linux-kernel&m=126114565103300&w=4
		  http://marc.info/?l=linux-kbuild&m=126202819526623&w=2
Handled-By	: Jonathan Nieder <jrnieder@gmail.com>
Patch		: http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319
		  http://patchwork.kernel.org/patch/71957/


