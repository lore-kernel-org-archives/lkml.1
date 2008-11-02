Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYKBSxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYKBSxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYKBSp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:45:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbYKBSpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:45:21 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mel Gorman" <mel@csn.ul.ie>, "Paul Mackerras" <paulus@samba.org>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
In-Reply-To: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4xS1r6m15_B.A.2F.3ueDJB@chimera>
Subject: [Bug #11907] NVRAM being corrupted on ppc64 preventing boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:49:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11907
Subject		: NVRAM being corrupted on ppc64 preventing boot
Submitter	: Mel Gorman <mel@csn.ul.ie>
Date		: 2008-10-30 14:26 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122537727204584&w=4
Handled-By	: Paul Mackerras <paulus@samba.org>
		  Mel Gorman <mel@csn.ul.ie>
Patch		: http://marc.info/?l=linux-kernel&m=122547833412996&w=4


