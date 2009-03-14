Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZCNWAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZCNWAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbZCNV57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:57:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760728AbZCNV5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:57:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Matthias Reichl" <hias@horus.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.3-G.5OCvJB@chimera>
Subject: [Bug #12612] hard lockup when interrupting cdda2wav
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:20:17 +0100 (CET)
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
Date		: 2009-01-28 16:41 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2


