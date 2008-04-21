Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYDUOQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYDUOQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYDUOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:16:27 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:35728 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbYDUOQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:16:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgxDAKA+DEhT48OPPGdsb2JhbACBUY98AQEBATCYOg
Message-ID: <480CA1B0.6070406@coderworld.net>
Date: Mon, 21 Apr 2008 16:16:16 +0200
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
References: <200804041222.35025.elendil@planet.nl> <48009D04.3000509@coderworld.net> <480A64B9.2080307@coderworld.net> <200804200005.50236.elendil@planet.nl>
In-Reply-To: <200804200005.50236.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Frans Pop skrev:
> The bug was already traced by me to "sched: fix fair sleepers" (which you 
> list as well), and this was reverted just before the final 2.6.25 release.
> 
> Can you confirm that the issue is fixed for you as well with v2.6.25?
> 
I have been running v2.6.25 for about a day now, and afaics the issue is 
gone.

> Unfortunately most of the communication about this was done by private 
> mails, although I did update the bugzilla entry and replied to the
> "regressions" mails from Rafael. It's a pity if this has caused you 
> unnecessary work.
> 
I didn't know there was an entry for this in bugzilla, thanks for 
sharing. Must have missed the notice on lkml.

> Note that Ingo has just resubmitted the (probably same) patch for 2.6.26 
> [1], so we're not done with this yet.
> 
> Cheers,
> FJP
> 
> [1] http://lkml.org/lkml/2008/4/19/166 (see also my reply)


regards, Richard
