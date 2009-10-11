Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZJKXIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZJKXIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZJKXID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:08:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58169 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbZJKXGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:06:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Boyan" <btanastasov@yahoo.co.uk>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Ed Tomlinson" <edt@aei.ca>,
       "=?utf-8?q?Fr=C3=A9d=C3=A9ric=20L.=20W.=20Meunier?=" 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
Subject: [Bug #14388] keyboard under X with 2.6.31
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 01:01:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14388
Subject		: keyboard under X with 2.6.31
Submitter	: Frédéric L. W. Meunier <fredlwm@gmail.com>
Date		: 2009-10-07 20:19 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
References	: http://marc.info/?l=linux-kernel&m=125494753228217&w=4


