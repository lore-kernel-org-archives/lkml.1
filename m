Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbXIMJHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbXIMJHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXIMJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:07:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXIMJHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:07:00 -0400
Date: Thu, 13 Sep 2007 11:06:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913090655.GA28505@elte.hu>
References: <20070911200459.GA6974@elte.hu> <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com> <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Hussey <robjhussey@gmail.com> wrote:

> On 9/11/07, Rob Hussey <robjhussey@gmail.com> wrote:
> > Hi Ingo,
> >
> > When compiling, I get:
> 
> Yeah, this was my fault :(
> 
> I've had a chance to test this now, and everything feels great. I did
> some benchmarks for 2.6.23-rc1, 2.6.23-rc6-cfs, and
> 2.6.23-rc6-cfs-devel:

thanks for the numbers! Could you please also post the .config you used? 
Thx,

	Ingo
