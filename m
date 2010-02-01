Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0BAA6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:58:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0BAA5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:57:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Thomas Meyer" <thomas@m3y3r.de>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.TKG.HHiZLB@chimera>
Subject: [Bug #14670] i915: playing video via XVideo extension makes the screen flicker
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14670
Subject		: i915: playing video via XVideo extension makes the screen flicker
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-11-23 13:15 (70 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b42d4c5c6a872815d711e5d51a600f5122c38eee
References	: http://lkml.org/lkml/2010/1/11/150


