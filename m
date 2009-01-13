Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZAMMuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZAMMuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZAMMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:49:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZAMMtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:49:55 -0500
Date: Tue, 13 Jan 2009 13:49:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
Message-ID: <20090113124921.GA30400@elte.hu>
References: <1231836016.3212.41.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231836016.3212.41.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4352]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> Please pull these patches. Earlier I also floated these patches so that 
> I can get some feedback.

Sam, Andrew, David, what's your workflow preference for these bits?

While they are oneliners and i could create a separate branch for these 
and pull Jaswinder's tree (and do build coverage to make sure there's no 
surprised on any arch), it's really up to the maintainers of these files 
to decide on the workflow.

I'd lean towards doing this via the individual maintainers and/or -mm, but 
no strong feelings ...

Even if it's done via a separate tree at minimum it needs the acks from 
the affected maintainers.

	Ingo
