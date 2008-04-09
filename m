Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYDIVFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYDIVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYDIVFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:05:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYDIVFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:05:31 -0400
Date: Wed, 9 Apr 2008 23:05:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: build error on x86_64 with x86.git#latest
Message-ID: <20080409210514.GA20807@elte.hu>
References: <86802c440804091036p3a3837e8td8f17d6195561aaf@mail.gmail.com> <20080409204250.GD18968@elte.hu> <20080409210138.GA9660@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409210138.GA9660@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > > commit 0465ac59164eda30f4fe49006a67dd6d2c9fc3cf
> > > Author: Pavel Machek <pavel@suse.cz>
> > > Date:   Wed Feb 20 01:48:39 2008 +0100
> > > 
> > >     suspend: wakeup code in c
> > 
> > oops, that was not meant to be pushed out at all - it was just a 
> > temporary merge which clearly needed more work.
> > 
> > it's all fixed up now - please let me know if you still see any 
> > problems.
> 
> Is there something I could do to pull this? Lu, could you post the 
> patch to fix the first problem you hit?

did you get the patch i sent to you earlier today? That is the patch 
that i included in x86.git mistakenly.

	Ingo
