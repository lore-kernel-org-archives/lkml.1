Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZJHTRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZJHTRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbZJHTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:17:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759434AbZJHTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:17:41 -0400
Date: Thu, 8 Oct 2009 12:16:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <20091008190617.GA7817@elte.hu>
Message-ID: <alpine.LFD.2.01.0910081213420.3432@localhost.localdomain>
References: <20091008190617.GA7817@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Ingo Molnar wrote:
> 
> Please pull the latest core-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus
> 
> Sigh ... this now looks a bit large for -rc3, due to the RCU cleanups. 
> When i queued it up in -rc1 it looked acceptable :-/ Should we redo it 
> again to extract the cleanups from the fixes (which cause most of the 
> diffstat increase)?

Gaah.

Looking at the actual patch, it looks ok to me. But I really would have 
preferred to see just fixes by now.

But I'll take it this way.

		Linus
