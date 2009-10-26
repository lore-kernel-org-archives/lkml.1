Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZJZTkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZJZTkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZJZTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:40:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbZJZTkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:40:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Boyan" <btanastasov@yahoo.co.uk>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Ed Tomlinson" <edt@aei.ca>,
       "=?utf-8?q?Fr=C3=A9d=C3=A9ric=20L.=20W.=20Meunier?=" 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
In-Reply-To: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vX3ILojF2dJ.A.lYG.ref5KB@chimera>
Subject: [Bug #14388] keyboard under X with 2.6.31
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 20:31:57 +0100 (CET)
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
Date		: 2009-10-07 20:19 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
References	: http://marc.info/?l=linux-kernel&m=125494753228217&w=4


