Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYKQRko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYKQRko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYKQRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:40:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbYKQRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:40:34 -0500
Date: Mon, 17 Nov 2008 09:38:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <4921AAD6.3010603@cosmosbay.com>
Message-ID: <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu>
 <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Eric Dumazet wrote:

> Ingo Molnar a écrit :

> > it gives a small speedup of ~1% on my box:
> > 
> >    before:      Throughput 3437.65 MB/sec 64 procs
> >    after:       Throughput 3473.99 MB/sec 64 procs
> 
> Strange, I get 2350 MB/sec on my 8 cpus box. "tbench 8"

I think Ingo may have a Nehalem. Let's just say that those things rock, 
and have rather good memory throughput.

		Linus
