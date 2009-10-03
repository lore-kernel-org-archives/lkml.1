Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZJCOBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZJCOBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZJCOBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:01:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbZJCOBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:01:04 -0400
Date: Sat, 3 Oct 2009 16:00:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftrace WARNING during boot
Message-ID: <20091003140058.GA20867@elte.hu>
References: <20091003105318.GB32486@mea-ext.zmailer.org> <20091003110002.GA6162@nowhere> <20091003112850.GC32486@mea-ext.zmailer.org> <20091003120046.GC6366@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003120046.GC6366@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Oct 03, 2009 at 02:28:50PM +0300, Matti Aarnio wrote:
> > On Sat, Oct 03, 2009 at 01:00:03PM +0200, Frederic Weisbecker wrote:
> > > On Sat, Oct 03, 2009 at 01:53:18PM +0300, Matti Aarnio wrote:
> > > > This is perhaps already fixed, as I have two a bit newer kernels than this one,
> > > > but reporting is better than being silent..
> > > 
> > > 
> > > Hi,
> > > 
> > > Which kernel is this? Does it happen in the current 2.6.32-rc1 ?
> > 
> > I do know that reading the trace is difficult, but the asked for information
> > is down in there.  Intentionally put there by the kernel-oops coders, I presume.
> 
> 
> Ah ok. It's just that I'm not that familiar with fedora's kernels naming :-)
> 
>  
> > I do use vendor kernels, and Fedora 12 beta program has not yet made
> > 2.6.32-rc1 kernel available.
> > 
> > However this does not appear in 2.6.31.1-56.fc12.x86_64 kernel that 
> > is lattest from vendor, but there I have some other troubles why I 
> > took a bit older kernel. (Other troubles with the xfs filesystem 
> > lock handling.)
> 
> So this looks based on a 2.6.31.1 kernel, more stable. And if it 
> doesn't happen with it, then it's fine.
> 
> That said, it's all about fedora based kernel so it's a bit hard to 
> tell if it came from fedora adds or vanilla kernel code.

Fedora generally doesnt modify any ftrace details.

	Ingo
