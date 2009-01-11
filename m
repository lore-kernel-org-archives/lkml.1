Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZAKOE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZAKOE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbZAKN6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:58:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbZAKN6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:58:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Tim Blechmann" <tim@klingt.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.hIC.nafaJB@chimera>
Subject: [Bug #12395] 2.6.28-rc9: oprofile regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12395
Subject		: 2.6.28-rc9: oprofile regression
Submitter	: Tim Blechmann <tim@klingt.org>
Date		: 2008-12-21 14:23 (22 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b99170288421c79f0c2efa8b33e26e65f4bb7fb8
References	: http://marc.info/?l=linux-kernel&m=122986946614791&w=4
Handled-By	: Andi Kleen <ak@linux.intel.com>


