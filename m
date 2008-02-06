Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbYBFVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbYBFVD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbYBFVDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:03:49 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:36743 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYBFVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:03:48 -0500
Date: Wed, 6 Feb 2008 22:03:45 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Greg KH <greg@kroah.com>
Cc: David Newall <davidn@davidnewall.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080206220345.3f5daa27@weinigel.se>
In-Reply-To: <20080206202810.GA16257@kroah.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D9CD.5070001@davidnewall.com>
	<84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	<47A5E67D.9040804@davidnewall.com>
	<1202058820.15090.60.camel@violet>
	<courier.47A84ADB.000047C1@hawking.rebel.net.au>
	<20080205203418.GA5819@kroah.com>
	<20080206211448.78c1a23f@weinigel.se>
	<20080206202810.GA16257@kroah.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 12:28:10 -0800
Greg KH <greg@kroah.com> wrote:

> On Wed, Feb 06, 2008 at 09:14:48PM +0100, Christer Weinigel wrote:
> > On Tue, 5 Feb 2008 12:34:18 -0800
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > In the end, it's up to the copyright holders to enforce the
> > > license. And as I have stated in the past, a number of them have
> > > made public statements as to what they think about this issue.
> > > And it corresponds exactly with what Marcel has stated above.
> > > 
> > > So if you wish to violate the copyright of others, you take the
> > > risk that you might be caught and punished, something that you
> > > and your legal council needs to take into account.
> > 
> > So when do you sue Nvidia, ATI, Atheros, Broadcom[1],
> > M-Systems/Sandisk[2] or Nokia? All those companies distribute binary
> > drivers for Linux without providing source code?
> 
> How do you know that such legal action isn't already happening?

I don't.  But AFAIK no such lawsuits have been made public so far.

ATI/AMD are moving in the right direction already, looking at open
sourcing their drivers.  (How is that going by the way, I haven't had
time to keep up lately).  And that I guss might be thanks to the
competition from Intel on the graphics side.  Or is it due to legal
pressure out of the public eye?  Or has ATI just realised that the
Linux market is big enough that going open source might gain them
enough market share to be worth is?

Anyway, I'm definitely going to vote with my wallet the next time I buy
a laptop.  My last laptop had an Intel graphics chip, because of the
open source graphics drivers.  I chose to buy a slower Intel chip
instead of a faster Radeon model.  And if something comes out of ATI
before I buy a new one, I'll have to graphics chip manufacturers to
choose from.

But would ATI really have been interested in open sourcing their
graphics drives now if they had been sued out of the water a couple of
years ago when they did their first binary drivers for Linux?  I don't
know.

  /Christer

