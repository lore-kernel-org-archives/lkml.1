Return-Path: <linux-kernel-owner+w=401wt.eu-S936383AbXEVPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383AbXEVPe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966014AbXEVPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:22:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:37762 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965997AbXEVPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:22:33 -0400
Subject: Re: v2.6.21-rt3
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20070522082550.GA8161@elte.hu>
References: <20070517194143.GA25394@elte.hu>
	 <1179778266.15427.38.camel@imap.mvista.com>
	 <1179779053.12708.45.camel@chaos>
	 <1179779142.15427.44.camel@imap.mvista.com>
	 <1179779765.12708.50.camel@chaos>
	 <1179780072.15427.51.camel@imap.mvista.com> <20070522082550.GA8161@elte.hu>
Content-Type: text/plain
Date: Tue, 22 May 2007 08:20:09 -0700
Message-Id: <1179847209.15427.75.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 10:25 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I copied the patch into the first email, I did look at it which is why 
> > you got an email. Your introducing the patch , it's for you to explain 
> > why it needs to be there.. considering that the comment says "hack" in 
> > it, I have to wonder what the non-hack version is ..
> 
> you might not have realized it, but the problem i think was the attitude 
> you showed in the very first sentence:

I was not intending any attitude. I had no idea where those changes came
from ..

> > Where did the arm ep93xx changes come from? It looks like patch below 
> > came in with them in 2.6.21-rt6 ..
> 
> AFAICS Thomas just mirrored that snotty comment back to you, and yes, 
> when you are on the receiving end it feels nasty, doesnt it? So please 
> restart and rephrase that into a more polite form and you might get an 
> answer (although i certainly do not talk for Thomas). Something like:

I don't read the sentence you quoted as snotty at all ..  I had no idea
where the changes came from, and I was simply asking that.. Since there
isn't a history for the -rt patch, I honestly don't know where some of
the code comes from ..

Since I had no idea that Thomas wrote that code, there's no premeditated
aggravation, or flame bait there.. 

> > Thomas, could you give me a bit more information about why the arm 
> > ep93xx changes were done in 2.6.21-rt6? I do not seem to understand 
> > the reason behind that change. I've attached the change below. Thanks!
> 
> You are asking Thomas a favor after all... Be a bit more polite when 
> asking others, and a completely new world might open up for you :-)

I don't see that as me asking a favor.. If a patch crosses LKML and I
ask "Why does this hunk exist?" that's not a favor. That is pure code
review, which is exactly what I was doing in this thread. Which is
reviewing code and asking questions..

I hope you don't read my comments above as snotty cause it's not suppose
to be, just conversation..

Daniel

