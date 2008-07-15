Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYGORjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYGORjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGORjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:39:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbYGORjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:39:33 -0400
Date: Tue, 15 Jul 2008 10:38:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] RCU updates for v2.6.27
In-Reply-To: <20080714152045.GA29159@elte.hu>
Message-ID: <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
References: <20080714152045.GA29159@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> 
> [ NOTE: due to merge interaction please pull this after 
>   kmemcheck-for-linus. The shortlog is relative to kmemcheck-for-linus. ]

Hmm. I really wanted to wait with kmemcheck, which is huge and I'm not 
entirely convinced yet. So now I'll have to wait for these fixes too, for 
some reason that isn't clear.

Merging stuff for me isn't good, when it then results in me simply not 
pulling at all.

		Linus
