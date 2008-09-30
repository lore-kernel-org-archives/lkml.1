Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYI3Off@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYI3Off (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYI3Of0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:35:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbYI3Of0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:35:26 -0400
Date: Tue, 30 Sep 2008 07:34:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [GIT pull] timer fixes for .27
In-Reply-To: <alpine.LFD.2.00.0809292255490.17289@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0809300733150.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809292255490.17289@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Thomas Gleixner wrote:
> 
> Please pull the latest timers-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Did you forget to push? The tip of that branch is still commit 
1eda81495a49a4ee91d8863b0a441a624375efea ("x86: prevent stale state of 
c1e_mask ...") which I already pulled last week.

		Linus
