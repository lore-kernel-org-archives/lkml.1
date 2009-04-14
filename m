Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZDNLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZDNLF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZDNLFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:05:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDNLFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:05:17 -0400
Date: Tue, 14 Apr 2009 13:04:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/filters: allow user-input to be
	integer-like string
Message-ID: <20090414110457.GN3558@elte.hu>
References: <49E2A594.4060306@cn.fujitsu.com> <20090413144513.GF5977@nowhere> <20090413222951.GG8514@elte.hu> <1239682887.7011.54.camel@tropicana> <49E42C04.3020304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E42C04.3020304@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> This also conflicts with Tom's rewrite of the filter engine to make 
> >> it on-the-fly modifiable.
> >>
> >> Li, mind reworking your series against latest -tip? (it has Tom's 
> >> patch included already)
> >>
> >> Also, it would be nice to hear Tom's opinion about this series as 
> >> well. I know there's new parsing features planned - if it's better 
> >> that way then Tom you might want to pick up Li's patches and submit 
> >> them together with any pending or upcoming changes? We can apply 
> >> them directly too if that's easier to you.
> >>
> > 
> > I had started on the new parser a couple weeks ago, but got sidetracked
> > by other things.  I'll be getting back to it this week, but until it's
> > ready it wouldn't hurt for you to pick up Li's patches, and I'll make
> > any changes I need to in the new code.
> > 
> 
> Ok, I'll rebase those patches and send to Ingo.

Thanks!

	Ingo
