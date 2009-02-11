Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZBKOzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZBKOzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZBKOzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:55:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZBKOzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:55:38 -0500
Date: Wed, 11 Feb 2009 15:55:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pengfei Hu <hpfei.cn@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Using module private memory to simulate microkernel's memory
	protection
Message-ID: <20090211145525.GB10525@elte.hu>
References: <a5f59d880902100542x7243b13fuf40e7dd21faf7d7a@mail.gmail.com> <20090210141405.GA16147@elte.hu> <a5f59d880902110604g40cf17b5w92431f60e6f16fa4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5f59d880902110604g40cf17b5w92431f60e6f16fa4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pengfei Hu <hpfei.cn@gmail.com> wrote:

> >
> > Hm, are you aware of the kmemcheck project?
> >
> >        Ingo
> >
> 
> Frankly, I only know this project's name. Just when I nearly finished
> this patch, I browsed http://git.kernel.org/ first time. I am only a
> beginner in Linux kernel. Maybe I should first discuss before write
> code. But I think it is not too late.
> 
> Can you tell me more about this project? I realy appreciate it.

Sure:

  http://tinyurl.com/cstjhb

	Ingo
