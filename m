Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZATALI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZATALI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZATAFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:05:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbZATAFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:05:36 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Lamparter" <chunkeey@web.de>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Linux wireless" <linux-wireless@vger.kernel.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera>
Subject: [Bug #12260] Regression due to commit 2b80848e3818fb1c (p54usb: support LM87 firmwares)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12260
Subject		: Regression due to commit 2b80848e3818fb1c (p54usb: support LM87 firmwares)
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-12-20 10:45 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2b80848e3818fb1c8ccddc105b065a86c68afa9d
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=12260


