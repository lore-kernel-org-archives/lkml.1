Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZESM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZESM1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZESM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:27:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34745 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZESM1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:27:18 -0400
Date: Tue, 19 May 2009 14:26:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: patches in git for irq and numa
Message-ID: <20090519122643.GE14305@elte.hu>
References: <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org> <20090518072952.GA12460@elte.hu> <1242654650.26820.429.camel@twins> <4A1178D5.5050900@kernel.org> <1242659477.26820.433.camel@twins> <4A119990.9020606@kernel.org> <20090519093754.GH31404@elte.hu> <1242729062.26820.488.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242729062.26820.488.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-05-19 at 11:37 +0200, Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > please check following patch
> > > 
> > > Thanks
> > 
> > I've applied it to tip:irq/numa, thanks Yingai. Pushed it out into 
> > tip:master - Peter please check wether:
> > 
> >   3b44254: Merge branch 'irq/numa'
> > 
> > or later versions of -tip work fine on your Opteron box.
> 
> v2.6.30-rc6-1624-g3b44254
> 
> seems to boot again.

Thanks!

	Ingo
