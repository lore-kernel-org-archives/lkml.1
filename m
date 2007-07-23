Return-Path: <linux-kernel-owner+w=401wt.eu-S934934AbXGWT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934AbXGWT5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762959AbXGWT5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:57:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59994 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761177AbXGWT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:57:30 -0400
Subject: Re: [PATCH] release quicklist before free_page
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070723185832.GA31151@elte.hu>
References: <20070723152129.036573829@mvista.com>
	 <1185208378.8197.20.camel@twins> <1185207979.2573.55.camel@imap.mvista.com>
	 <20070723182301.GA27789@elte.hu> <1185215232.2573.72.camel@imap.mvista.com>
	 <20070723185832.GA31151@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 12:46:05 -0700
Message-Id: <1185219965.2573.127.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 20:58 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > (btw, your comment above comes off very snide, which I don't 
> > appreciate. I haven't done anything that remotely warrants that.)
> 
> That snideness is simply a reflection, to make you realize how it feels. 
> I tried to point this issue out to you in the past, but here we go 
> again, back to square one. But i'm not giving up on you :-)

I could say the same thing ".. here we go again .." 
 
> Peter sent a patch to a subtly buggy patch of yours (which introduces a 
> bug worse than it fixes), with this comment:

I'm with you up to this point ..

>  | | How about this - compile tested only
> 
> and you replied in this almost flagrant tone:
> 
>  | How about a comment to go with it ?  Which says something like what's 
>  | above, notes on how the locking is getting used.. "

before I sent this I must have accidentally delete the "Ok." which
originally proceeded the above.

> that kind of tone can be offensive, in such a context. I _know_ you 
> (still) dont realize it as offensive and that you dont accept my 
> characterisation of it, but nevertheless it's a fact and i'm going to 
> complain about it to you when i see you do it.

I do disagree with the way your accepting this .. I wouldn't say "It's a
fact" either, since I don't accept similar comments from other people
the way your accepting it .. English generally is pretty loose. I could
say "That car is bad" which could literally mean the car is good or
nice.. There is a whole cornucopia of things that need to be considered.

> A proper polite answer to the helpful patch of Peter would have been 
> what i suggested:
> 
> > > how about: "if you've got some time then please also add a few 
> > > comments, because the code was quite non-obvious to me and I 
> > > misunderstood it when I tried to fix it. Thanks."
> 
> the basis of writing such replies is a certain level of humility and 
> fundamental respect towards the capabilities of other kernel developers. 
> Do you have it? If yes, are you willing to express it? If yes then 
> please do so.

I didn't argue with Peter , which means I agree with what he said .. He
was right, I was wrong and I accepted what he said in it's entirety ..
Certainly there is a level of respect there.. Had I argued with him it
would be different .

I'm a minimalist .. I don't say more than I need to, and it's not about
respect or superiority .. For example, I don't like saying "I think" or
"My opinion is" since that's implicit in my comments. If I'm writing
something clearly that's my opinion .. And a question mark alone
represents "Do you have it? If yes, are you willing to express it? If
yes then please do so"

Daniel

