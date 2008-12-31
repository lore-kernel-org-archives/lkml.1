Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYLaSrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYLaSrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYLaSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:47:27 -0500
Received: from mx04.mailboxcop.com ([206.125.223.74]:53010 "EHLO
	mx04.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYLaSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:47:27 -0500
Message-ID: <495BBEBE.6010004@jaysonking.com>
Date: Wed, 31 Dec 2008 12:49:34 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jayson King <dev@jaysonking.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       shaggy@linux.vnet.ibm.com, rjw@sisk.pl, fabio.comolli@gmail.com
Subject: Re: [PATCH] sched_clock: prevent scd->clock from moving backwards,
 take #2
References: <495A96FF.1000200@jaysonking.com> <20081231085417.GB13665@elte.hu>
In-Reply-To: <20081231085417.GB13665@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.35
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333458385 - 2983306500d6
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333458385&m=2983306500d6&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333458385&m=2983306500d6&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333458385&m=2983306500d6&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> Could you try the patch below - does it solve the problem? (and if it 
> solves the problem, and if you have working suspend-to-ram or hibernation 
> on your system then please also double-check that those still work.)
>   
I have your patch installed now and I'll let you know if it hangs again. 
Thanks

