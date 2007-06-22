Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXFVPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXFVPjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXFVPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:39:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51408 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbXFVPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:39:42 -0400
Date: Fri, 22 Jun 2007 17:39:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622153928.GA2030@elte.hu>
References: <20070622080634.GP3723@sequoia.sous-sol.org> <1182516222.5493.33.camel@localhost.localdomain> <20070622153021.GR3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622153021.GR3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > Chris, thanks a hell of a lot for looking into this!!!
> > 
> > -rt doesn't do much with paravirt, but since both -rt and lguest are two
> > things I love to play with, it was really bothering me that they were
> > not getting along.
> 
> It was bugging me too, now if only I had noticed the compiler warnings 
> ;-)

if only those compiler warnings werent drowning in 1000 other compiler 
warnings? :-/

	Ingo
