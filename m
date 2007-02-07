Return-Path: <linux-kernel-owner+w=401wt.eu-S965617AbXBGCq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617AbXBGCq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXBGCq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:46:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:29334 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965617AbXBGCq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:46:57 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206235102.GC21969@elte.hu>
References: <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1> <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1> <20070206232828.GA21969@elte.hu>
	 <1170804903.3455.121.camel@dwalker1>  <20070206235102.GC21969@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 18:46:55 -0800
Message-Id: <1170816415.3455.193.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I will respond ....

On Wed, 2007-02-07 at 00:51 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > | If we change the current "timer" entry to be listed as 
> > > | "lapic-timer" and not "IO-APIC-edge" (or one of the other names) 
> > > | and replace it with the count from LOC
> > > 
> > > this is a pretty clear sentence, i dont think i misunderstood 
> > > anything about it. If i did, please point it out specifically.
> > 
> > Geez , man I've corrected this statement already .. [...]
> 
> i'm sorry, but where did you "correct this statement already"? You 
> havent replied to your mail to correct it explicitly, and there's no 
> later statement of yours that says anything near to "let me correct this 
> via X" or "i was wrong here, i meant Y".

I know that you see corrections as responses to your own email, but it's
not universal .. Everyone has their own methodology, AFAIK it's free
form ..

> the only subsequent reference of yours seems to be:
> 
> | I'm not saying we should "fake" anything .. I'm saying list what's 
> | really happening .. In a human readable way .
> 
> what you write here does not read as a 'correction', this disputes my 
> characterisation, suggesting that your original point is still intact. 
> How should i have known that you meant this to be a 'correction' of your 
> original point, and that this (whatever it means precisely) replaces it?
> 
> if you concede a point or correct a statement then /please/ make it 
> clear. There's nothing bad about being wrong or being stupid 
> occasionally, it happens to all of us.

I don't take a literal approach to email, which you seem to be taking ..
I think your seeing this thread as an argument for or against something
and you have taken a position which you diligently stick to..

My position is not fixed. However, your arguing as if my position was
fixed. My perspective of this thread was not to argue for a specific
change, but to throw out changes and see if anything stuck ..

Where my statements were suppose to be loose to begin with, so loose as
to only spark the start of an idea, not to promote something specific.
If you read the start of the thread you'll notice that I gave Thomas two
totally opposite ideas.

"We could just remove the timer entry."
or
"[..]how about adding the interrupts to the list which are driving the
timer ?"

When I started the thread I had a similar position as Thomas, but I was
concerned that I was missing something or the code was missing
something.. This was the reason for starting the thread ..

So I'll gladly concede all points. To me it wasn't about the argument,
or even my own ideas ..

Daniel

