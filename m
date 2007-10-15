Return-Path: <linux-kernel-owner+w=401wt.eu-S1764948AbXJOLvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764948AbXJOLvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764797AbXJOLvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:51:03 -0400
Received: from mx10.go2.pl ([193.17.41.74]:49666 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764775AbXJOLvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:51:00 -0400
Date: Mon, 15 Oct 2007 13:53:59 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071015115359.GB3015@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local> <470F6C43.4090905@aitel.hist.no> <20071012132929.GA4013@ff.dom.local> <47133E44.3070708@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47133E44.3070708@aitel.hist.no>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 12:17:40PM +0200, Helge Hafting wrote:
> Jarek Poplawski wrote:
> >On Fri, Oct 12, 2007 at 02:44:51PM +0200, Helge Hafting wrote:
> >...
> >  
> >>The point is that we _trust_ intel when they says "this will work".
> >>Therefore, we can use the optimizations. It was never about
> >>legal matters. If we didn't trust intel, then we couldn't
> >>use their processors at all.
> >>    
> >
> >But there was nothing about trust. Usually you don't trust somebody
> >but somebody's opinions. The problem is there was no valid opinion,
> >or this opinion has been changed now (no reason to not trust yet...).
> >  
> "Trusting people or their opinions" is only about use of the
> english language, and not that intersting to bring up here.
> Surely you know that lots of people here have english as
> a secondary language only. Intersting for me to know, but
> probably not for everybody else.

Of curse, I know this problem: sometimes it's very hard to make people
believe it's my secondary language! But this time I didn't see any
language problem. I simply poined out that sometimes trusting could be
not enough - not necessarily in this case.

> >>We couldn't take the chance before. It was not documented
> >>to work, verification by testing would not be trivial at all for
> >>this case.
> >>Linux is about "stability first, then performance".
> >>Now we _know_ that we can have this optimization without
> >>compromising stability. Nobody knew before!
> >>    
> >
> >So, you think this would be the first or the least credibly
> >verified undocumented feature used in linux? Then, it seems
> >I can try to install this linux on my laptop at last! (...
> >And, I can trust you, it will not break anything...?)
> >  
> I never claimed that linux will work on your laptop, so no:
> You can't take my word for that, because I never gave it!
> It is well known that some laptops don't work with linux,
> I have no idea if yours will work, I don't even know what kind it is.

OK, this was supposed to be a joke... (Btw, can you remember burning
linux laptops?) I thought this "stability first" a bit funny, but this
was a really bad joke, sorry.

Thanks for these additional explanations - you are completely right!

Regards,
Jarek P.
