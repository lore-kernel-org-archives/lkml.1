Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZCAJMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZCAJMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZCAJLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:11:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZCAJLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:11:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFD] Automatic suspend
Date: Sun, 1 Mar 2009 10:11:18 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com> <1235888923.7388.121.camel@pasglop>
In-Reply-To: <1235888923.7388.121.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903011011.20703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 March 2009, Benjamin Herrenschmidt wrote:
> On Sat, 2009-02-28 at 16:06 -0800, Arve Hjønnevåg wrote:
> 
> I'm not taking a position on the merit of the wakelocks per se nor
> whether Rafael is right or wrong here, I haven't looked at the problem
> closely enough. I just want to react to this:
> 
> > The basic concept was developed long before android was a public
> > project.
> 
> This isn't going to bring you any good will. We don't care what was done
> before it was a public project. That has strictly no relevance to how it
> should be submitted upstream.
> 
> How long the code has been simmering internally to company X or Y or
> even in a public tree doesn't matter. Some times, yes, we do take
> something as a whole, when it makes no sense to do otherwise (a driver,
> a filesystem, ...). 
> 
> But something like what you propose, it seems, could easily be broken
> down into a basic concept, on which features are added one after the
> other, and in this case, it's the right way to go, simply because it's
> easier to argue for the basic concept alone if you don't have to handle
> comments froms people who don't agree with aspect A B or C of the other
> features involved.
> 
> And if the basic concept doesn't get accepted in the first place, then
> the whole point is moot...

Exactly.  This is what I've been trying to say for some time now.

Thanks Ben!

Rafael
