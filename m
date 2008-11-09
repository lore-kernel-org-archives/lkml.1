Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYKIVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYKIVqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbYKIVk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:40:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357AbYKIVkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:40:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Miquel van Smoorenburg" <mikevs@xs4all.net>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
In-Reply-To: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4B0Eqx89uNG.A.-PC.tZ1FJB@chimera>
Subject: [Bug #11830] disk statistics issue in 2.6.27
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 20:43:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11830
Subject		: disk statistics issue in 2.6.27
Submitter	: Miquel van Smoorenburg <mikevs@xs4all.net>
Date		: 2008-10-19 11:31 (22 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=427e59f09fdba387547106de7bab980b7fff77be
References	: http://marc.info/?l=linux-kernel&m=122441671421326&w=4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


