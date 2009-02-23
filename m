Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbZBXAk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbZBXAk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbZBXAfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:35:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378AbZBXAfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:35:01 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Matthias Reichl" <hias@horus.com>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
In-Reply-To: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LLno3yT_fnC.A.SBH.NzzoJB@chimera>
Subject: [Bug #12612] hard lockup when interrupting cdda2wav
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 23:03:04 +0100 (CET)
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
Date		: 2009-01-28 16:41 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=123316111415677&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Patch		: http://marc.info/?l=linux-scsi&m=123371501613019&w=2


