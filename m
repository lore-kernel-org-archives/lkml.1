Return-Path: <linux-kernel-owner+w=401wt.eu-S937429AbXGSIyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937429AbXGSIyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbXGSIx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:53:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538AbXGSIxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:53:55 -0400
Date: Thu, 19 Jul 2007 10:53:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: davidsen@posidon.tmr.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070719085340.GA25017@elte.hu>
References: <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org> <469E8821.3070700@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E8821.3070700@tmr.com>
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

> > Does the patch below help?
>
> Spectacularly no! With this patch the "glitch1" script with multiple 
> scrolling windows has all xterms and glxgears stop totally dead for 
> ~200ms once per second. I didn't properly test anything else after 
> that. Since the automount issue doesn't seem to start until something 
> kicks it off, I didn't see it but that doesn't mean it's fixed.

thanks. Andrew also just reported that it broke his laptop and i'm 
working on a proper version.

	Ingo
