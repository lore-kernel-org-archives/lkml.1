Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZHCKl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZHCKl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZHCKl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:41:56 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36131 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZHCKl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:41:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19062.48839.950183.569219@pilspetsen.it.uu.se>
Date: Mon, 3 Aug 2009 12:41:11 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: 2.6.31-rc5: Reported regressions from 2.6.30
In-Reply-To: <alpine.LFD.2.01.0908021456430.3352@localhost.localdomain>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera>
	<alpine.LFD.2.01.0908021456430.3352@localhost.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc:s trimmed)

Linus Torvalds writes:
 > 
 > 
 > On Sun, 2 Aug 2009, Rafael J. Wysocki wrote:
 > > 
 > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13896
 > > Subject		: 2.6.31-rc4 broke expect and gcc's testsuite
 > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > Date		: 2009-07-29 11:00 (5 days old)
 > > References	: http://marc.info/?l=linux-kernel&m=124885806406520&w=4
 > 
 > I bet this is the same tty bug that got fixed by Ogawa in commit 
 > e043e42bdb. -rc5 has that fix. Mikael?

I didn't identify the actual commit, but yes, 2.6.31-rc5 makes
gcc's testsuite work again.

Thanks,

/Mikael
