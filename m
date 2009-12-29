Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZL2PiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZL2PiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZL2PiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:38:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZL2PfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:35:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David John" <davidjon@xenontk.org>, "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <srmJ8vMxKPH.A.UwB.PwhOLB@chimera>
Subject: [Bug #14897] i915: Commit 0e442c60 causes flickering
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:28:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14897
Subject		: i915: Commit 0e442c60 causes flickering
Submitter	: David John <davidjon@xenontk.org>
Date		: 2009-12-09 17:26 (21 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
References	: http://marc.info/?l=linux-kernel&m=126037889600769&w=4


