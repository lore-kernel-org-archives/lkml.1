Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYKIT6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYKIT6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYKIT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:56:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbYKIT4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:56:00 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, "Jimmy.Jazz@gmx.net"@ogre.sisk.pl,
       "Neil Brown" <neilb@suse.de>, "Tejun Heo" <tj@kernel.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.Wm.i5zFJB@chimera>
Subject: [Bug #11873] unable to mount ext3 root filesystem due to htree_dirblock_to_tree
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11873
Subject		: unable to mount ext3 root filesystem due to htree_dirblock_to_tree
Submitter	: Jimmy.Jazz@gmx.net
Date		: 2008-10-28 05:09 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4c46501d1659475dc6c89554af6ce7fe6ecf615c
Handled-By	: Tejun Heo <tj@kernel.org>
		  Neil Brown <neilb@suse.de>


