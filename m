Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbXFOOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbXFOOa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXFOOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:30:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXFOOaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:30:21 -0400
Date: Fri, 15 Jun 2007 16:30:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Poole <mdpoole@troilus.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615143003.GA8775@elte.hu>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org> <200706150127.18069.dhazelton@enter.net> <87sl8tzaj1.fsf@graviton.dyn.troilus.org> <20070615124039.GB21120@elte.hu> <87fy4tz8dc.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fy4tz8dc.fsf@graviton.dyn.troilus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Poole <mdpoole@troilus.org> wrote:

> >> I do not suggest that copyright subsists in the signature or in the 
> >> signing key.  Whether it does is irrelevant to the signing key 
> >> being part of the source code (when the signature is needed for the 
> >> binary to work properly).
> >
> > it is very much relevant. By admitting that the key is not part of 
> > the "work", you have lost all moral basis to claim control over it.
> 
> I have not admitted any such thing.  I have said the key and signature 
> do not have separate copyright protection.  Variables named "i" in a 
> file are not protected by copyright, but they are very much part of 
> the source code in that file.

the problem with your argument is that the definition of what 
constitutes "work" is up to copyright law, _not_ the license writer. 
I.e. you cannot just cleverly define "source code" to include something 
unrelated and then pretend that it's all in one work. And that's exactly 
what the GPLv3 does: it creatively defines the hardware's key into the 
'source code' of the software and then asks for that to be provided 
_not_ because somehow the key derives from the software (it clearly does 
not), but as a "compensation" for the right to redistribute! I.e. it's 
trying to extend its scope to some item that is not part of the 
software. See?

	Ingo
