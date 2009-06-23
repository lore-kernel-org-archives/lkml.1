Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbZFWNnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbZFWNnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZFWNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:43:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZFWNn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:43:27 -0400
Date: Tue, 23 Jun 2009 15:43:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
Message-ID: <20090623134319.GC3026@elte.hu>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906230530j1cc0efc8i85e9234b2fa0417a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906230530j1cc0efc8i85e9234b2fa0417a@mail.gmail.com>
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


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sat, Jun 13, 2009 at 23:05, Mike Frysinger wrote:
> > While implementing ftracer and ftracer graph support, I found the exact
> > arch implementation details to be a bit lacking (and my x86 foo ain't
> > great).  So after pounding out support for the Blackfin arch, start
> > documenting the requirements/details.
> 
> Steven: were you going to pick this up ?  or should i forward to Andrew ?

The .32 development window for the tracing tree starts in about a 
week. We'll probably fast-track your documentation bits to mainline 
- but until then we try to watch for regressions and make sure -rc1 
is round.

Thanks,

	Ingo
