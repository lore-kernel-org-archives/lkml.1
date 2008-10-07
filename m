Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYJGWGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYJGWGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYJGWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:06:44 -0400
Received: from kroah.org ([198.145.64.141]:35120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754059AbYJGWGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:06:44 -0400
Date: Tue, 7 Oct 2008 15:03:03 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20081007220303.GA9066@kroah.com>
References: <48C7FCEE.8060404@kernel.org> <20080917180405.GB3162@kroah.com> <20080918111845.GH27832@elf.ucw.cz> <200809191104.00171.trenn@suse.de> <20080924051417.GA29993@kroah.com> <20081007204011.GG6604@elf.ucw.cz> <20081007211905.GB8151@kroah.com> <20081007214006.GL6604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007214006.GL6604@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:40:06PM +0200, Pavel Machek wrote:
> 
> > > > If you, or anyone else, writes a new driver from the published
> > > > documents, that driver can be accepted.  It can not be based on the
> > > > existing code written by Shem in any form.
> > > 
> > > Can you detail what "published" means?
> > 
> > Published in a way that has NOTHING to do with these source files.
> > 
> > > Either I can take his sources on sourceforge.net (quite well known
> > > place, right) as published information, or I could not use other well
> > > known sources such as wikipedia.
> > 
> > If the wikipedia information was written based on these source files,
> > no, we can't use that, sorry.
> 
> How do I know?

Unfortunatly, you can't, so don't use it.

> > > Sources on sourceforge.net seem published-enough to me, and if you
> > > insist they can't be used, you should provide some reasons...
> > > 
> > > [And no, just calling it "tainted" is not enough.]
> > 
> > {sigh}
> > 
> > Again, for the last time:
> >   - this code was written by an anonymous person, using documents or
> >     information that was obtained and used in a manner that was not
> >     legal according to their employment agreement.
> 
> This code is written by anonymous person. He may have used documents
> improperly, but I see no signs of that, and don't see why I should
> believe you saying so.
> 
> If have proof of that, you should talk to sourceforge to take that
> code down... or probably their employer should ask sourceforge to do
> that.
> 
> The documents are on the web from more than year now, on
> well-known. That seems to indicate that your theory is not true.

Yes, I know this is true, for a variety of reasons of what people
(including the individual in question) told me in private.

And I'm not going to go around asking for code to be taken down, as I'm
not the one whose contract was invalidated.

All I can say is that I can not accept such code into the Linux kernel
as it is known to be created in an illegal manner.

This has been discussed with both the Linux Foundations lawyers
(actually it was OSDL at the time), and with Novell's lawyers.

And as a Novell employee, you aren't allowed to put this code into the
kernel either, sorry, that's the rule we were told.

> >   - so, to get something like this into the kernel, we need to rewrite
> >     the code, using information obtained LEGALLY from either the
> >     manufacturer of the chips or computers, or from another TOTALLY
> >     SEPARATE location.
> 
> I'm LEGALLY obtaining the information from sourceforge.net. That is
> rather well-known, and non-anonymous source. They continue to publish
> this information.

If the information there is known to be posted in a manner that was
obtained illegally, it does not make the fact that you take it any more
"legal".

Ok, once again:
  - we know this code was created illegally.
  - that is why we (Linux Foundation / Novell) can not accept such code.

If some other company wants to step up, and put their "Signed-off-by:"
on it, I will be glad to have the Linux Foundation lawyers contact them
to find out if this is now acceptable, and from what background they
have gotten the information.

So can we please just drop this?  Or do you want me to point you at the
lawyers?

thanks,

greg k-h
