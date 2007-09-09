Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbXIIVNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbXIIVNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbXIIVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:11:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42910 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685AbXIIVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:11:44 -0400
Date: Sun, 9 Sep 2007 14:12:56 -0700
From: Greg KH <greg@kroah.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       len.brown@intel.com, linux-ide@vger.kernel.org, dz@debian.org,
       minyard@acm.org, j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org,
       rlove@rlove.org, bzolnier@gmail.com, dmitry.torokhov@gmail.com,
       mzxreary@0pointer.de, stelian@popies.net, ibm-acpi@hmh.eng.br,
       ambx1@neo.rr.com, gimli@dark-green.com
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
Message-ID: <20070909211256.GB6310@kroah.com>
References: <20070901142719.GA31990@havoc.gtf.org> <20070901153644.GA530@kroah.com> <46D98CD0.9040206@garzik.org> <20070909175142.GB32447@kroah.com> <20070909202442.GA21086@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909202442.GA21086@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:24:42PM +0200, Sam Ravnborg wrote:
> > >
> > > I was just going to push it myself, but have no strong feelings on the 
> > > matter.
> > 
> > Ok, you can push it, that's fine with me.  Feel free to add my:
> > 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > if you want.
> That should be "Acked-by:" since the patch does not pass via you but you
> acknowledge it is OK by your Ack.

Well, as I am the maintainer for that subsystem, and I did review the
patch and it looks good, that is a bit more than just an "ack" :)

But whatever you want, I'm not going to get technical here with
"reviewed-by" and such right now...

thanks,

greg k-h
