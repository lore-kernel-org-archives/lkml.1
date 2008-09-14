Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYINPtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYINPtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYINPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:49:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52326 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbYINPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:49:04 -0400
Date: Sun, 14 Sep 2008 17:49:02 +0200
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pmmailinglist@rhlx01.hs-esslingen.de
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Message-ID: <20080914154902.GA30891@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux-pm@lists.osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel
Machek <pavel@suse.cz>
Bcc: 
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Reply-To: 
In-Reply-To: <alpine.LFD.1.10.0809122111480.13819@apollo.tec.linutronix.de>
X-Priority: none

Hi,

> did this happen between rc5 and rc6 ?

On Sun Sept 7 you told me privately that a full git pull of
linus tree would get me the whole clockevent patch series as well,
so I did that at most one day later and this git status quo was
buggy for me here, too (no s2r progress without external events).
Of course I blamed that problem on my own pretty experimental azf3328
clock_event_device work, but apparently not so ;)

So all this is is a "me too" for a state right after the recent clockevent
patch series, not sure when this started.
I did not _notice_ such trouble for any pretty recent kernel right before
this series, though (in particular the noop fixes alone did not exhibit that,
I think).

Andreas
