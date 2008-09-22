Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYIVMKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYIVMKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYIVMK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:10:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48173 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYIVMK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:10:29 -0400
Date: Mon, 22 Sep 2008 14:10:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [Patch 1/3] Tracing/ftrace: Make nop tracer reset previous
	entries
Message-ID: <20080922121010.GA20242@elte.hu>
References: <48D68E06.50504@gmail.com> <20080922121237.13D4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080922093604.GA17258@elte.hu> <c62985530809220506o39264e63k25ccb7a73384335c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809220506o39264e63k25ccb7a73384335c@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/9/22 Ingo Molnar <mingo@elte.hu>:
> >
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >> your patch seems corrupted.
> >> please check again your e-mail client settings.
> >
> > i fixed the extra newlines up and applied the patches to
> > tip/tracing/ftrace, thanks Frédéric!
> >
> > please check Documentation/email-clients.txt about details. There were
> > two problems i saw: overlong lines in the commit description and extra
> > 'double newlines' in the patch itself. (To get around gmail limitations
> > you can send -tip patches as MIME attachments as well.)
> >
> >        Ingo
> >
> 
> Oops. I'm really sorry about that. I was pretty convinced that my
> email client was well configured.
> In the future I will first send myself the patches before any new
> submit to ensure they are not damaged...

no harm was done really, we can cope. I'd suggest you do the 
send-yourself thing once now to check that your practices are OK.

	Ingo
