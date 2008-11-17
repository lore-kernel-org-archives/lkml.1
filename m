Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYKQSdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYKQSdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKQSdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:33:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbYKQSdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:33:42 -0500
Date: Mon, 17 Nov 2008 10:33:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117182320.GA26844@elte.hu>
Message-ID: <alpine.LFD.2.00.0811171030180.3468@nehalem.linux-foundation.org>
References: <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu>
 <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Ingo Molnar wrote:
> 
> hm, i'm not sure whether i can post benchmarks from the Nehalem box - 
> but i can confirm it in general terms that it's rather nice ;-)

Intel released the NDA from various web sites a week or two ago, and Intel 
is now selling it in the US (I think today was in fact the official 
launch), so I think benchmarks are safe - you can buy the dang things on 
the street.

I don't know what availability is, of course. But I doubt that Intel would 
mind Nehalem benchmarks even if it were a paper launch - at least from my 
personal experience, I've not seen any bad behavior (and plenty of good).

> This was run on another testbox (4x4 Barcelona) that rocks similarly 
> well in terms of memory subsystem latencies: which seems to be 
> tbench's main current critical path.

Ahh, ok.

			Linus
