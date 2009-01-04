Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZADL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZADL2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZADL2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:28:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZADL2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:28:04 -0500
Date: Sun, 4 Jan 2009 12:27:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       astarikovskiy@suse.de, jbarnes@sgi.com, pazke@orbita1.ru,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/7] x86 rename mpc_config_X to mpc_X
Message-ID: <20090104112726.GA1898@elte.hu>
References: <1230977793.6138.17.camel@jaswinder.satnam> <20090104110725.GA24454@elte.hu> <1231067384.27852.42.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231067384.27852.42.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> On Sun, 2009-01-04 at 12:07 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> > i'm wondering, will you also try the other, more structural cleanups i 
> > suggested?
> 
> Yes, I will do it.
> 
> But if you apply this set then it will easier for me. I am just waiting 
> from you side :-)

Yeah - but there's no need to wait for me - the renames are fine.

	Ingo
