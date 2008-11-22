Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYKVWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYKVWdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbYKVW3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbYKVW31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Andreas Schwab" <schwab@suse.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.nOD.X8HKJB@chimera>
Subject: [Bug #11925] cdrom: missing compat ioctls
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
Subject		: cdrom: missing compat ioctls
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2008-10-31 14:02 (23 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33c2dca4957bd0da3e1af7b96d0758d97e708ef6
Handled-By	: Andreas Schwab <schwab@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2


