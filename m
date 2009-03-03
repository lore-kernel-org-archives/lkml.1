Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZCCWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZCCWTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbZCCWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:15:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZCCWPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:15:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Matthias Reichl" <hias@horus.com>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.ocC.kdarJB@chimera>
Subject: [Bug #12612] hard lockup when interrupting cdda2wav
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:41:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12612
Subject		: hard lockup when interrupting cdda2wav
Submitter	: Matthias Reichl <hias@horus.com>
Date		: 2009-01-28 16:41 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2


