Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZCUTtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZCUTtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZCUTrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:47:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbZCUTrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:47:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew S. Johnson" <andy@asjohnson.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Dmitry Torokhov" <dtor@mail.ru>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
In-Reply-To: <HPkmj74uawF.A.iqE.M8TxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <fnEpM0mQZjO.A.7vF.y8TxJB@chimera>
Subject: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 18:07:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
Subject		: TMDC Joystick no longer works in kernel 2.6.28
Submitter	: Andrew S. Johnson <andy@asjohnson.com>
Date		: 2009-01-10 21:53 (71 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6902c0bead4ce266226fc0c5b3828b850bdc884a
References	: http://marc.info/?l=linux-kernel&m=123162486415366&w=4


