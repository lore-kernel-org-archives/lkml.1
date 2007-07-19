Return-Path: <linux-kernel-owner+w=401wt.eu-S940977AbXGSRmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940977AbXGSRmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939448AbXGSRm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:42:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939895AbXGSRm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:42:26 -0400
Date: Thu, 19 Jul 2007 19:42:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: davidsen@posidon.tmr.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070719174217.GB30061@elte.hu>
References: <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org> <469E8821.3070700@tmr.com> <20070719143214.GA6387@elte.hu> <469F9A2E.5020107@tmr.com> <469F9EC3.8090306@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F9EC3.8090306@tmr.com>
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


* Bill Davidsen <davidsen@tmr.com> wrote:

> Bill Davidsen wrote:
> >Ingo Molnar wrote:
> >>* Bill Davidsen <davidsen@tmr.com> wrote:
> >>
> >>>>Does the patch below help?
> >
> >Doesn't seem to apply against 2.6.22.1, I'm trying 2.6.22.6 as soon as 
> >I recreate it.
> 
> Applied to 2.6.22-git9, building now.

ok, that's fine too.

	Ingo
