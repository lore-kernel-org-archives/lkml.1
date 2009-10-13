Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZJMSpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZJMSpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZJMSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:45:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48554 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZJMSpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:45:40 -0400
Date: Tue, 13 Oct 2009 20:44:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT PULL] header fixes
Message-ID: <20091013184457.GA18873@elte.hu>
References: <20091013183601.GA16740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013183601.GA16740@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the header-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git header-fixes-for-linus
> 
> This fixes the sched.h / interrupt.h related fallout from the (very 
> nice) d43c36d header files dependency cleanup.

Ah, i see you just pushed them out as a combo patch so the pull request 
is moot - thanks!

	Ingo
