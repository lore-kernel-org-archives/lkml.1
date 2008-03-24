Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYCXMHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYCXMHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbYCXMG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:06:56 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:43185 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758021AbYCXMGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:06:55 -0400
X-Trace: 685061804/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUHAH4250dRAVlC/2dsb2JhbACBW6US
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast
	Visual Memory Unit
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: J??rn Engel <joern@logfs.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <20080324020832.GA13935@linux-sh.org>
References: <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209035.6324.29.camel@localhost.localdomain>
	 <20080322183200.GD19347@logfs.org>
	 <1206211147.6324.48.camel@localhost.localdomain>
	 <20080322185600.GE19347@logfs.org>
	 <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209035.6324.29.camel@localhost.localdomain>
	 <20080322183200.GD19347@logfs.org>
	 <1206211147.6324.48.camel@localhost.localdomain>
	 <20080324020832.GA13935@linux-sh.org>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 12:06:24 +0000
Message-Id: <1206360384.6283.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Recipient list cut somewhat]


On Mon, 2008-03-24 at 11:08 +0900, Paul Mundt wrote:
> On Sat, Mar 22, 2008 at 06:39:07PM +0000, Adrian McMenamin wrote:
> > On Sat, 2008-03-22 at 19:32 +0100, J??rn Engel wrote:

> > >  I don't mind merging code that isn't up to our standards yet.  But I
> > >  have a bad feeling about a maintainer that does not understand
> > >  review comments.  Since you had similar problems understanding
> > >  Andrew, part of the blame may sit on your side.
> > 
> > I'm sorry that you feel that way, but as you took the hump when I said
> > that this:
> > 
> > "Possibly the big-endian annotations need to trickly though the layers
> > here as well."
> > 
> > Isn't good english (and it's not) and asked you - twice - to explain
> > what you meant. I cannot accept your summary.
> > 
> Just as there's no motivation for others to accept merging your code. You
> really need to work on handling feedback in a less oppositional way if
> you ever want to have your changes merged.
> 
> As far as "good" english goes, this is l-k, hang your degree at the
> door and get off your high horse. Even the native speakers perform
> horrendous atrocities against the english language, that's life, deal
> with it. In technical discussions this doesn't tend to matter at all, as
> long as the meaning is obvious -- which in this case it certainly seems
> to be. If you're speaking a different language, perhaps it's a
> miscommunication or misinterpretation of technical terms rather than
> anything else. Do not automatically assume the blame lies with people who
> are trying to help you.


I have no desire to have a flame war over this. But I didn't understand
the sentence, was told twice that I should act on it and asked twice
simply what it meant. Eg the second time...


"I'm sorry, but the comment above <snap> isn't good english. What do you
mean?"

Not unreasonable I think. After the second time I was told  all
communication would cease. And, yes, that did annoy me, especially when
the next thing I get is someone telling me I didn't listen to them.

I certainly don't expect people to be flawless speakers or writers of
English. But I don't think it is wrong to ask for clarity when something
that doesn't make sense is written.

Bluntly I almost always think the blame lies with me when people point
out mistakes or imperfections in my code - because it usually is. But I
don't think it is unreasonable to ask what people mean.

