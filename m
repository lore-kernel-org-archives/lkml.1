Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbYLYJ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbYLYJ4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 04:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYLYJ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 04:56:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYLYJ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 04:56:42 -0500
Date: Thu, 25 Dec 2008 10:56:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/ftrace: don't trace on early stage of a
	secondary cpu boot
Message-ID: <20081225095637.GB28479@elte.hu>
References: <49524BD5.9010106@gmail.com> <alpine.DEB.1.10.0812241006010.30121@gandalf.stny.rr.com> <4952B7EA.8060100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4952B7EA.8060100@gmail.com>
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

> Thanks. Note that french people like me are silently cheating with the 
> english language. We have a lot of similar words and we can survive 
> while mumbling english, even with only few basis, but don't tell anyone, 
> it's a secret ;-)

heh.

I guess it helps that more than half a millenium ago the fine folks on 
those islands tried to learn French real hard [by virtue of being 
conquered by the French] - and thus a healthy subset of the English 
language (especially the more newfangled words) has thus become ... erm 
... French? ;-)

Doh, i misspoke. What happened _really_ is that those friendly folks let 
the French in as guests, and during that time of mutual understanding the 
French learned and adopted half of the English language - greatly easing 
communication today.

( And apparently there was some mingling with germanic tribes as well,
  a few thousand years before that. Back then those germanic savages were
  taught bits of proper English as well. )

( And then those folks forked their language into a "British" and "US" 
  versions. It is forwards compatible: if you speak British English then
  by definition you can speak US English, but never the other way around.
  US English was then taught to indian tribes - who, tens of thousands of
  years ago, happened to have spoken the same language that the ancestors
  of the germanic tribes spoke. [Or perhaps they spoke ancient Japanese - 
  memories are a bit fuzzy, records incomplete, and the issue is not fully 
  settled yet.] Anyway, it came around in a happy global circle and they 
  all speak English now! ;)

  [ Except the celts, who insist that they were around even sooner than 
    that - starting in the happy times when you could walk on feet from 
    Scotland to Sweden with only a battle axe in your hand, when you 
    could slide stones weighing tons down an ice glacier and ship them to 
    flatland to build funny stone circles - and from whom everyone else
    on this continent learned all the things worth learning. ]

> I applied your comments, see the patch below.
>
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: [PATCH v3] tracing/ftrace: don't trace on early stage of secondary cpu boot

applied to tip/tracing/ftrace, thanks Frederic!

	Ingo
