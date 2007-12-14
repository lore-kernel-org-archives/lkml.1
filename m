Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbXLNKt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbXLNKt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbXLNKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:49:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892AbXLNKtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:49:20 -0500
Date: Fri, 14 Dec 2007 11:49:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/3] x86: clean up asm-x86/page*.h
Message-ID: <20071214104907.GB23964@elte.hu>
References: <476030CE.4050203@goop.org> <20071213102110.GP8977@elte.hu> <47619D0D.4010909@goop.org> <20071213213226.GA11442@elte.hu> <4761B1C3.2000606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4761B1C3.2000606@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > You can force git to non-append jump-pull the remote via changing 
> > .git/refs/remotes/origin/HEAD from:
> >
> >  ref: refs/remotes/origin/master
> >
> > to:
> >
> >  ref: +refs/remotes/origin/master
> >   
> 
> This just gets me lots of "error: refs/remotes/origin/HEAD points 
> nowhere!" messages.  Maybe it will work now I've properly set up a 
> local branch to track the remote branch.  We'll see...

maybe i mis-remembered the syntax.

/me googles around

couldnt find the right syntax :(

	Ingo
