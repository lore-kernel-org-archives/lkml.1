Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZHMT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZHMT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZHMT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:27:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbZHMT11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:27:27 -0400
Date: Thu, 13 Aug 2009 12:27:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perfcounters fixes
In-Reply-To: <20090813190455.GA18801@elte.hu>
Message-ID: <alpine.LFD.2.01.0908131225040.28882@localhost.localdomain>
References: <20090813190455.GA18801@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Aug 2009, Ingo Molnar wrote:
> 
> Please pull the latest perfcounters-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

Is this really generally fixing things that should be fixed after -rc?

I'm getting very tired of the perfcounters tree. It's not calming down in 
-rc. I've pulled this, but quite frankly, I think there are commits there 
that you should not have sent me, and I'm getting fed up to the point that 
I suspect next time around I won't pull even the valid things just because 
you're not being careful enough.

		Linus
