Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZJLKr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZJLKr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZJLKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:47:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZJLKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:47:54 -0400
Date: Mon, 12 Oct 2009 12:47:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: Stanse 1.0.0 released [was: wireless: wl12xx, fix lock
	imbalance]
Message-ID: <20091012104706.GA4599@elte.hu>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com> <1247522068.7178.4.camel@johannes.local> <20090718111948.GD27287@elte.hu> <1247916829.1055.24.camel@johannes.local> <20090718161029.GA16343@elte.hu> <4AD300C8.3090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD300C8.3090502@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0051]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 07/18/2009 06:10 PM, Ingo Molnar wrote:
> >>> Plus static tools like Jiri is working on are very useful as 
> >>> well. I think Coverty does that too and it's a pity we dont have 
> >>> free tools for that. In fact Covery will sweep clean the kernel 
> >>> of such bugs, giving OSS tools like 'stanse' the false 
> >>> impression that there are no such bugs. There are such bugs - 
> >>> there's a constant influx of them. So please work on this, it 
> >>> looks very useful.
> >>
> >> What's "this" in this context?
> > 
> > this == stanse, the static code analyzing thing Jiri mentioned he is 
> > working on. The webpage says it will be under the GPL - that's good. 
> > Jiri, any release date for the source code?
> 
> Hi all. I'm pleased to announce the first official Stanse release.
> 
> For those who are interested, the tool (with other information and
> documentation) is available at
> http://stanse.fi.muni.cz/

the list of bugs found:

  http://stanse.fi.muni.cz/bugs.html

is already impressive!

	Ingo
