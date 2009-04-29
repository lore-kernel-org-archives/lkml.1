Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZD2TLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZD2TLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZD2TLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:11:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZD2TLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:11:07 -0400
Date: Wed, 29 Apr 2009 21:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
	for per worklet
Message-ID: <20090429191027.GE13139@elte.hu>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org> <20090429133342.GA5987@nowhere> <alpine.DEB.2.00.0904290944290.8066@gandalf.stny.rr.com> <20090429083654.7ecf0100.akpm@linux-foundation.org> <20090429154913.GA6406@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429154913.GA6406@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > > And someone came with a better idea, IMO:
> > > > 
> > > > http://lkml.org/lkml/2009/4/17/105
> > > 
> > > Note,
> > > 
> > > If these ever do get merged, I would be happy to convert ftrace to use 
> > > them to replace my version.
> > 
> > I spose I could use magic powers to sneak it into .30?
> 
> Thanks :)

Andrew: if you do that then please pick up the commit i queued up in 
tip:core/printk.

	Ingo
