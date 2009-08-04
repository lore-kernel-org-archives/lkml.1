Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbZHDIHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbZHDIHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZHDIHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:07:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbZHDIH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:07:29 -0400
Date: Tue, 4 Aug 2009 10:07:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       Matt Fleming <matt@console-pimps.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in
	the .text section
Message-ID: <20090804080723.GB18635@elte.hu>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com> <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com> <20090727222935.GA22208@linux-sh.org> <alpine.DEB.2.00.0907271941360.30108@gandalf.stny.rr.com> <20090802081602.GB5011@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802081602.GB5011@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> > Could you push these off to Linus? My git pull request had:
> > 
> > Message-ID: <20090723210047.294710482@goodmis.org>
> 
> This is still outstanding. Should I just merge it in to my tree 
> and send it to Linus instead?

No need, i've picked them up for -rc6.

Thanks,

	Ingo
