Return-Path: <linux-kernel-owner+w=401wt.eu-S1761847AbZCNV7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761847AbZCNV7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760646AbZCNV54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:57:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760062AbZCNV5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:57:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Patrick Walton" <pcwalton@cs.ucla.edu>,
       "Philipp Kohlbecher" <xt28@gmx.de>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.ywG.xOCvJB@chimera>
Subject: [Bug #12645] DMI low-memory-protect quirk causes resume hang on Samsung NC10
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:20:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12645
Subject		: DMI low-memory-protect quirk causes resume hang on Samsung NC10
Submitter	: Patrick Walton <pcwalton@cs.ucla.edu>
Date		: 2009-02-06 18:35 (37 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0af40a4b1050c050e62eb1dc30b82d5ab22bf221


