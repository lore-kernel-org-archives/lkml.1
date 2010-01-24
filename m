Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509Ab0AXWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0AXWV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246Ab0AXWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:21:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45522 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0AXWRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:17:03 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@linux.intel.com>, "Deepak Saxena" <dsaxena@laptop.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
In-Reply-To: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hE3x9c-4KZM.A.MPG.hKMXLB@chimera>
Subject: [Bug #15032] Oops in uart_resume_port() on resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:04:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15032
Subject		: Oops in uart_resume_port() on resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-01-04 15:47 (21 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
References	: http://marc.info/?l=linux-kernel&m=126262008815689&w=4


