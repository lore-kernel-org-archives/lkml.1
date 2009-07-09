Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbZGIPBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbZGIPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbZGIPBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:01:14 -0400
Received: from kroah.org ([198.145.64.141]:52881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761648AbZGIPBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:01:13 -0400
Date: Thu, 9 Jul 2009 08:00:29 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090709150029.GA23943@kroah.com>
References: <20090629114339.GA25552@elf.ucw.cz>
 <20090702200824.GJ10957@kroah.com>
 <20090708084439.GC20020@elf.ucw.cz>
 <a55d774e0907080247x23a2f134p1ecdb079c158df5@mail.gmail.com>
 <20090709095322.GB10937@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090709095322.GB10937@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 11:53:23AM +0200, Pavel Machek wrote:
> Hi!
> 
> > >> Can you resubmit it with the original author descriptions?  It's not
> > >> fair to them to have it shown up as coming from you.
> > >
> > > Yes, done... and thanks.
> > >
> > > Brian... I'd like to submit qdsp5 and smd code, too. Who should be
> > > listed as their authors?
> > 
> > smd is pretty much my fault at this point, though Arve hacks on the
> > PM-related bits.
> > 
> > The latest incarnation of the rpcrouter is me, with a lot of the
> > original work by Iliyan, based heavily on the work Qualcomm did (thus
> > their copyright on it as well as Google's).
> > 
> > qdsp5 is Iliyan.
> > 
> > Might be worth breaking these into at least three pieces (smd,
> > rpcrouter, qdsp5)?
> 
> Sorry, I already submitted the patch. I just listed everyone I could
> find in the sources in From: ; that included san@google but not
> Arve. I hope that's not too bad.

Please split the patch up into the different pieces, with the different
authors.  You shouldn't be sending patches that do more than one thing
at a time anyway :)

thanks,

greg k-h
