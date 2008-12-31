Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYLaAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYLaAXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYLaAXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:23:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbYLaAXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:23:24 -0500
Date: Tue, 30 Dec 2008 16:22:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq fixes
In-Reply-To: <20081229125242.GA22678@elte.hu>
Message-ID: <alpine.LFD.2.00.0812301622180.3082@localhost.localdomain>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <20081228231025.GA31953@elte.hu> <20081229125242.GA22678@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Dec 2008, Ingo Molnar wrote:
> 
> Please pull the latest irq-fixes-for-linus-4 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus-4
> 
> [ shortlog is relative to irq-core-for-linus - can be pulled in any order. ]

There is no branch of that name:

	fatal: Couldn't find remote ref irq-fixes-for-linus-4

maybe you forgot to push it out?

		Linus
