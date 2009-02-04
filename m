Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZBDNCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZBDNCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZBDMur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbZBDMup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:45 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Jan Kara" <jack@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.cfE.1uYiJB@chimera>
Subject: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12604
Subject		: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Submitter	: Jan Kara <jack@suse.cz>
Date		: 2009-01-30 1:23 (6 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31a12666d8f0c22235297e1c1575f82061480029
References	: http://marc.info/?l=linux-kernel&m=123327862901800&w=4


