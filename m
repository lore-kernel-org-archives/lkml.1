Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYLaKjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYLaKjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYLaKjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:39:13 -0500
Received: from mx02.mailboxcop.com ([206.125.223.72]:46937 "EHLO
	mx02.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbYLaKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:39:13 -0500
Message-ID: <495B4C4E.8040202@jaysonking.com>
Date: Wed, 31 Dec 2008 04:41:18 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       shaggy@linux.vnet.ibm.com, rjw@sisk.pl, fabio.comolli@gmail.com
Subject: Re: Disregard: was Re: large intermittent latency spike 2.6.28 (and
 2.6.27.10), bisect commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 -> Revert
 "sched_clock: prevent scd->clock from moving backwards"
References: <495A96FF.1000200@jaysonking.com> <495B40C1.4080305@jaysonking.com>
In-Reply-To: <495B40C1.4080305@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.48
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333257627 - c2b3d68ecc77
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333257627&m=c2b3d68ecc77&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333257627&m=c2b3d68ecc77&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333257627&m=c2b3d68ecc77&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please disregard this. I just had a latency spike again, so this is 
> not the change I'm looking for... I'll need to look for what is 
> causing it again, apparently not only the make -j 3 I thought, and do 
> another test.

No I was just running the old vanilla kernel again by mistake... So 
disregard the disregard, the problem still stands :) (now is probably a 
good time to get some sleep... sorry for spamming)

I should tell grub to change the default kernel when updating, so stupid 
things like this won't happen.

Jayson
